
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Quotation
{
    public interface IQuoteService
    {
        Task<string> GetQuote(string fromDate, string toDate);
        
        Task<string> GetQuoteDtlById(int QuoteHdrId);

        Task<string> InsertQuoteHdr(int enqHdrId);

        Task<string> UpdateQuoteHdr(int QuoteHdrId, object @QuoteHdr);

    }
}


