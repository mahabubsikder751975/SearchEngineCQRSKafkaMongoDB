using CQRS.Core.Commands;

namespace Search.Cmd.Api.Commands
{
    public class DeleteSearchHistoryCommand:BaseCommand
    {
        public string UserCode {get; set;}
        
    }
}