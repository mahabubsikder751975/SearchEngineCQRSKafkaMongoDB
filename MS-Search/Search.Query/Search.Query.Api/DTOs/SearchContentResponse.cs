using Confluent.Kafka.Admin;
using Search.Common.DTOs;
using Search.Query.Domain.DTOs;


namespace Search.Query.Api.DTOs
{
    public class SearchContentResponse : BaseResponse
    {
        public List<SearchContent> Contents { get; set; }
        // public  Dictionary<string, List<SearchContent>>  Contents { get; set; }
    }
}