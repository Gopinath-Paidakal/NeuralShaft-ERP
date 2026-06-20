using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuralShaft.Model.Enquiry
{
    public class Enquiry
    {
        public int EnquiryId { get; set; }
        //public int? CompanyId { get; set; }
        //public int? BranchId { get; set; }
        //public int? EnqClientId { get; set; }
        //public int? EnqShaftDetailsId { get; set; }
        //public int? EnqProductTypeId { get; set; }
        //public int? EnqDoorTypeId { get; set; }
        //public int? EnqFloorDetailsId { get; set; }
        //public int? EnqPanelTypeId { get; set; }
        //public string EnqNo { get; set; }
        //public int? EnqSlno { get; set; }
        public DateTime? EnqDate { get; set; }
        public string EnqLeadName { get; set; }
        public string EnqStatus { get; set; }
        public string EnqStatusDetails { get; set; }
        public string Lattitude { get; set; }
        public string Longitude { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
