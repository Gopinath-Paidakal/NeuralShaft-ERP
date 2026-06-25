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

        public async Task<string> GetSCRById(int jobOrderSCRHdrId)
        {
            string scrById = await _SCRJSon.ExecuteJsonSPWithParameter("SP_GetJOSCR_ById",
                                       new { @JobOrderSCRHdrId = jobOrderSCRHdrId });
            return scrById;
        }

        public async Task<string> InsertJobOrderSCRHdr(object jobOrderSCRHdr)
        {
            string addJobOrderSCR = await _SCRJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderSCR",
                                  new { @JobOrderSCRHdr = jobOrderSCRHdr.ToString() });
            return (addJobOrderSCR);
        }

        public async Task<string> UpdateJobOrderSCRHdr(int jobOrderSCRHdrId, object jobOrderSCRHdr)
        {
            return await _SCRJSon.ExecuteJsonSPWithParameter("SP_UpdateJOSCRHdr",
                                    new { @JobOrderSCRHdrId = jobOrderSCRHdrId, @JobOrderSCRHdr = jobOrderSCRHdr.ToString() });
        }

        public async Task<string> ReplaceFile(int jobOrderSCRHdrId, string newFile)
        {
            return await _SCRJSon.ExecuteJsonSPWithParameter("SP_UpdateJOSCR_NewFile",
                                    new { @JobOrderSCRHdrId = jobOrderSCRHdrId, @NewFileName = newFile.ToString() });
        }
    }
}


