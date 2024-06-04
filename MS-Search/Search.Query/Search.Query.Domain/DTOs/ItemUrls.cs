using CQRS.Core.Queries;

namespace Search.Query.Domain.DTOs
{
    public class ItemUrls:BaseQuery
    {
        public string ContentId { get; set; }
        public string ContentType { get; set; }
        public string ParentId { get; set; }
        public string TrackType { get; set; } = "";
         public string ImageUrl { get; set; } = "";
         public string PlayUrl { get; set; } = "";
            
    }
}