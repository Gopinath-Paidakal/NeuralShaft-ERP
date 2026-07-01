using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface ISVR
    {
        Task<string> GetSVR(string fromDate, string toDate);

        Task<string> GetSVRStaByJobId(int jobOrderId);
        Task<string> GetSVRById(int jobOrderSVRHdrId);
        Task<string> InsertSVR(object PVR);
        Task<string> UpdateJOSVRHdrDtl(int jobOrderSVRHdrId, object jobOrderSVRHdr);        

        Task<string> ReplaceFile(int jobOrderSVRDtlId,  string NewFile);

    }
}

//Task<string> UpdateJOSVRDtl(int jobOrderSVRDtlId, object @JobOrderSVRDtl);
