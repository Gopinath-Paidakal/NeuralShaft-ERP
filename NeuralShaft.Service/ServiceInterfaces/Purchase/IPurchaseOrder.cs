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
        Task<string> UpdatePurchaseOrder(int purchaseOrderHdrId, object purchaseOrder);
        Task<string> DeletePurchaseOrder(int purchaseOrderHdrId);
    }
}


//Task<string> GetOrdClientByIdPurchaseOrder(int purchaseOrderHdrId);

