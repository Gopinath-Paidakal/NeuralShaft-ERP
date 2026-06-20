using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuralShaft.Model.Enquiry
{
    public  class EnqDoorDetails
    {
        public int EnqDoorTypeId { get; set; }
        public string DoorOpening { get; set; }
        public string DoorWidth { get; set; }
        public string DoorFinish { get; set; }
        public string DoubleEntrance { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
