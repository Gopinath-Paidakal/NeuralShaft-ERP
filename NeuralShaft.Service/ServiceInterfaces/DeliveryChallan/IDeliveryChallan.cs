using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.DeliveryChallan
{
    public interface IDeliveryChallan
    {
        Task<string> GetDeliveryChallan(string fromDate, string toDate);
        Task<string> GetOrdClientByIdDeliveryChallan(int ordClientHdrId);
        Task<string> GetDeliveryChallanById(int dCHdrId);
        Task<string> InsertDeliveryChallan(object deliveryChallan);
        Task<string> UpdateDeliveryChallan(int dCHdrId, object deliveryChallan);
        Task<string> DeleteDeliveryChallan(int dCHdrId);
    }
}
