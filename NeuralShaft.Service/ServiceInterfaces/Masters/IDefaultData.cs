using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IDefaultData
    {
        Task<string> GetDefaulData(string formType);

        Task<string> InsertDefaultData(object defalutData);
        Task<string> UpdateDefaultData(int DefaultDataId, object defaultData);
        
    }
}
