using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IBOM
    {
        Task<string> GetBOM();

        Task<string> GetBOMByProdId(int productId);

        Task<string> InsertBOMMst(object BOMMst);

        Task<string> DeleteBOMById(int bomMstId);
    }
}
