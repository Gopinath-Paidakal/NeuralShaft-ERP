using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using Org.BouncyCastle.Ocsp;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation
{
    public class DepartmentService : IDepartment
    {
        private readonly IJsonRepository _repoJSon;

        public DepartmentService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetDepartment()
        {
            try
            {
                string GetDept = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getDept");
                return GetDept;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetDepartmentById(int deptId)
        {
            try
            {
                string GetDeptById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetDeptById", new { @DeptId = deptId });
                return GetDeptById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertDepartment(object dept)
        {
            try
            {
                string insertDept = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertDept", new { @Department = dept.ToString() });
                return (insertDept);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateDepartment(int deptId, object dept)
        {
            try
            {
                string updateDept = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateDept", new { @DeptId= deptId, @Department = dept.ToString() });
                return (updateDept);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }

        }

        public async Task<string> DeleteDepartment(int deptId)
        {
            try
            {
                string DelDept = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteDept", new { @DeptId = deptId });
                return DelDept;
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
