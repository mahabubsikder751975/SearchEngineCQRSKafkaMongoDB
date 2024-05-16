using CQRS.Core.Commands;

namespace Search.Cmd.Api.Commands
{
    public class DeleteSearchCommand:BaseCommand
    {
        public string UserName {get; set;}
        
    }
}