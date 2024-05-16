using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Search.Query.Domain.Entities
{
    [Table("tbl_UserSearchHistory", Schema = "dbo")]
    public class SearchHistoryEntity
    {
        [Key]
        public Guid Id { get; set; }
        public string UserCode { get; set; }
        public string ContentId { get; set; }
        public string Type { get; set; }
        public DateTime CreateDate { get; set; }

        public bool IsDeleted { get; set; }
        public string TrackType { get; set; }      
    }
}