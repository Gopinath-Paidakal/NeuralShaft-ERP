using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.MPL
{
    public interface IMPL
    {
        Task<string> InsertMPLHdrDtl(object mplHdr);
    }
}
