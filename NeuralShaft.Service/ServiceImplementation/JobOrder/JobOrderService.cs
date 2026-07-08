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

        public async Task<string> GetJobOrderBOM(int ddProdctId, int soDtlId)
        {
            string jobOrderList = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetJobOrderBOM",
                                 new { @DDProductId = ddProdctId, @SODtlId = soDtlId });
            return jobOrderList;
        }

        public async Task<string> InsertJobOrderBOM(object jobOrderBOM)
        {
            string insertJOBOM = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertJobOrderBOM", new { @JobOrderBOM = jobOrderBOM.ToString() });
            return (insertJOBOM);

        }
    }
}
