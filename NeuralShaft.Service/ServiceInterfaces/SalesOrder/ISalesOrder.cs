using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.SalesOrder
{
    public interface ISalesOrder
    {

        Task<string> GetSalesOrder(string fromDate, string toDate);
        Task<string> GetSOHdrById(int SOHdrId);   //, int SODtlId);
        Task<string> GetSODtlById(int SODtlId);   //, int SODtlId);

        //Task<string> InsertSOHdr(int OrdApproveId);
        Task<string> InsertSOHdr(object SOHdr);
        Task<string> UpdateSOHdr(int SOHdrId, object SOHdr);
        Task<string> InsertSODtl(int SOHdrId, object SOdtl);
        Task<string> UpdateSODtl(int SODtlId, object SOdtl);
        Task<string> DeleteSODtlById(int SODtlId);

        Task<string> GetSODtlAmtById(int enqDtlId);
        Task<string> UpdateSODtlAmt(int enqDtlId, object enqDtl);

    }
}
