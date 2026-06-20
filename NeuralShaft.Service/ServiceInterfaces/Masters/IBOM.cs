using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IBOM
    {
        Task<string> GetBOM();
        Task<string> InsertBOM(object BOM);
    }
}
