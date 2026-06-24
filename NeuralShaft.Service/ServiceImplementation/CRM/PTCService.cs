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

        public async Task<string> GetPTC(string fromDate, string toDate)
        {
            string PTC = await _ptcJSon.ExecuteJsonSPWithParameter("SP_GetJOPTC",
                               new { @FromDate = fromDate, @ToDate = toDate });
            return PTC;
        }

        public async Task<string> GetPTCById(int soDtlId)
        {
            string PTCById = await _ptcJSon.ExecuteJsonSPWithParameter("SP_GetJOPTC_ById",
                                         new { @SODtlId = soDtlId });
            return PTCById;
        }

        public async Task<string> InsertPTC(object PTC)
        {
            string addJobOrderPTC = await _ptcJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderPTC",
                                new { @JobOrderPTC = PTC.ToString() });
            return (addJobOrderPTC);
        }


        public async Task<string> UpdateJOPTCHdrDtl(int jobOrderPTCHdrId, object JobOrderPTCHdr)
        {
            return await _ptcJSon.ExecuteJsonSPWithParameter("SP_UpdateJOPTCHdrDtl",
                                    new { @JobOrderPTCHdrId = jobOrderPTCHdrId, @JobOrderPTCHdr = JobOrderPTCHdr.ToString() });
        }

        public async Task<string> ReplaceFile(int jobOrderPTCDtlId, string NewFile)
        {
            throw new NotImplementedException();
        }
    }
}
