using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface IDefaultDataDocs
    {
        Task<string> GetDefaultDataDocs(string defaultDataDocType);

       
    }
}
