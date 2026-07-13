using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.DeliveryChallan;
//using NeuralShaft.Service.ServiceInterfaces.TaxInvoice;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.DeliveryChallan
{
    public class DeliveryChallanService : IDeliveryChallan
    {
        private readonly IJsonRepository _repoJSon;

        public DeliveryChallanService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;

        }

        public async Task<string> GetOrdClientByIdDeliveryChallan(int ordClientHdrId)
        {
            var GetOrdClientHdrByIdDC = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetOrdClientByIdDC",
                                 new { @ordClientHdrId = ordClientHdrId }); //@EnqDtlId = enqDtlId
            return GetOrdClientHdrByIdDC;
        }

        public async Task<string> GetDeliveryChallan(string fromDate, string toDate)
        {
            string DeliveryChallan = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetDeliveryChallan",
                                   new { @FromDate = fromDate, @ToDate = toDate });
            return DeliveryChallan;
        }

        public async Task<string> GetDeliveryChallanById(int dCHdrId)
        {
            var deliveryChallanById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetDeliveryChallanById",
                                   new { @DCHdrId = dCHdrId }); //@EnqDtlId = enqDtlId
            return deliveryChallanById;
        }

        public async Task<string> InsertDeliveryChallan(object deliveryChallan)
        {
            var insertDC = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertDeliveryChallan", new { @DeliveryChallan = deliveryChallan.ToString() });
            return (insertDC);
        }

        public async Task<string> UpdateDeliveryChallan(int dCHdrId, object deliveryChallan)
        {
            var updateDC = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateDeliveryChallan",
                               new { @DCHdrId = dCHdrId, @DeliveryChallanUpdate = deliveryChallan.ToString() });
            return (updateDC);
        }


        public Task<string> DeleteDeliveryChallan(int dCHdrId)
        {
            throw new NotImplementedException();
        }

       
    }
}
