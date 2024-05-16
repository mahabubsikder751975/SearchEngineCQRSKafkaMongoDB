using CQRS.Core.Events;

namespace Search.Common.Events
{
    public class SearchHistoryCreatedEvent: BaseEvent
    {
        public SearchHistoryCreatedEvent():base(nameof(SearchHistoryCreatedEvent))
        {
            
        }   

        public string UserCode { get; set; }
        public string ContentId { get; set; }
        public string ContentType { get; set; }
        public DateTime CreatedDate { get; set; }
        public string TrackType { get; set; }

    }
}