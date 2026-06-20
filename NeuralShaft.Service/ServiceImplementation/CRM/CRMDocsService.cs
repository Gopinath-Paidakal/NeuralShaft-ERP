using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.CRM
{
    public class CRMDocsService : ICRMDocs
    {
        private readonly IJsonRepository _repoJSon;

        public CRMDocsService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> InsertCRMDocs(object crmDocs)
        {
            return await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertCRMDocs", new { @CRMDocs = crmDocs.ToString() });
        }
    }
}
