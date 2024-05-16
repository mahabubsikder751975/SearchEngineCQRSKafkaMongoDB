using CQRS.Core.Commands;

namespace Search.Cmd.Api.Commands
{
    public class NewSearchCommand:BaseCommand
    {
        public string UserName {get; set; }
        public string SearchText {get; set;}
    }
}