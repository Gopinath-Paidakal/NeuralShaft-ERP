using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.MPL
{
    public interface IMPL
    {
        Task<string> GetMPL(string fromDate, string toDate);

        Task<string> GetMPLById(int mplHdrId);

        Task<string> InsertMPLHdrDtl(object mplHdr);


    }
}
