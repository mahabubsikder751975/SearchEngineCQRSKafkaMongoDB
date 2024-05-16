using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindContentsByCategoryTypeQuery : BaseQuery
    {
        public string SearchText { get; set; }
        public string ConentType { get; set; }
        public int Client { get; set; }
        public int CountryValue { get; set; }

    }
}