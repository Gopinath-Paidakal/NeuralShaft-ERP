using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface IPVR
    {
        Task<string> GetPVR(int SODtlId);
        Task<string> InsertPVR(object PVR);
    }
}
