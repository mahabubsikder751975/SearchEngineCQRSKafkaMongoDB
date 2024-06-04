using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Api.Queries
{
    public interface IQueryHandler
    {
        Task<List<SearchEntity>> HandleAsync(FindAllSearchesQuery query);
        Task<List<SearchEntity>> HandleAsync(FindSearchByIdQuery query);
        Task<List<SearchEntity>> HandleAsync(FindSearchesByUserNameQuery query);        
    }
}