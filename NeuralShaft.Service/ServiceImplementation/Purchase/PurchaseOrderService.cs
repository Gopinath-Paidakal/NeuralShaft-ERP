using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Purchase;

namespace NeuralShaft.Service.ServiceImplementation.Purchase
{
    public class PurchaseOrderService : IPurchaseOrder
    {

        private readonly IJsonRepository _repoJSon;

        public PurchaseOrderService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;

        }
        public async Task<string> GetPurchaseOrder(string fromDate, string toDate)
        {
            string PurchaseOrder = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetPurchaseOrder",
                                   new { @FromDate = fromDate, @ToDate = toDate });
            return PurchaseOrder;
        }

        public async Task<string> GetPurchaseOrderById(int purchaseOrderHdrId)
        {
            var PurchaseOrderById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetPurchaseOrderById",
                                  new { @PurchaseOrderHdrId = purchaseOrderHdrId }); //@EnqDtlId = enqDtlId
            return PurchaseOrderById;
        }

        public async Task<string> InsertPurchaseOrder(object purchaseOrder)
        {
            var insertPO = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertPurchaseOrder", new { @PurchaseOrderHdr = purchaseOrder.ToString() });
            return (insertPO);
        }

        public async Task<string> UpdatePurchaseOrder(int purchaseOrderHdrId, object purchaseOrder)
        {
            var updatePO = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdatePurchaseOrder",
                               new { @PurchaseOrderHdrId = purchaseOrderHdrId, @PurchaseOrderUpdate = purchaseOrder.ToString() });
            return (updatePO);
        }

        public async Task<string> DeletePurchaseOrder(int purchaseOrderHdrId)
        {
            throw new NotImplementedException();
        }

    }
}
