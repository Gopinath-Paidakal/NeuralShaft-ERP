using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuralShaft.Model.Enquiry
{
    public class EnqCabinType
    {
        public int CabinTypeId { get; set; }
        public string CabinType { get; set; }
    }
}
