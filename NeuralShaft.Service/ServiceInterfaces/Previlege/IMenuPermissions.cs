using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Previlege
{
    public interface IMenuPermissions
    {
        Task<string> GetMenuPermissions();
        Task<string> GetMenuPermissionsById(int userId);
        Task<string> InsertMenuPermissions(object menuPermission);
        Task<string> UpdateMenuPermissions(object menuPermission);
        Task<string> DeleteMenuPermissions(int menuPermissionsId);
    }
}
