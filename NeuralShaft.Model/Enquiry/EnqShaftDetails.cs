using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuralShaft.Model.Enquiry
{
    public class EnqShaftDetails
    {
        public int EnqShaftDetailsId { get; set; }
        public int? ShaftTypeId { get; set; }
        public string ShaftType { get; set; }
        public string ShaftWidth { get; set; }
        public string ShaftDepth { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
