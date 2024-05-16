using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Api.Queries
{
    public interface IQueryHandlerSuggestion
    {
        Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextFromHistoryQuery query);

        Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextQuery query);
    }
}