using Dapper;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Quotation;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Quotation
{
    public class QuoteService : IQuoteService
    {

        private readonly IJsonRepository _repoJSon;
        //private readonly object NULL;

        public QuoteService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }       

        public async Task<string> GetQuote(string fromDate, string toDate)
        {
            try
            {               
                string quoteData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteHdr",
                                  new { @FromDate = fromDate, @ToDate = toDate });
                return quoteData;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // 
            }
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


        public async Task<string> InsertQuoteHdr(int enqHdrId)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteHdr", new { @EnqHdrId = enqHdrId });
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



        public async Task<string> UpdateQuoteHdr(int quoteHdrId,  object QuoteHdr)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteHdr", new { @QuoteHdrId = quoteHdrId, @QuoteHdr = QuoteHdr.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        //===== Adde on 26-05-2026
        public async Task<string> UpdateQuoteItemDtl(int QuoteItemHdrId, object QuoteItemHdrDtl)
        {
            try
            {
                //return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteItemDtl", new { @QuoteItemHdrId = QuoteItemHdrId, @QuoteItemHdrDtl = QuoteItemHdrDtl.ToString() });
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteItemHdrDtl", new { @QuoteItemHdrId = QuoteItemHdrId, @QuoteItemHdrDtl = QuoteItemHdrDtl.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetQuoteDtlById(int quoteHdrId)
        {
            try
            {
                var enqGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteDtl_ById",
                                    new { @QuoteHdrId = quoteHdrId });
                return enqGetById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetQuoteItemDtlById(int quoteItemHdrId)
        {
            try
            {
                var QuoteItemGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteItemDtl_ById",
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
    }


}
