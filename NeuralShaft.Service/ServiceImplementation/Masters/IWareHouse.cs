using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public interface IWareHouse
    {
        Task<string> GetWareHouse();
        Task<string> GetWareHouseById(int wareHouseId);
        Task<string> InsertWareHouse(object wareHouse);
        Task<string> UpdateWareHouse(int wareHouseId, object wareHouse);
        //Task<string> DeleteWareHouse(int deptId);
    }
}
