using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.JobOrder
{
    public interface IJobOrder
    {
        Task<string> GetJobOrder(string fromDate, string toDate);
    }
}
