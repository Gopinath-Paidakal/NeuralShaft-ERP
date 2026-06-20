using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using Org.BouncyCastle.Ocsp;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.CRM
{
    public class DefaultDataDocsService : IDefaultDataDocs
    {
        private readonly IJsonRepository _docsJSon;

        public DefaultDataDocsService(IJsonRepository repoJson)
        {
            _docsJSon = repoJson;
        }
        public async Task<string> GetDefaultDataDocs(string defaultDataDocType)
        {
            string getDocs = await _docsJSon.ExecuteJsonSPWithParameter("SP_GetDefaultDataDocs",
                                        new { @DefaultDataDocType = defaultDataDocType });

            return getDocs;
        }
       
    }
}
