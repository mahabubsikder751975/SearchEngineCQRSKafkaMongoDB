using CQRS.Core.Events;

namespace Search.Common.Events
{
    public class SearchCreatedEvent: BaseEvent
    {
        public SearchCreatedEvent():base(nameof(SearchCreatedEvent))
        {
            
        }   

        public string UserName { get; set; }
        public string SearchText { get; set; }

        public DateTime DateSearched { get; set; }

    }
}