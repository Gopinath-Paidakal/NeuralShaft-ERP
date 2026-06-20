using System;
using System.Collections.Generic;
using System.Text;
using NeuralShaft.Model;

namespace NeuralShaft.Repository.RepoInterfaces
{
    public  interface IDepartmentRepository
    {
         Task<string> GetAllDepartments();      
         Task<Int16> InsertDetpartment(Department department);
         Task<Int16> UpdateDepartment(Department department);
         Task<Int16> DeleteDepartment(int id);
         Task<Int16> GetDepartmentById(int id);
    }
}
//Task <string> GetAllDepartments();
//Task<Department> GetById(int id);
//Task<Department> InsertDetpartment(Department department);
//Task<Department> UpdateDepartment(Department department);