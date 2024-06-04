using Search.Common.Events;

namespace Search.Query.Infrastructure.Handlers
{
    /// <summary>
    /// Purpose is to provide an interface abstraction through which all of event objects can be handled 
    /// once they have been consumed from Kafka
    /// </summary>
    public interface IEventHandler
    {
        Task On(SearchCreatedEvent @event);       
        Task On(SearchRemovedEvent @event);

        Task On(SearchHistoryCreatedEvent @event);       
        Task On(SearchHistoryRemovedEvent @event);

        Task On(AllSearchHistoryRemovedEvent @event);
        
    }
}