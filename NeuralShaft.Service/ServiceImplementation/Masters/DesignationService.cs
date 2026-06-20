using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class DesignationService : IDesignation
    {
        private readonly IJsonRepository _repoJSon;

        public DesignationService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetDesignation()
        {
            try
            {
                string GetDesig = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getDesig");
                return GetDesig;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetDesignationById(int desigId)
        {
            try
            {
                string GetDesigById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetDesigById", new { @DesigId = desigId });
                return GetDesigById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertDesignation(object desig)
        {
            try
            {
                string insertDesig = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertDesig", new { @Desig = desig.ToString() });
                return (insertDesig);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateDesignation(int desigId, object desig)
        {
            try
            {
                string updateDesig = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateDesig", new { @DesigId = desigId, @Desig = desig.ToString() });
                return (updateDesig);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteDesignation(int desigId)
        {
            try
            {
                string DelDesig = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteDesig", new { @DesigId = desigId });
                return DelDesig;
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
