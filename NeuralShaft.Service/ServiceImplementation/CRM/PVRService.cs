using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.CRM
{
    public class PVRService : IPVR   
    {
        private readonly IJsonRepository _PVRJSon;

        public PVRService(IJsonRepository repoJson)
        {
            _PVRJSon = repoJson;
        }

        public async Task<string> GetPVR(int SODtlId)
        {
            string pvr = await _PVRJSon.ExecuteJsonSPWithParameter("SP_GetJobOrderPVR",
                                        new { @SODtlId = SODtlId });
            return pvr;
        }

        public async Task<string> InsertPVR(object PVR)
        {
            //string insertBranch = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertBranch", new { @Branch = branch.ToString() });
            string addJobOrderPVR = await _PVRJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderPVR",
                                   new { @JobOrderPVR = PVR.ToString() });
            return (addJobOrderPVR);

        }
    }
}
