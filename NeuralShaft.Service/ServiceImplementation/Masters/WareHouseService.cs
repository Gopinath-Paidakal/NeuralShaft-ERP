using NeuralShaft.Repository.RepoInterfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class WareHouseService : IWareHouse
    {
        private readonly IJsonRepository _repoJSon;

        public WareHouseService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetWareHouse()
        {
            string GetWareHouse = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetWareHouse");
            return GetWareHouse;
        }

        public async Task<string> GetWareHouseById(int wareHouseId)
        {
            string GetWareHouseById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetWareHouseById", new { @WareHouseHdrId = wareHouseId });
            return GetWareHouseById;
        }

        public async Task<string> InsertWareHouse(object wareHouse)
        {
            string insertWareHouse = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertWareHouse", new { @WareHouse = wareHouse.ToString() });
            return (insertWareHouse);
        }

        public async Task<string> UpdateWareHouse(int wareHouseId, object wareHouse)
        {
            string updateWareHouse = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateWareHouse", new { @WareHouseId = wareHouseId, @WareHouse = wareHouse.ToString() });
            return (updateWareHouse);
        }
    }
}
