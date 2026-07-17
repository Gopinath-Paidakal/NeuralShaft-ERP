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

        public async Task<string> UpdateStocksInward(int stocksInwardHdrId, object stocksInward)
        {
            var updateStockInward = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateStocksInward",
                              new { @StocksInwardHdrId = stocksInwardHdrId, @StocksInwardUpdate = stocksInward.ToString() });
            return (updateStockInward);
        }


        public Task<string> DeleteStocksInward(int StocksInwardHdrId)
        {
            throw new NotImplementedException();
        }
    }
}
