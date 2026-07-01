using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Quotation
{
    public interface IQuoteService
    {
        Task<string> GetQuote(string fromDate, string toDate);

        Task<string> GetQuoteItem(string fromDate, string toDate);

        Task<string> GetQuoteDtlById(int QuoteHdrId);

        Task<string> GetQuoteItemDtlById(int QuoteItemHdrId);

        Task<string> InsertQuoteHdr(int enqHdrId);

        Task<string> InsertQuoteItemHdr(object QuoteHdrItem);

        Task<string> UpdateQuoteHdr(int QuoteHdrId,  object @QuoteHdr);

        Task<string> UpdateQuoteItemDtl(int QuoteItemDtlId, object @QuoteItemDtl);

        

    }
}
