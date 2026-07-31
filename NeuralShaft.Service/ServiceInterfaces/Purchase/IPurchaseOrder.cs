using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Purchase
{
    public interface IPurchaseOrder
    {
        Task<string> GetPurchaseOrder(string fromDate, string toDate);
        Task<string> GetPurchaseOrderById(int purchaseOrderHdrId);
        Task<string> InsertPurchaseOrder(object purchaseOrder);
        Task<string> UpdatePurchaseOrderHdr(int purchaseOrderHdrId, object purchaseOrder);
        //Task<string> DeletePurchaseOrder(int purchaseOrderHdrId);

        //----- PurchaseOrder Dtl 
        Task<string> InsertPurchaseOrderDtl(object purchaseOrderDtl);

        Task<string> UpdatePurchaseOrderDtl(int purchaseOrderDtlId, object purchaseOrderDtl);

        Task<string> DeletePurchaseOrderDtl(int purchaseOrderDtlId);
    }
}


//Task<string> GetOrdClientByIdPurchaseOrder(int purchaseOrderHdrId);

