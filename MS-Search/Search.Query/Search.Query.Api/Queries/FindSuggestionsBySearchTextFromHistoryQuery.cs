using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindSuggestionsBySearchTextFromHistoryQuery : BaseQuery
    {
        public string SearchText { get; set; }
        public string UserCode { get; set; }      

    }
}