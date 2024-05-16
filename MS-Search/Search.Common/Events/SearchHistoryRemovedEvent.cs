using CQRS.Core.Events;

namespace Search.Common.Events
{
    public class SearchHistoryRemovedEvent : BaseEvent
    {
        public SearchHistoryRemovedEvent() : base(nameof(SearchHistoryRemovedEvent))
        {
        }
    }
}