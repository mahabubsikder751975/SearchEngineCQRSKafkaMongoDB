using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindSearchesByUserNameQuery : BaseQuery
    {
        public string UserName { get; set; }
    }
}