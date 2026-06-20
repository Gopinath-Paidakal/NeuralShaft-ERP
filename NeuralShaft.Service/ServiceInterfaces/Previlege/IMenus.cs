using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Previlege
{
    public interface IMenus
    {
        Task<string> GetMenus(int empId);
    }
}
