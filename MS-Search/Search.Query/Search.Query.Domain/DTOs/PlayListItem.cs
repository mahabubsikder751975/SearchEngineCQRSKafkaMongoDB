using CQRS.Core.Queries;

namespace Search.Query.Domain.DTOs
{
    public class PlayListItem:BaseQuery
    {
        // public string PlayListId { get; set; }
        // public string PlayListName { get; set; }
        // public string Image { get; set; }
        // public string Expired { get; set; }  
        // public string GenreId { get; set; }        

        public string ContentId { get; set; }
        public string ContentType { get; set; }
        public string ArtistId { get; set; }
         public string Artist { get; set; }
        public string ImageUrl { get; set; }
        public string Title { get; set; }
        public string PlayUrl { get; set; }
        public string AlbumId { get; set; }
        public string AlbumTitle { get; set; }
        public string ResultType { get; set; }
                   
    }
}