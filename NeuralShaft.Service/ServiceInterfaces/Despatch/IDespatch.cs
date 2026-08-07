using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Despatch
{
    public interface IDespatch
    {
        Task<string> GetDespatch(string fromDate, string toDate);
        Task<string> GetDespatchById(int despatchId);
        Task<string> InsertDespatch(object despatch);
        Task<string> UpdateDespatch(int despatchId, object despatch);
        Task<string> DeleteDespatch(int despatchId);
    }
}
