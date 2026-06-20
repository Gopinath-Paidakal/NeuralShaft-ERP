using Microsoft.AspNetCore.Hosting;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.CRM
{

    public class SVRService : ISVR
    {
        private readonly IJsonRepository _SVRJSon;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        public SVRService(IJsonRepository repoJson)
        {
            _SVRJSon = repoJson;
        }

        public async Task<string> GetSVR(int soDtlId)
        {
            string svr = await _SVRJSon.ExecuteJsonSPWithParameter("SP_GetJobOrderSVR",
                                        new { @SODtlId = soDtlId });
            return svr;
        }

        public async Task<string> InsertSVR(object SVR)
        {
            string addJobOrderPVR = await _SVRJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderSVR",
                                  new { @JobOrderSVR = SVR.ToString() });
            return (addJobOrderPVR);
        }
    }
}
