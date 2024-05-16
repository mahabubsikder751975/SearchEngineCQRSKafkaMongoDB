using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandlerSearchHistory : IQueryHandlerSearchHistory
    {
        private readonly ISearchRepository _searchRepository;

        public QueryHandlerSearchHistory(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;
        }

        //Handle the final Search Query that invokes the list       
      
        public async Task<List<SearchHistory>> HandleAsync(FindSearchHistoryListQuery query)
        {
             return await _searchRepository.GetSearchHistoriesByUserNameAsync(query.UserCode);
        }
    }
}