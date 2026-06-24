using Microsoft.AspNetCore.Hosting;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System;
using System.Collections.Generic;
using System.Runtime.Intrinsics.Arm;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.CRM
{
    public class SCRService : ISCR
    {
        private readonly IJsonRepository _SCRJSon;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        public SCRService(IJsonRepository repoJson)
        {
            _SCRJSon = repoJson;
        }

        //public async Task<string> GetSCR(string fromDate, string toDate)
        //{
        //    throw new NotImplementedException();
        //}

        public async Task<string> GetSCRById(int jobOrderSCRDtlId)
        {
            string scrById = await _SCRJSon.ExecuteJsonSPWithParameter("SP_GetJOSCR_ById",
                                       new { @SODtlId = jobOrderSCRDtlId });
            return scrById;
        }

        public async Task<string> InsertSCR(object jobOrderSCRDtl)
        {
            string addJobOrderSCR = await _SCRJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderSCR",
                                  new { @JobOrderSCRDtl = jobOrderSCRDtl.ToString() });
            return (addJobOrderSCR);
        }

        public async Task<string> UpdateJOSCRDtl(int jobOrderSCRDtlId, object jobOrderSCRDtl)
        {
            return await _SCRJSon.ExecuteJsonSPWithParameter("SP_UpdateJOSCRHdrDtl",
                                    new { @JjobOrderSCRDtlId = jobOrderSCRDtlId, @JobOrderSCRHdr = jobOrderSCRDtl.ToString() });
        }

        public async Task<string> ReplaceFile(int jobOrderSCRDtlId, string newFile)
        {
            return await _SCRJSon.ExecuteJsonSPWithParameter("SP_UpdateJOSCR_NewFile",
                                    new { @JobOrderSCRDtlId = jobOrderSCRDtlId, @NewFileName = newFile.ToString() });
        }
    }
}


