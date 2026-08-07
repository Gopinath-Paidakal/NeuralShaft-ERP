using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Despatch;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Desparch
{
    public class DespatchService : IDespatch
    {

        private readonly IJsonRepository _repoJSon;
        public DespatchService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetDespatch(string fromDate, string toDate)
        {
            string GetDespatch = await _repoJSon.ExecuteJsonSPWithParameter("SP_getDespatch",
                                new { @FromDate = fromDate, @ToDate = toDate });
            return GetDespatch;
        }

        public async Task<string> GetDespatchById(int despatchId)
        {
            string GetDespatchById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetDespatchById", new { @DespatchId = despatchId });
            return GetDespatchById; ;
        }

        public async Task<string> InsertDespatch(object despatch)
        {
            string insertDespatch = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertDespatch", new { @DespatchAllocation = despatch.ToString() });
            return (insertDespatch);

        }

        public async Task<string> UpdateDespatch(int despatchId, object despatch)
        {
            string updateDespatch = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateDespatch", new { @DespatchId = despatchId, @DespatchAllocation = despatch.ToString() });
            return (updateDespatch);
        }

        public async Task<string> DeleteDespatch(int despatchId)
        {
            string DelDespatch = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteDespatch", new { @DespatchId = despatchId });
            return DelDespatch;
        }

    }
}
