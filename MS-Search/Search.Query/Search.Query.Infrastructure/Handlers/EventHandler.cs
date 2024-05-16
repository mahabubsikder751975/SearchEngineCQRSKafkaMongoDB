using Search.Common.Events;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;

namespace Search.Query.Infrastructure.Handlers
{
    /// <summary>
    /// Implement the concrete event handler class that will handle each of these events and use them to populate SM Search DB
    /// </summary>
    public class EventHandler : IEventHandler
    {
        private readonly ISearchRepository _searchRepository;         

        public EventHandler(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;            
        }

        public async Task On(SearchCreatedEvent @event)
        {
            var search = new SearchEntity
            {
                SearchId = @event.Id,
                UserName = @event.UserName,
                DateSearched = @event.DateSearched,
                SearchText = @event.SearchText
            };

            await _searchRepository.CreateAsync(search);
        }
       

        public async Task On(SearchRemovedEvent @event)
        {
            await _searchRepository.DeleteAsync(@event.Id);
        }

        public async Task On(SearchHistoryCreatedEvent @event)
        {
            var search = new SearchHistoryEntity
            {
                Id =   @event.Id,
                UserCode = @event.UserCode,
                ContentId = @event.ContentId,
                Type = @event.ContentType,
                TrackType = @event.TrackType,
                CreateDate = @event.CreatedDate
            };

            await _searchRepository.CreateAsync(search);
        }
       

        public async Task On(SearchHistoryRemovedEvent @event)
        {
            await _searchRepository.DeleteHistoryAsync(@event.Id);
        }


    }
}