using CQRS.Core.Events;

namespace Search.Common.Events
{
    public class SearchRemovedEvent : BaseEvent
    {
        public SearchRemovedEvent() : base(nameof(SearchRemovedEvent))
        {
        }
    }
}