using CQRS.Core.Queries;
using Microsoft.Extensions.Caching.Memory;

namespace Search.Query.Api.Queries
{
    public class FindSuggestionsBySearchKeyQuery : BaseQuery
    {
        public string SearchText { get; set; }
        public IMemoryCache MemoryCache { get; set; }
        public int Limit { get; set; }

    }
}