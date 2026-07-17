using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Stocks
{
    public interface IStocksInward
    {
        Task<string> GetStocksInward(string fromDate, string toDate);
        Task<string> GetStocksInwardById(int stocksInwardHdrId);
        Task<string> InsertStocksInward(object stocksInward);
        Task<string> UpdateStocksInward(int stocksInwardHdrId, object stocksInward);
        Task<string> DeleteStocksInward(int stocksInwardHdrId);
    }
}
