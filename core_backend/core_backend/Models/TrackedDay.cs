using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class TrackedDay
    {
        [Key]
        public string Uuid { get; set; }
        public long Date { get; set; }
        public long Day { get; set; }
        public bool Confirmed { get; set; }
        public long ChoiceId { get; set; }
        public string ChoiceText { get; set; }
        public string UserId { get; set; }

    }
}
