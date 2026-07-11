using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.ProformaInvoice;
using NeuralShaft.Service.ServiceInterfaces.TaxInvoice;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.TaxInvoice
{
    public class TaxInvoiceService : ITaxInv
    {

        private readonly IJsonRepository _repoJSon;

        public TaxInvoiceService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;

        }

        public async Task<string> GetOrdClientByIdTaxInv(int ordClientHdrId)
        {
            var enqGetOrdClientHdrById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetOrdClientByIdTaxInv",
                                 new { @ordClientHdrId = ordClientHdrId }); //@EnqDtlId = enqDtlId
            return enqGetOrdClientHdrById;
        }

        public async Task<string> GetTaxInv(string fromDate, string toDate)
        {
            string TaxInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_TaxInv",
                                   new { @FromDate = fromDate, @ToDate = toDate });
            return TaxInv;
        }

        public async Task<string> GetTaxInvById(int taxInvHdrId)
        {
            var TaxInvById = await _repoJSon.ExecuteJsonSPWithParameter("SP_TaxInvById",
                                    new { @TaxInvHdrId = taxInvHdrId }); //@EnqDtlId = enqDtlId
            return TaxInvById;
            ;
        }

        public async Task<string> InsertTaxInv(object taxInv)
        {
            var insertTaxInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertTaxInv", new { @ProformaInv = taxInv.ToString() });
            return (insertTaxInv);
        }

        public async Task<string> UpdateTaxInv(int taxInvHdrId, object TaxInv)
        {
            throw new NotImplementedException();
        }

        public async Task<string> DeleteTaxInv(int taxInvHdrId)
        {
            throw new NotImplementedException();
        }

    }
}
