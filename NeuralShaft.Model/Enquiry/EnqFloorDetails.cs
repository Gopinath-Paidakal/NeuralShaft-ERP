using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuralShaft.Model.Enquiry
{
    public class EnqFloorDetails
    {
        public int EnqFloorDetailsId { get; set; }
        public string FloorDetails { get; set; }
        public string NoOfStop { get; set; }
        public string NoStopDetails { get; set; }
        public string TotalStops { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
