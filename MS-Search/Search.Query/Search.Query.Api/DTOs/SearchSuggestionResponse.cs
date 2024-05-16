using Confluent.Kafka.Admin;
using Search.Common.DTOs;
using Search.Query.Domain.DTOs;


namespace Search.Query.Api.DTOs
{
    public class SearchSuggestionResponse : BaseResponse
    {
        public List<SearchSuggestion> Contents { get; set; }
    }
}