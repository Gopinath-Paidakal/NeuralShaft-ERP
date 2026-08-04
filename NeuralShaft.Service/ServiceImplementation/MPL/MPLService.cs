using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.MPL;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.MPL
{
    public class MPLService : IMPL
    {
        private readonly IJsonRepository _repoJSon;

        public MPLService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;

        }
        public async Task<string> InsertMPLHdrDtl(object mplHdr)
        {
            string insertDept = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertMPL", new { @MplHdrDtl = mplHdr });
            return (insertDept);

        }
    }
}
