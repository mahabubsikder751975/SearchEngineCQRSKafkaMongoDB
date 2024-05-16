using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindSuggestionsBySearchTextQuery : BaseQuery
    {
        public string SearchText { get; set; }         

    }
}