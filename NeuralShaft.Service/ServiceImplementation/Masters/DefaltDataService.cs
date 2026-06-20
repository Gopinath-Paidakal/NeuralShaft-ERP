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
using Microsoft.Extensions.Primitives;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class DefaltDataService : IDefaultData
    {
        private readonly IJsonRepository _repoJSon;

        public DefaltDataService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetDefaulData(string formType)
        {
            try
            {   
                string formDefaultData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetDefaultData",
                                            new { @FormType = formType});

                return formDefaultData;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertDefaultData(object defaultData)
        {
            try
            {
                string insertDefaultData = await _repoJSon.ExecuteJsonSPWithParameter("Sp_InsertDefaultData", new { @DefaultData = defaultData.ToString() });
                return (insertDefaultData);
                
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateDefaultData(int DefaultDataId, object defaultData)
        {
            try
            {
                string updateDefaltData = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateDefaultData", 
                                        new { @DefaultDataId = DefaultDataId,  @DefaultData = defaultData.ToString() });
                return (updateDefaltData);

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
