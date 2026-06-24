using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface IPTC
    {
        //Task<string> GetPTC(string fromDate, string toDate);
        Task<string> GetPTCById(int soDtlId);
        Task<string> InsertPTC(object PTC);
        Task<string> UpdateJOPTCHdrDtl(int jobOrderPTCHdrId, object JobOrderPTCHdr);

        //Task<string> ReplaceFile(int jobOrderPTCDtlId, string NewFile);
    }
}
