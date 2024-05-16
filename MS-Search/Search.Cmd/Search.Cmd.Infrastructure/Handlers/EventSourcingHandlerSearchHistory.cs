using System.Security.Cryptography.X509Certificates;
using CQRS.Core.Domain;
using CQRS.Core.Handlers;
using CQRS.Core.Infrastructure;
using CQRS.Core.Producers;
using Search.Cmd.Domain.Aggregates;

namespace Search.Cmd.Infrastructure.Handlers
{
    /// <summary>
    /// Create Concrete Event Sourcing Handler  
    /// </summary>
    public class EventSourcingHandlerSearchHistory : IEventSourcingHandler<SearchHistoryAggregate>
    {
        private readonly IEventStore  _eventStore;

        private readonly IEventProducer _eventProducer;

        public EventSourcingHandlerSearchHistory(IEventStore eventStore, IEventProducer eventProducer)
        {
            _eventStore = eventStore;
            _eventProducer=eventProducer;
        }
        public async Task<SearchHistoryAggregate> GetbyIdAsync(Guid aggregateId)
        {
            var aggregate = new SearchHistoryAggregate();

            //getting all the events that are linked by the given aggregate id
            var events = await _eventStore.GetEventAsync(aggregateId);
            
            //if it is a new instance of aggregate with no events associated
            if (events==null || !events.Any()) return aggregate;
            
            //If we do have events in the aggregate, 
            //lets invoke the replay events method and passing all of our events to effectively recreate 
            //the latest state of the aggregate.
            aggregate.ReplayEvents(events);
            aggregate.Version = events.Select(X=>X.Version).Max();

            //returns the aggregate which was successfully restored or replayed from the Event Store.
            return aggregate;
        }

        public async Task RepublishEventsAsync()
        {
            var aggregateIds = await _eventStore.GetAggregateIdsAsync();
             if (aggregateIds==null || !aggregateIds.Any()) return;

             foreach (var aggregateId in aggregateIds)
             {
                var aggregate = await GetbyIdAsync(aggregateId); 
                if (aggregate==null || !aggregate.Active) continue;
                var events = await _eventStore.GetEventAsync(aggregateId);

                foreach (var @event in events)
                {
                    var topic = Environment.GetEnvironmentVariable("KAFKA_TOPIC");

                    await _eventProducer.ProduceAsync(topic,@event);    

                    
                }

             }
        }

        public async Task SaveAsync(AggregateRoot aggregate)
        {
            //save uncommitted events for the given aggregate id and mark them Commited
            await _eventStore.SaveEventAsync(aggregate.Id,aggregate.GetUncommittedChanges(),aggregate.Version);
            aggregate.MarkChangesAsCommited();
        }

       
    }
}