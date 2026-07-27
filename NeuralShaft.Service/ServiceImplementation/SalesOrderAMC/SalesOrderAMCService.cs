using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.SalesOrderAMC;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.SalesOrderAMC
{
    public class SalesOrderAMCService : ISalesOrderAMC
    {
        private readonly IJsonRepository _repoJSon;
        //private readonly object NULL;

        public SalesOrderAMCService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        //----- SalesOrderAMC Hdr
        public async Task<string> GetSalesOrderAMC(string fromDate, string toDate, string status)
        {
            string quoteItemData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteSOAMCHdr",
                                 new { @FromDate = fromDate, @ToDate = toDate, @Status = status });
            return quoteItemData;
        }

        public async Task<string> GetSalesOrderAMCHdrById(int salesOrderAMCHdrId)
        {
            var SOItemGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteSOAMCHdr_ById",
                                   new { @QuoteSOAMCHdrId = salesOrderAMCHdrId });
            return SOItemGetById;


        }

        public async Task<string> InsertSalesOrderAMCHdrDtl(object salesOrderAMCHdrDtl)
        {
            string insertSOHdrItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteSOAMCHdr", 
                                                new { @QuoteSOAMCHdr = salesOrderAMCHdrDtl.ToString() });
            return (insertSOHdrItem);

        }

        public async Task<string> UpdateSalesOrderAMCHdr(int salesOrderAMCHdrId, object salesOrderHdrAMCHdr)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteSOAMCHdr", 
                                new { @QuoteSOAMCHdrId = salesOrderAMCHdrId, @QuoteSOAMCHdr = salesOrderHdrAMCHdr.ToString() });
        }


        //----- SalesOrderAMC Dtl
        public async Task<string> InsertSalesOrderAMCDtl(object salesOrderAMCDtl)
        {
            string insertSOItemDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteSOAMCDtl", 
                                                    new { @QuoteSOAMCDtl = salesOrderAMCDtl.ToString() });
            return (insertSOItemDtl);
        }

        public async Task<string> UpdateSalesOrderAMCDtl(int salesOrderItemDtlId, object salesOrderAMCDtl)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteSOAMCDtl", 
                                                new { @QuoteSOAMCDtlId = salesOrderItemDtlId, @QuoteSOAMCDtl = salesOrderAMCDtl.ToString() });
        }

        public async Task<string> DeleteSalesOrderAMCDtl(int salesOrderItemDtlId)
        {
            var deleteSOItemById = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteQuoteSOAMCDtl",
                                  new { @QuoteSOAMCDtlId = salesOrderItemDtlId });

            return deleteSOItemById;
        }
    }
}
