using Search.Query.Api.DTOs;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Api.Queries
{
    public interface IQueryHandlerPlayList
    {
        Task<List<PlayListItem>> HandleAsync(FindTopPlayListQuery query);
    }
}