using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Previlege;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Previlege
{
    public class MenuService : IMenus
    {
        private readonly IJsonRepository _repoJSon;

        public MenuService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }
        public async Task<string> GetMenus(int empId )
        {
            try
            {
                string GetMenus = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetMenus", new { @EmpId = empId });
                return GetMenus;
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
