using Microsoft.AspNetCore.Hosting;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.ProformaInvoice;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.ProformaInvoice
{
    public class ProformaInvService : IProformaInv
    {
        private readonly IJsonRepository _repoJSon;

        public ProformaInvService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
           
        }
        public async Task<string> GetOrdClientByIdProInv(int ordClientHdrId)
        {
            var enqGetOrdClientHdrById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetOrdClientByIdProInv",
                                   new { @ordClientHdrId = ordClientHdrId }); //@EnqDtlId = enqDtlId
            return enqGetOrdClientHdrById;
        }

        public async Task<string> GetProformaInv(string fromDate, string toDate)
        {
            string getProformaInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetProformaInv",
                                    new { @FromDate = fromDate, @ToDate = toDate });
            return getProformaInv;
        }
        

        public async Task<string> GetProformaInvById(int proformaInvHdrId)
        {
            var getProformaInvById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetProformaInvById",
                                     new { @ProformaInvHdrId = proformaInvHdrId }); //@EnqDtlId = enqDtlId
            return getProformaInvById;

        }

        public async Task<string> InsertProformaInv(object proformaInv)
        {
            var insertProformaInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertProformaInv", new { @ProformaInv = proformaInv.ToString() });
            return (insertProformaInv);
        }

        public async Task<string> UpdateProformaInv(int ProformaInvHdrId, object proformaInv)
        {
            throw new NotImplementedException();
        }

        public async Task<string> DeleteProformaInv(int ProformaInvHdrId)
        {
            throw new NotImplementedException();
        }

      
    }
}
