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
        Task<string> UpdateStocksInwardHdr(int stocksInwardHdrId, object stocksInwardHdr);
        //Task<string> DeleteStocksInward(int stocksInwardHdrId);

        //----- StocksInwardDtl Dtl
        Task<string> InsertStocksInwardDtl(object siInwardDtl);

        Task<string> UpdateStocksInwardDtl(int stocksInwardDtlId, object siInwardDtl);

        Task<string> DeleteStocksInwardDtl(int stocksInwardDtlId);   //, object siInwardDtl);
    }
}
