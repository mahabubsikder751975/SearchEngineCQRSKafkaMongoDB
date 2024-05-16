using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Api.Queries
{
    public interface IQueryHandlerContent
    {
        Task<List<SearchContent>> HandleAsync(FindContentsBySearchTextQuery query);
        Task<List<SearchContent>> HandleAsync(FindContentsByCategoryTypeQuery query);
    }
}