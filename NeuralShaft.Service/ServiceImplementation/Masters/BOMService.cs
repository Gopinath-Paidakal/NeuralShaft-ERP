using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class BOMService : IBOM
    {
        private readonly IJsonRepository _repoJSon;

        public BOMService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetBOM()
        {
            try
            {
                string getBOM = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetBOMList");
                return getBOM;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertBOM(object BOM)
        {
            try
            {
                string insertBOM = await _repoJSon.ExecuteJsonSPWithParameter("Sp_InsertBOM", new { @BOM = BOM.ToString() });
                return (insertBOM);
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }
    }
}
