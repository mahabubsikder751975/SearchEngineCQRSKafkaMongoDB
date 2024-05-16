using System.Security.Cryptography.X509Certificates;
using CQRS.Core.Domain;
using CQRS.Core.Events;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using Search.Cmd.Infrastructure.Config;

namespace Search.Cmd.Infrastructure.Repositories
{
    public class EventStoreRepository : IEventStoreRepository
    {
        private readonly IMongoCollection<EventModel> _eventstorecollection;

        public EventStoreRepository(IOptions<MongoDBConfig> config)
        {
            var mongoClient = new MongoClient(config.Value.ConnectionString);
            var mongoDatabase = mongoClient.GetDatabase(config.Value.Database);
            _eventstorecollection = mongoDatabase.GetCollection<EventModel>(config.Value.Collection);
        }

        public async Task<List<EventModel>> FindAllAsync()
        {
            return await _eventstorecollection.Find(x=>true).ToListAsync().ConfigureAwait(false);
        }

        public async Task<List<EventModel>> FindByAggregateId(Guid aggregateid)
        {
            //Mahabub on 26/03/2024: to avoiding deadlocks and improved performances used .ConfigureAwait(false)
            return await _eventstorecollection.Find(x=>x.AggregateIdentifier==aggregateid).ToListAsync().ConfigureAwait(false);
        }


        public async Task SaveAsync(EventModel @event)
        {
            await _eventstorecollection.InsertOneAsync(@event).ConfigureAwait(false);
        }
    }
}