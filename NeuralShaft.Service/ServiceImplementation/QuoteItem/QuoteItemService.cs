using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.QuoteItem;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.QuoteItem
{
    public class QuoteItemService :IQuoteItem
    {
        private readonly IJsonRepository _repoJSon;
        //private readonly object NULL;

        public QuoteItemService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetQuoteItem(string fromDate, string toDate)
        {
            try
            {
                string quoteItemData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteItemHdr",
                                  new { @FromDate = fromDate, @ToDate = toDate });
                return quoteItemData;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // 
            }
        }

        public async Task<string> GetQuoteItemHdrById(int quoteItemHdrId)
        {
            try
            {
                var QuoteItemGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteItemHdr_ById",
                                    new { @QuoteItemHdrId = quoteItemHdrId });
                return QuoteItemGetById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertQuoteItemHdr(object QuoteHdrItem)
        {
            try
            {
                string insertQuoteHdrItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteItemHdr", new { @QuoteHdrItem = QuoteHdrItem.ToString() });
                return (insertQuoteHdrItem);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateQuoteItemHdr(int quoteItemHdrId, object quoteHdrItem)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteItemHdr", new { @QuoteItemHdrId = quoteItemHdrId, @QuoteHdrItem = quoteHdrItem.ToString() });
        }


        //===== Added on 26-05-2026  Both Quotation and QuotationItem in the same program changed it

        public async Task<string> InsertQuoteItemDtl(object quoteItemDtl)
        {
            string insertQuoteItemDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteItemDtl", new { @QuoteDtlItem = quoteItemDtl.ToString() });
            return (insertQuoteItemDtl);
        }

        public async Task<string> UpdateQuoteItemDtl(int quoteItemDtlId, object quoteDtlItem)
        {
            try
            {
                //return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteItemDtl", new { @QuoteItemHdrId = QuoteItemHdrId, @QuoteItemHdrDtl = QuoteItemHdrDtl.ToString() });
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteItemDtl", new { @QuoteItemDtlId = quoteItemDtlId, @QuoteDtlItem = quoteDtlItem.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteQuoteItemDtl(int quoteItemDtlId)
        {
            var deleteQuoteItemById = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteQuoteItem",
                                   new { @QuoteItemDtlId = quoteItemDtlId });

            return deleteQuoteItemById;

        }

      
    }
}
