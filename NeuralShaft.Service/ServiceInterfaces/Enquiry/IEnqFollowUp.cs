using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Enquiry
{
    public interface IEnqFollowUp
    {
        Task<string> GetEnquiryFollowUp(string fromDate, string toDate);
        Task<string> GetEnquiryFollowUpById(int enqHdrId);
        Task<string> InsertEnqFollowUp(object enqFollowUp);
        Task<string> UpdateEnqFollowUp(int EnqFollowUpIdUpdate, object enqFollowUp);
    }
}
