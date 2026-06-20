using System;
using System.Collections.Generic;
using System.Text;
using NeuralShaft.Model;

namespace NeuralShaft.Repository.RepoInterfaces
{
    public  interface IFormDefaultDataRepository
    {
         Task<string> GetFormDefaultData();      
         Task<Int16> InsertFormDefaultData(FormDefaultData formdefaultdata);
         Task<Int16> UpdateFormDefaultData(FormDefaultData formdefaultdatat);
         
    }
}

//Task <string> GetAllDepartments();
//Task<Department> GetById(int id);
//Task<Department> InsertDetpartment(Department department);
//Task<Department> UpdateDepartment(Department department);
//Task<Int16> DeleteDepartment(int id);
//Task<Int16> GetDepartmentById(int id);