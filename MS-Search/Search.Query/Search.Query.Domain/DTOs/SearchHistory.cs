using CQRS.Core.Queries;

namespace Search.Query.Domain.DTOs
{
    public class SearchHistory:BaseQuery
    {
        public string Id { get; set; }
        public string ContentId { get; set; }
        public string Type { get; set; }
        public string Artist { get; set; }
        public string ImageUrl { get; set; }
        public string Title { get; set; }
        public string PlayUrl { get; set; }
        public string Image { get; set; }
        public int Duration { get; set; }
        public string CreateDate { get; set; }
        public string TrackType { get; set; }
    }
}