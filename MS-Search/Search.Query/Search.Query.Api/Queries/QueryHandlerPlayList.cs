using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandlerPlayList : IQueryHandlerPlayList
    {
        private readonly ISearchRepository _searchRepository;

        public QueryHandlerPlayList(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;
        }

        //Handle the final Search Query that invokes the list       
      
        public async Task<List<PlayListItem>> HandleAsync(FindTopPlayListQuery query)
        {
             return await _searchRepository.GetDefaultPlayListAsync(query.PageSize);
        }
    }
}