using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Search.Query.Domain.Entities
{
    [Table("SMSearchLog", Schema = "dbo")]
    public class SearchEntity
    {
        [Key]
        public Guid SearchId { get; set; }
        public string UserName { get; set; }
        public DateTime DateSearched { get; set; }
        public string SearchText { get; set; }                
    }
}