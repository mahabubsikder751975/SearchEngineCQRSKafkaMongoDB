using CQRS.Core.Commands;

namespace Search.Cmd.Api.Commands
{    
    public class DeleteAllSearchHistoryCommand:BaseCommand
    {
        public string UserCode {get; set;}
        
    }
}