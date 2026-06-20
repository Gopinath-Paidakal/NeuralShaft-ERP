using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using Dapper;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class EnqClientService : IEnqClient
    {
        private readonly IJsonRepository _repoJSon;
       
        public EnqClientService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetClient()
        {
            try
            {
                string clientData = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetClient");
                //string clientData = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetShaft");
                return clientData;
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
