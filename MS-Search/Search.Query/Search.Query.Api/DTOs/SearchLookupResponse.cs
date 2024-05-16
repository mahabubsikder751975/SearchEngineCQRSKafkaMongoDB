using Search.Common.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Api.DTOs
{
    public class SearchLookupResponse : BaseResponse
    {
        public List<SearchEntity> Searches { get; set; }
    }
}