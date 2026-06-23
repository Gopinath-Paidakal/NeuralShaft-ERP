using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface IPVR
    {
        Task<string> GetPVR(int SODtlId);
        Task<string> InsertPVR(object PVR);

        Task<string> UpdateJOPVRHdrDtl(int jobOorderPVRId, object jobOrderPVR);

        Task<string> ReplaceFile(int jobOrderPVRId, string newFile);
    }
}
