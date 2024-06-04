using CQRS.Core.Events;

namespace Search.Common.Events
{
    public class AllSearchHistoryRemovedEvent : BaseEvent
    {
        public AllSearchHistoryRemovedEvent() : base(nameof(AllSearchHistoryRemovedEvent))
        {
        }
        public string UserCode { get; set; }
    }
}
