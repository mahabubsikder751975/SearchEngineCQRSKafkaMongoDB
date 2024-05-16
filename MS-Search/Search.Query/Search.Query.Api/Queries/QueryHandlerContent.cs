using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandlerContent : IQueryHandlerContent
    {
        private readonly ISearchRepository _searchRepository;

        public QueryHandlerContent(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;
        }

        //Handle the final Search Query that invokes the list       

        public async Task<List<SearchContent>> HandleAsync(FindContentsBySearchTextQuery query)
        {
            return await _searchRepository.GetContentsBySearchTextAsync(query.SearchText,query.ConentType,query.Client,query.CountryValue);
        }
        
        public async Task<List<SearchContent>> HandleAsync(FindContentsByCategoryTypeQuery query)
        {
            return await _searchRepository.GetContentsByCategoryTypeAsync(query.SearchText,query.ConentType,query.Client,query.CountryValue);
        }
       
    }
}