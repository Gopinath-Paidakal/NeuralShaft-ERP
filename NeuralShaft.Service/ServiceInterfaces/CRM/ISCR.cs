using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface ISCR
    {
        //Task<string> GetSCR(string fromDate, string toDate);
        Task<string> GetSCRById(int jobOrderSCRHdrId);
        Task<string> InsertJobOrderSCRHdr(object jobOrderSCRHdr);
        Task<string> UpdateJobOrderSCRHdr(int jobOrderSCRHdrId, object JobOrderSCRHdr);

        Task<string> ReplaceFile(int jobOrderSCRHdrId, string newFile);
    }
}
