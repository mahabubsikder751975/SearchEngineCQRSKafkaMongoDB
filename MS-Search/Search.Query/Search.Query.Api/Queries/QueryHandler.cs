using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandler : IQueryHandler
    {
        private readonly ISearchRepository _searchRepository;

        public QueryHandler(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;
        }

        //Handle the final Search Query that invokes the list
        public async Task<List<SearchEntity>> HandleAsync(FindAllSearchesQuery query)
        {
            return await _searchRepository.ListAllAsync();
        }

        public async Task<List<SearchEntity>> HandleAsync(FindSearchByIdQuery query)
        {
            var search = await _searchRepository.GetByIdAsync(query.Id);
            return new List<SearchEntity> { search };
        }

        public async Task<List<SearchEntity>> HandleAsync(FindSearchesByUserNameQuery query)
        {
            return await _searchRepository.ListByUserNameAsync(query.UserName);
        }      
    }
}