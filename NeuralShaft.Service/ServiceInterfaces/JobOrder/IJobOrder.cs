using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.JobOrder
{
    public interface IJobOrder
    {
        Task<string> GetJobOrder(string fromDate, string toDate);

        Task<string> GetJobOrderByOrdClientHdrId(int OrdClientHdrId);

        Task<string> GetJobOrderBOM(int ddProdctId, int soDtlId);

        Task<string> GetJobOrderBOMUpdate(int soDtlId);

        Task<string> InsertJobOrderBOM(object jobOrderBOM);

        Task<string> InsertJOBOMItem(object jobOrderBOMItem);

        Task<string> UpdateJOBOMItem(int JobOrderBOMId, int qty);

        Task<string> DeleteJOBOMItem(int JobOrderBOMId);


    }
}
