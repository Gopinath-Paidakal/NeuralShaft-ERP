using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.JobOrder
{
    public interface IJobOrder
    {
        Task<string> GetJobOrder(string fromDate, string toDate);

        Task<string> GetJobOrderBOM(int ddProdctId, int soDtlId);

        Task<string> InsertJobOrderBOM(object jobOrderBOM);

    }
}
