using CQRS.Core.Queries;

namespace Search.Query.Domain.DTOs
{
    public class SearchSuggestion:BaseQuery
    {
        public string Source { get; set; }
        public string ContentId { get; set; }

        public string ParentId { get; set; }
        public string ContentName { get; set; }
        public string Artist { get; set; }
        
        public string Type { get; set; }  
        public decimal Similarity { get; set; } 
        public int GroupNumber { get; set; }      

         // New properties with default values
        public string TrackType { get; set; } = "";
         public string ImageUrl { get; set; } = "";
         public string PlayUrl { get; set; } = "";
            
    }
}