using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.CRM
{
    public interface ICRMDocs
    {
        Task<string> InsertCRMDocs(object crmDocs);

    }
}
