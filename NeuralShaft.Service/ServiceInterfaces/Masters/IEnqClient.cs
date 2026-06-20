using System;
using System.Collections.Generic;
using System.Text;
//using NeuralShaft.Model;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IEnqClient
    {
        Task<string> GetClient();
    }
}
