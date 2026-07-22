using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.QuotationAMC;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.QuotationAMC
{
    public class QuoteAMCService : IQuoteAMC
    {
        private readonly IJsonRepository _repoJSon;
        //private readonly object NULL;

        public QuoteAMCService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

      
        public async Task<string> GetQuoteAMC(string fromDate, string toDate)
        {
            string quoteData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteAMCHdr",
                                  new { @FromDate = fromDate, @ToDate = toDate });
            return quoteData;
        }

        public async Task<string> GetQuoteAMCHdrById(int quoteAMCHdrId)
        {
            var QuoteAMCGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteAMC_ById",
                                    new { @QuoteAMCHdrId = quoteAMCHdrId });
            return QuoteAMCGetById;
        }

        public async Task<string> InsertQuoteAMCHdr(object quoteAMCHdr)
        {
            string insertQuoteHdrAMC = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteAMCHdr", new { @QuoteAMCHdr = quoteAMCHdr.ToString() });
            return (insertQuoteHdrAMC);
        }

        public async Task<string> UpdateQuoteAMCHdr(int quoteAMCHdrId, object quoteAMCHdr)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteAMCHdr", new { @QuoteAMCHdrId = quoteAMCHdrId, @QuoteAMCHdr = quoteAMCHdr.ToString() });
        }



        //----============= QuoteAMC Dtl

        public async Task<string> InsertQuoteAMCDtl(object quoteAMCDtl)
        {
            string insertQuoteAMCDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteAMCDtl", new { @QuoteAMCDtl = quoteAMCDtl.ToString() });
            return (insertQuoteAMCDtl);
        }
        
               
        public async Task<string> UpdateQuoteAMCDtl(int quoteAMCDtlId, object quoteAMCDtl)
        {
            try
            {
                //return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteAMCDtl", new { @QuoteAMCHdrId = QuoteAMCHdrId, @QuoteAMCHdrDtl = QuoteAMCHdrDtl.ToString() });
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteAMCDtl", new { @QuoteAMCDtlId = quoteAMCDtlId, @QuoteAMCDtl = quoteAMCDtl.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteQuoteAMCDtl(int quoteAMCDtlId)
        {
            var deleteQuoteAMCById = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteQuoteAMCDtl",
                                   new { @QuoteAMCDtlId = quoteAMCDtlId });

            return deleteQuoteAMCById;

        }

    }
}
