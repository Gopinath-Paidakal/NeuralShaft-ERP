using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Previlege;
using System;
using System.Collections.Generic;
using System.Security;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Previlege
{
    public class MenuPermissionService : IMenuPermissions
    {
        private readonly IJsonRepository _repoJSon;

        public MenuPermissionService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetMenuPermissions()
        {
            try
            {
                string GetPermissions = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getMenuPermissions");
                return GetPermissions;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetMenuPermissionsById(int empId)
        {
            try
            {
                string GetPermissionsById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetMenuPermissionsById", new { @EmpId = empId });
                return GetPermissionsById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertMenuPermissions(object permission)
        {
            try
            {
                string insertPermissions = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertMenuPermissions", new { @Permissions = permission.ToString() });
                return (insertPermissions);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateMenuPermissions(object permission)
        {
            try
            {
                string updatePermissions = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateMenuPermissions", new {@Permissions = permission.ToString() });
                return (updatePermissions);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteMenuPermissions(int permissionsId)
        {
            try
            {
                string DelPermissions = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteMenuPermissions", new { @PermissionsId = permissionsId });
                return DelPermissions;
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
