using CQRS.Core.Domain;

namespace CQRS.Core.Handlers
{
    /// <summary>
    /// Event sourcing handler interface
    /// </summary>
    public interface IEventSourcingHandler<T>
    {
        Task SaveAsync(AggregateRoot aggregate);
        Task<T> GetbyIdAsync(Guid aggregateId);                          
        //Republish all events to restore read database
        Task RepublishEventsAsync(); 
    }
}