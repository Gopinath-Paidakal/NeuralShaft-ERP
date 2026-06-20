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
            string quoteData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetJobOrder",
                                  new { @FromDate = fromDate, @ToDate = toDate });
            return quoteData;
        }
    }
}
