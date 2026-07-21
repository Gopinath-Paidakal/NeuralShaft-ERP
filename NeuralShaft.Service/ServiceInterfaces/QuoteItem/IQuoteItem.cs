using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.QuoteItem
{
    public interface IQuoteItem
    {
        //----- QuoteItem Hdr
        Task<string> GetQuoteItem(string fromDate, string toDate);

        Task<string> GetQuoteItemHdrById(int QuoteItemHdrId);

        Task<string> InsertQuoteItemHdr(object quoteHdrItem);  // Inserts both Header and Detail

        Task<string> UpdateQuoteItemHdr(int quoteItemHdrId, object quoteHdrItem);


        //----- QuoteItem Dtl
        Task<string> InsertQuoteItemDtl(object quoteItemDtl);

        Task<string> UpdateQuoteItemDtl(int quoteItemDtlId, object quoteDtlItem);

        Task<string> DeleteQuoteItemDtl(int quoteItemDtlId);

    }
}
