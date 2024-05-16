using Confluent.Kafka.Admin;
using Search.Common.DTOs;
using Search.Query.Domain.DTOs;


namespace Search.Query.Api.DTOs
{
    public class DefaultPlayListResponse : BaseResponse
    {
        public List<PlayListItem> Contents { get; set; }
    }
}