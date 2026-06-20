using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.OrderApprove
{
    public interface IOrdApprove
    {
        Task<string> GetOrdApprove();

        Task<string> GetOrdReject(string fromDate, string toDate);
        Task<string> InsertOrdApprove(object OrdApprove);

        Task<string> UpdateOrdRej(int @EnqDtlId, string OrdApproved);


    }
}
