using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface IPTC
    {
        //Task<string> GetPTC(string fromDate, string toDate);
        Task<string> GetPTCById(int JobOrderPTCDtlId);
        Task<string> InsertJobOrderPTCDtl(object JobOrderPTCDtl);
        Task<string> UpdateJobOrderPTCDtl(int JobOrderPTCDtlId, object JobOrderPTCDtl);

        //Task<string> ReplaceFile(int jobOrderPTCDtlId, string NewFile);
    }
}
