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

        //public async Task<string> GetOrdClientByIdTaxInv(int ordClientHdrId)
        //{
        //    var GetOrdClientHdrById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetOrdClientByIdTaxInv",
        //                         new { @ordClientHdrId = ordClientHdrId }); //@EnqDtlId = enqDtlId
        //    return GetOrdClientHdrById;
        //}

        public async Task<string> GetTaxInv(string fromDate, string toDate)
        {
            string TaxInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetTaxInv",
                                   new { @FromDate = fromDate, @ToDate = toDate });
            return TaxInv;
        }

        public async Task<string> GetTaxInvById(int taxInvHdrId)
        {
            var TaxInvById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetTaxInvById",
                                    new { @TaxInvHdrId = taxInvHdrId }); 
            return TaxInvById;
            
        }

        public async Task<string> InsertTaxInv(object taxInv)
        {
            var insertTaxInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertTaxInv", new { @TaxInv = taxInv.ToString() });
            return (insertTaxInv);
        }

        public async Task<string> UpdateTaxInvHdr(int taxInvHdrId, object taxInv)
        {
            var updateTaxInv = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateTaxInvHdr",
                               new { @TaxInvHdrId = taxInvHdrId, @TaxInvUpdate = taxInv.ToString() });
            return (updateTaxInv);
        }

       

        public async Task<string> InsertTaxInvDtl(object taxInvDtl)
        {
            string insertTaxInvDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertTaxInvDtl", new { @taxInvDtl = taxInvDtl.ToString() });
            return (insertTaxInvDtl);
        }

        public async Task<string> UpdateTaxInvDtl(int taxInvDtlId, object taxInvDtl)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateTaxInvDtl", new { @TaxInvDtlId = taxInvDtlId, @TaxInvDtl = taxInvDtl.ToString() });
        }

        public async Task<string> DeleteTaxInvDtl(int taxInvDtlId)
        {
            var deleteTaxInvDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteTaxInvDtl",
                                   new { @TaxInvDtlId = taxInvDtlId });

            return deleteTaxInvDtl;
        }


        //public async Task<string> DeleteTaxInv(int taxInvHdrId)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
