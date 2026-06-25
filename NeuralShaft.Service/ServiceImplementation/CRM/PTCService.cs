using Microsoft.AspNetCore.Hosting;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System;
using System.Collections.Generic;
using System.Runtime.Intrinsics.Arm;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.CRM
{
    public class PTCService : IPTC
    {
        private readonly IJsonRepository _ptcJSon;
        //private readonly IWebHostEnvironment _env;
        //private readonly IUpload _uploadService;

        public PTCService(IJsonRepository repoJson)
        {
            _ptcJSon = repoJson;
        }

        //public async Task<string> GetPTC(string fromDate, string toDate)
        //{
        //    string PTC = await _ptcJSon.ExecuteJsonSPWithParameter("SP_GetJOPTC",
        //                       new { @FromDate = fromDate, @ToDate = toDate });
        //    return PTC;
        //}

        public async Task<string> GetPTCById(int jobOrderPTCDtlId)
        {
            string PTCById = await _ptcJSon.ExecuteJsonSPWithParameter("SP_GetJOPTC_ById",
                                         new { @JobOrderPTCDtlId = jobOrderPTCDtlId });
            return PTCById;
        }

        public async Task<string> InsertJobOrderPTCDtl(object JobOrderPTCDtl)
        {
            string addJobOrderPTC = await _ptcJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderPTCDtl",
                                new { @JobOrderPTCDtl = JobOrderPTCDtl.ToString() });
            return (addJobOrderPTC);
        }


        public async Task<string> UpdateJobOrderPTCDtl(int jobOrderPTCDtlId, object JobOrderPTCDtl)
        {
            return await _ptcJSon.ExecuteJsonSPWithParameter("SP_UpdateJOPTCDtl",
                                    new { @JobOrderPTCDtlId = jobOrderPTCDtlId, @JobOrderPTCDtl = JobOrderPTCDtl.ToString() });
        }

        //public async Task<string> ReplaceFile(int jobOrderPTCDtlId, string NewFile)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
