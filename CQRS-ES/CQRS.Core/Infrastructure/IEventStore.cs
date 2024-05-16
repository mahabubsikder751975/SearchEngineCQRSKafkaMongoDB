using CQRS.Core.Domain;
using CQRS.Core.Events;

namespace CQRS.Core.Infrastructure
{
    public interface IEventStore
    {
        Task SaveEventAsync(Guid aggregateid, IEnumerable<BaseEvent> events, int expectedversion);
        Task<List<BaseEvent>> GetEventAsync(Guid aggregateid);

        Task<List<Guid>> GetAggregateIdsAsync();
    }
}
