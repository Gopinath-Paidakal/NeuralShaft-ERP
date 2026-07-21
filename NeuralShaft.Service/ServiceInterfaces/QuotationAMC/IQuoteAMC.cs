using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.QuotationAMC
{
    public interface IQuoteAMC
    {
        //  -------- AMC Hdr
        Task<string> GetQuoteAMC(string fromDate, string toDate);

        Task<string> GetQuoteAMCHdrById(int quoteAMCHdrId);

        Task<string> InsertQuoteAMCHdr(object quoteAMCHdr);     // In Add both hdr and dtl inserted 

        Task<string> UpdateQuoteAMCHdr(int quoteAMCHdrId, object quoteAMCHdr);


        //  -------- AMC Dtl

        Task<string> InsertQuoteAMCDtl(object quoteAMCDtl);

        Task<string> UpdateQuoteAMCDtl(int quoteAMCDtlId, object quoteAMCDtl);

        Task<string> DeleteQuoteAMCDtl(int quoteAMCDtlId);

    }
}
