using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindSearchByIdQuery : BaseQuery
    {
        public Guid Id { get; set; }
    }
}