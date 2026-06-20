using System;
using System.Collections.Generic;
using System.Text;
using NeuralShaft.Model;

namespace NeuralShaft.Service.ServiceInterfaces
{
    public interface IDepartmentService
    {
        //Task<string> GetAllDepartments();
        Task<string> GetDepartments();
        Task<string> GetJSonDepartments();

        Task<Int16> InsertDepartment(Department department);
        Task<Int16> UpdateDepartment(Department department);
        Task<Int16> DeleteDepartment(int id);
        Task<Int16> GetDepartmentById(int id);
    }
}


//Task<IEnumerable<Department>> GetAllDepartments();
////Task<Department> GetProduct(int id);
//Task<Department> CreateProduct(Department department);
//Task<Department> UpdateProduct(Department department);
////Task DeleteProduct(int id);