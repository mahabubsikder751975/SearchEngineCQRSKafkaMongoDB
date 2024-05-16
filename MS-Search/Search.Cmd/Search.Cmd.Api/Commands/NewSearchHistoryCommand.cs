using CQRS.Core.Commands;

namespace Search.Cmd.Api.Commands
{
    public class NewSearchHistoryCommand:BaseCommand
    {
        public string UserCode { get; set; }
        public string ContentId { get; set; }
        public string ContentType { get; set; }
        public DateTime CreatedDate { get; set; }
        public string TrackType { get; set; }
    }
}