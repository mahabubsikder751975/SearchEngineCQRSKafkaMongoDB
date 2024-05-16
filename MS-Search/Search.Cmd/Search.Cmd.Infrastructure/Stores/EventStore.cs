using CQRS.Core.Domain;
using CQRS.Core.Events;
using CQRS.Core.Exceptions;
using CQRS.Core.Infrastructure;
using CQRS.Core.Producers;
using Search.Cmd.Domain.Aggregates;

namespace Search.Cmd.Infrastructure.Stores
{
    /// <summary>
    /// Save events in the Event store and once a new event successfully persisted a new event,
    /// we need to produce an event to Kafka
    /// </summary>
    public class EventStore : IEventStore
    {
        private readonly IEventStoreRepository _eventStoreRepository; 

        private readonly IEventProducer _eventProducer;

         public EventStore(IEventStoreRepository eventStoreRepository, IEventProducer eventProducer)
        {
            _eventStoreRepository = eventStoreRepository;
            _eventProducer = eventProducer;
        }

        public async Task<List<Guid>> GetAggregateIdsAsync()
        {
            var eventStream = await _eventStoreRepository.FindAllAsync();

             if (eventStream==null || !eventStream.Any())
                throw new ArgumentNullException(nameof(eventStream),"Could not retrive event stream from event store");

             return eventStream.Select(x=>x.AggregateIdentifier).Distinct().ToList();   

        }

        /// <summary>
        /// Returns all the events for the given aggregateid
        /// </summary>
        /// <param name="aggregateid"></param>
        /// <returns></returns>
        /// <exception cref="AggregateNotFoundException"></exception>
        public async Task<List<BaseEvent>> GetEventAsync(Guid aggregateid)
        {
            var eventStream = await _eventStoreRepository.FindByAggregateId(aggregateid);
            if (eventStream==null || !eventStream.Any())
                throw new AggregateNotFoundException("Incorrect search id provided");
            
            return eventStream.OrderBy(x=> x.Version).Select(x=>x.EventData).ToList();
        }

        /// <summary>
        /// Save all unsaved changes to the aggregate in the form of events.
        /// ToDo: Add a transaction to confirm both the persisting to the event store 
        /// and the producing to Kafka succeeds, then commit the transaction
        /// </summary>
        /// <param name="aggregateid"></param>
        /// <param name="events"></param>
        /// <param name="expectedversion"></param>
        /// <returns></returns>
        /// <exception cref="ConcurrencyException"></exception>

        public async Task SaveEventAsync(Guid aggregateid,IEnumerable<BaseEvent> events, int expectedversion)
        {
             var eventStream = await _eventStoreRepository.FindByAggregateId(aggregateid);

             //optimistic concurrency control check to find expected version before persisting a new events to events store.
            if (expectedversion!=-1 &&  eventStream[^1].Version != expectedversion)
                throw new ConcurrencyException("Incorrect search id provided");
            
            var version = expectedversion;
            //looping through all of our events to store in the Event store
            foreach (var @event in events)
            {
                version++;
                @event.Version=version;
                var eventType = @event.GetType().Name;

                var eventModel = new EventModel {
                    TimeStamp=DateTime.Now,
                    AggregateIdentifier=aggregateid,
                    AggregateType = nameof(AggregateRoot),
                    Version=version,
                    EventType = eventType,
                    EventData = @event
                };
                //Saving into MongoDB
                await _eventStoreRepository.SaveAsync(eventModel);
                //Publishing events to Kafka
                var topic = Environment.GetEnvironmentVariable("KAFKA_TOPIC");
                await _eventProducer.ProduceAsync(topic, @event);
            }
            
        }
      
    }
}