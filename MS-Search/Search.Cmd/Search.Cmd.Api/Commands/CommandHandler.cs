
using CQRS.Core.Handlers;
using Search.Cmd.Domain.Aggregates;

namespace Search.Cmd.Api.Commands
{
    public class CommandHandler : ICommandHandler
    {
        private readonly IEventSourcingHandler<SearchAggregate> _eventSourcingHandler;
        private readonly IEventSourcingHandler<SearchHistoryAggregate> _searchHistoryEventSourcingHandler;

        public CommandHandler(IEventSourcingHandler<SearchAggregate> eventSourcingHandler,IEventSourcingHandler<SearchHistoryAggregate> searchHistoryEventSourcingHandler)
        {
            _eventSourcingHandler = eventSourcingHandler;
            _searchHistoryEventSourcingHandler = searchHistoryEventSourcingHandler;
        }
        public async Task HandleAsync(NewSearchCommand command)
        {
            var aggregate = new SearchAggregate(command.Id,command.UserName,command.SearchText);
            await _eventSourcingHandler.SaveAsync(aggregate);
        }

        public async Task HandleAsync(DeleteSearchCommand command)
        {
             var aggregate = await _eventSourcingHandler.GetbyIdAsync(command.Id);
             aggregate.DeleteSearch(command.UserName);

             await _eventSourcingHandler.SaveAsync(aggregate);
        }

        public async Task HandleAsync(RestoreReadDbCommand command)
        {
            await _eventSourcingHandler.RepublishEventsAsync();
             
        }

        public async Task HandleAsync(NewSearchHistoryCommand command)
        {
            var aggregate = new SearchHistoryAggregate(command.Id,command.UserCode,command.ContentId,command.ContentType,command.TrackType);
            await _eventSourcingHandler.SaveAsync(aggregate);
        }

        public async Task HandleAsync(DeleteSearchHistoryCommand command)
        {
              var aggregate = await _searchHistoryEventSourcingHandler.GetbyIdAsync(command.Id);
             aggregate.DeleteSearchHistory(command.UserCode);

             await _eventSourcingHandler.SaveAsync(aggregate);
        }
    }
}