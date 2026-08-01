using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Purchase;
using NeuralShaft.Service.ServiceInterfaces.Stocks;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Stocks
{
    public class StocksInwardService : IStocksInward
    {
        private readonly IJsonRepository _repoJSon;

        public StocksInwardService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;

        }

        public async Task<string> GetStocksInward(string fromDate, string toDate)
        {
            string getStocksInward = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetStocksInward",
                                   new { @FromDate = fromDate, @ToDate = toDate });
            return getStocksInward;
        }

        public async Task<string> GetStocksInwardById(int stocksInwardHdrId)
        {
            var getStocksInwardById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetStocksInwardById",
                                  new { @StocksInwardHdrId = stocksInwardHdrId }); //@EnqDtlId = enqDtlId
            return getStocksInwardById;
        }

        public async Task<string> InsertStocksInward(object stocksInward)
        {
            var insertStocksInward = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertStocksInward", new { @StocksInwardHdr = stocksInward.ToString() });
            return (insertStocksInward);
        }

        public async Task<string> UpdateStocksInwardHdr(int stocksInwardHdrId, object stocksInward)
        {
            var updateStockInward = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateStocksInwardHdr",
                              new { @StocksInwardHdrId = stocksInwardHdrId, @StocksInwardHdr = stocksInward.ToString() });
            return (updateStockInward);
        }


      
        public async Task<string> InsertStocksInwardDtl(object siInwardDtl)
        {
            string insertSIDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertStocksInwardDtl", new { @StocksInwardDtl = siInwardDtl.ToString() });
            return (insertSIDtl);
        }

        public async Task<string> UpdateStocksInwardDtl(int stocksInwardDtlId, object siInwardDtl)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateStocksInwardDtl", new {
                                                @StocksInwardDtlId = stocksInwardDtlId,
                                                @StocksInwardDtl = siInwardDtl.ToString() });
        }

        public async Task<string> DeleteStocksInwardDtl(int stocksInwardDtlId)
        {
            var deleteSIDtl = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteStocksInwardDtl",
                                  new { @StocksInwardDtlId = stocksInwardDtlId });

            return deleteSIDtl;
        }


        //public Task<string> DeleteStocksInward(int StocksInwardHdrId)
        //{
        //    throw new NotImplementedException();
        //}

    }
}
