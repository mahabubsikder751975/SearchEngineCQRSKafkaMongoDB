using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindSearchHistoryListQuery : BaseQuery
    {

        public string UserCode { get; set; }
    }
}