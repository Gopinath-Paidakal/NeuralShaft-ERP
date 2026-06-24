using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface ISCR
    {
        //Task<string> GetSCR(string fromDate, string toDate);
        Task<string> GetSCRById(int jobOrderSCRDtlId);
        Task<string> InsertSCR(object jobOrderSCRDtl);
        Task<string> UpdateJOSCRDtl(int jobOrderSCRDtlId, object JobOrderSCRDtl);

        Task<string> ReplaceFile(int jobOrderSCRDtlId, string newFile);
    }
}
