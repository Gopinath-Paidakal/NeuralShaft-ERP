using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface ISVR
    {
        Task<string> GetSVR(string fromDate, string toDate);
        Task<string> GetSVRById(int soDtlId);
        Task<string> InsertSVR(object PVR);
        Task<string> UpdateJOSVRHdr(int jobOrderSVRHdrId, object JobOrderSVRHdr);
        Task<string> UpdateJOSVRDtl(int jobOrderSVRDtlId, object @JobOrderSVRDtl);

        Task<string> ReplaceFile(int jobOrderSVRDtlId,  string NewFile);

    }
}
