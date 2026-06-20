using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class CompanyService : ICompany
    {
        private readonly IJsonRepository _repoJSon;

        public CompanyService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }
        public async Task<string> GetCompany()
        {
            try
            {
                string GetCompany = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetCompany");
                return GetCompany;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateCompany(int companyId, object company)
        {
            try
            {
                string updateCompany = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateCompany", new { @CompanyId = companyId, @Company = company.ToString() });
                return (updateCompany);

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
