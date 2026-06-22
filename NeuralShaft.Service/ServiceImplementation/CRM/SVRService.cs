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

        public async Task<string> GetSVR(string fromDate, string toDate)
        {
            string svr = await _SVRJSon.ExecuteJsonSPWithParameter("SP_GetJOSVR",
                                new { @FromDate = fromDate, @ToDate = toDate });
            return svr;
        }

        public async Task<string> GetSVRById(int soDtlId)
        {
            string svrById = await _SVRJSon.ExecuteJsonSPWithParameter("SP_GetJobOrderSVR",
                                        new { @SODtlId = soDtlId });
            return svrById;
        }

        public async Task<string> InsertSVR(object SVR)
        {
            string addJobOrderPVR = await _SVRJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderSVR",
                                  new { @JobOrderSVR = SVR.ToString() });
            return (addJobOrderPVR);
        }

        public async Task<string> UpdateJOSVRHdr(int jobOrderSVRHdrId, object JobOrderSVRHdr)
        {
            return await _SVRJSon.ExecuteJsonSPWithParameter("SP_UpdateJOSVRHdrDtl",
                                    new { @JobOrderSVRHdrId = jobOrderSVRHdrId, @joSVRHdr = JobOrderSVRHdr.ToString() });
        }

        public async Task<string> UpdateJOSVRDtl(int jobOrderSVRDtlId, object JobOrderSVRDtl)
        {
            var updateEnqDtlId = await _SVRJSon.ExecuteJsonSPWithParameter("Sp_UpdateEnqDtl",
                                      new { @JobOrderSVRDtlId = jobOrderSVRDtlId, @JobOrderSVRDtl = JobOrderSVRDtl.ToString() });
            return updateEnqDtlId;
        }

        public async Task<string> ReplaceFile(int jobOrderSVRDtlId,  string newFile)
        {
            return await _SVRJSon.ExecuteJsonSPWithParameter("SP_UpdateJOSVR_NewFile",
                                    new { @JobOrderSVRDtlId = jobOrderSVRDtlId, @NewFileName = newFile.ToString() });
        }
    }
}
