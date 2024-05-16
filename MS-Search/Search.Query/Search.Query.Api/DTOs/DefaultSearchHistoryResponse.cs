using Confluent.Kafka.Admin;
using Search.Common.DTOs;
using Search.Query.Domain.DTOs;


namespace Search.Query.Api.DTOs
{
    public class DefaultSearchHistoryResponse : BaseResponse
    {
        public List<SearchHistory> Contents { get; set; }
    }
}