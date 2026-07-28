using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.SalesOrderItem;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.SaleOrderItem
{
    public class SalesOrderItemService : ISalesOrderItem
    {

        private readonly IJsonRepository _repoJSon;
        //private readonly object NULL;

        public SalesOrderItemService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        //----- SalesOrderItem Hdr
        public async Task<string> GetSalesOrderItem(string fromDate, string toDate, string status)
        {
            string quoteItemData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteSOItemHdr",
                                 new { @FromDate = fromDate, @ToDate = toDate, @Status = status });
            return quoteItemData;
        }

        public async Task<string> GetSalesOrderItemHdrById(int salesOrderItemHdrId)
        {
            var SOItemGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetQuoteSOtemHdr_ById",
                                   new { @QuoteSOItemHdrId = salesOrderItemHdrId });
            return SOItemGetById;


        }

        public async Task<string> InsertSalesOrderItemHdrDtl(object salesOrderHdrItem)
        {
            string insertSOHdrItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteSOItemHdr", new { @QuoteSOItemHdr = salesOrderHdrItem.ToString() });
            return (insertSOHdrItem);

        }

        public async Task<string> UpdateSalesOrderItemHdr(int salesOrderItemHdrId, object salesOrderHdrItem)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteSOItemHdr", new { @QuoteSOItemHdrId = salesOrderItemHdrId, @QuoteSOItemHdr = salesOrderHdrItem.ToString() });
        }


        //----- SalesOrderItem Dtl
        public async Task<string> InsertSalesOrderItemDtl(object salesOrderItemDtl)
        {
            string insertSOItemDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertQuoteSOItemDtl", new { @QuoteSOItemDtl = salesOrderItemDtl.ToString() });
            return (insertSOItemDtl);
        }

        public async Task<string> UpdateSalesOrderItemDtl(int salesOrderItemDtlId, object salesOrderItemDtl)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateQuoteSOItemDtl", new { @QuoteSOItemDtlId = salesOrderItemDtlId, @QuoteSOItemDtl = salesOrderItemDtl.ToString() });
        }

        public async Task<string> DeleteSalesOrderItemDtl(int salesOrderItemDtlId)
        {
            var deleteSOItemById = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteQuoteSOItemDtl",
                                  new { @QuoteSOItemDtlId = salesOrderItemDtlId });

            return deleteSOItemById;
        }

    }
}
