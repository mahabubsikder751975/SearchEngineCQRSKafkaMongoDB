namespace Search.Cmd.Api.Commands
{
    public interface ICommandHandler
    {
        Task HandleAsync(NewSearchCommand command);
        Task HandleAsync(DeleteSearchCommand command);

        Task HandleAsync(RestoreReadDbCommand command);

        Task HandleAsync(NewSearchHistoryCommand command);

        Task HandleAsync(DeleteSearchHistoryCommand command);

         Task HandleAsync(DeleteAllSearchHistoryCommand command);

    }
}