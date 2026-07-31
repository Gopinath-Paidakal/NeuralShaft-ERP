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

        public async Task<string> UpdatePurchaseOrderHdr(int purchaseOrderHdrId, object purchaseOrder)
        {
            var updatePO = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdatePurchaseOrderHdr",
                               new { @PurchaseOrderHdrId = purchaseOrderHdrId, @PurchaseOrderUpdate = purchaseOrder.ToString() });
            return (updatePO);
        }


        public async Task<string> InsertPurchaseOrderDtl(object purchaseOrderDtlId)
        {
            string insertPODtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertPurchaseOrderDtl", new { @PurchaseOrderDtl = purchaseOrderDtlId.ToString() });
            return (insertPODtl);
        }
        

        public async Task<string> UpdatePurchaseOrderDtl(int purchaseOrderDtlId, object purchaseOrderDtl)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdatePurchaseOrderDtl", new { @PurchaseOrderDtlId = purchaseOrderDtlId,
                                                @PurchaseOrderDtl = purchaseOrderDtl.ToString() });
        }

        public async Task<string> DeletePurchaseOrderDtl(int purchaseOrderDtlId)
        {
            var deleteTaxInvDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeletePurchaseOrderDtl",
                                  new { @PurchaseOrderDtlId = purchaseOrderDtlId });

            return deleteTaxInvDtl;
        }


        //public async Task<string> DeletePurchaseOrder(int purchaseOrderHdrId)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
