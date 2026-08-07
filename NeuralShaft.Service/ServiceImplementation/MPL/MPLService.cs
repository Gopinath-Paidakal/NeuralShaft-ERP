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

        public async Task<string> GetMPL(string fromDate, string toDate)
        {
            string GetMPL = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetMPL",
                                new { @FromDate = fromDate, @ToDate = toDate });
            return GetMPL;
        }

        public async Task<string> GetMPLById(int mplHdrId)
        {
            string GetMPLById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetMPLById", new { @MPLHdrId = mplHdrId });
            return GetMPLById; ;
        }

        public async Task<string> InsertMPLHdrDtl(object mplHdr)
        {
            string insertMPL = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertMPL", new { @MplHdrDtl = mplHdr });
            return (insertMPL);

        }
    }
}
