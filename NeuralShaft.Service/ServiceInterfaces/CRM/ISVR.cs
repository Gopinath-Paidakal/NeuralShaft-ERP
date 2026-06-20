using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface ISVR
    {
        Task<string> GetSVR(int soDtlId);
        Task<string> InsertSVR(object PVR);
    }
}
