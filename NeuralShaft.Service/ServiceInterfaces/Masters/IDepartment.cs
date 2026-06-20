using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IDepartment
    {
        Task<string> GetDepartment();
        Task<string> GetDepartmentById(int deptId);
        Task<string> InsertDepartment(object dept);
        Task<string> UpdateDepartment(int deptId, object dept);
        Task<string> DeleteDepartment(int deptId);
    }
}
