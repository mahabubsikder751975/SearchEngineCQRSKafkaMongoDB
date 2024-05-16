using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandlerSuggestion : IQueryHandlerSuggestion
    {
        private readonly ISearchRepository _searchRepository;

        public QueryHandlerSuggestion(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;
        }

        //Handle the final Search Query that invokes the list       

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextFromHistoryQuery query)
        {
            return await _searchRepository.GetSuggestionBySearchTextFromHistoryAsync(query.SearchText,query.UserCode);
        }

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextQuery query)
        {
            return await _searchRepository.GetSuggestionBySearchTextAsync(query.SearchText);
 
        }
        //return new List<SearchContent> {  contents };

    }
}