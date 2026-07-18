using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.JobOrder;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.JobOrder
{
    public class JobOrderService : IJobOrder
    {
        private readonly IJsonRepository _repoJSon;

        public JobOrderService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetJobOrder(string fromDate, string toDate)
        {
            string jobOrderList = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetJobOrder",
                                  new { @FromDate = fromDate, @ToDate = toDate });
            return jobOrderList;
        }

        public async Task<string> GetJobOrderByOrdClientHdrId(int OrdClientHdrId)
        {
            string jobOrderNosList = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetJOByOrdClientHdrId",
                                 new { @OrdClientHdrId = OrdClientHdrId});
            return jobOrderNosList;
        }

        public async Task<string> GetJobOrderBOM(int ddProdctId, int soDtlId)
        {
            string jobOrderList = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetJobOrderBOM",
                                 new { @DDProductId = ddProdctId, @SODtlId = soDtlId });
            return jobOrderList;
        }

        public async Task<string> GetJobOrderBOMUpdate(int soDtlId)
        {
            string jobOrderUpdateList = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetJobOrderBOMUpdate",
                                new { @SODtlId = soDtlId });
            return jobOrderUpdateList;
        }

        public async Task<string> InsertJobOrderBOM(object jobOrderBOM)
        {
            string insertJOBOM = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderBOM", new { @JobOrderBOM = jobOrderBOM.ToString() });
            return (insertJOBOM);

        }

        public async Task<string> InsertJOBOMItem(object jobOrderBOMItem)
        {
            string insertJOBOMItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertJOBOMItem", new { @JobOrderBOMItem = jobOrderBOMItem.ToString() });
            return (insertJOBOMItem);
        }

        public async Task<string> UpdateJOBOMItem(int JobOrderBOMId, int qty)
        {
            string updateJOBItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateJOBOMItem", new { @JobOrderBOMId = JobOrderBOMId, @Qty = qty});
            return (updateJOBItem);
        }

        public async Task<string> DeleteJOBOMItem(int JobOrderBOMId)
        {
            string deleteJOBItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteJOBOMItem", new { @JobOrderBOMId = JobOrderBOMId });
            return deleteJOBItem;
        }
    }
}
