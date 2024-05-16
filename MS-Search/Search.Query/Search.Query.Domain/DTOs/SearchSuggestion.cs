using CQRS.Core.Queries;

namespace Search.Query.Domain.DTOs
{
    public class SearchSuggestion:BaseQuery
    {
        public string Source { get; set; }
        public string ContentId { get; set; }
        public string ContentName { get; set; }
        public string Type { get; set; }  
        public decimal Similarity { get; set; } 
        public int GroupNumber { get; set; }           
    }
}