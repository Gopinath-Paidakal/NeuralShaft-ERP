using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace NeuralShaft.Model.Enquiry
{
    public class EnqClientDetails
    {
        public int EnqClientId { get; set; }
        public string EnqClientGUID { get; set; }
        public string EnqClientCategory { get; set; }
        public string EnqClientName { get; set; }
        public string EnqClientMobileNo { get; set; }
        public string EnqClientEmailId { get; set; }
        public string EnqClientAddress1 { get; set; }
        public string EnqClientAddress2 { get; set; }
        public string EnqLeadSource { get; set; }
        public string EnqRefDetails { get; set; }
        public string EnqRemarks { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
