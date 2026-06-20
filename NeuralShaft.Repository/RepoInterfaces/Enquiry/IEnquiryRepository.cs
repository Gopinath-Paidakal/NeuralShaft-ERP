using System;
using System.Collections.Generic;
using System.Text;
using NeuralShaft.Model;

namespace NeuralShaft.Repository.RepoInterfaces
{
    public  interface IEnquiryRepository
    {
         Task<string> GetEnquiry();
         Task<string> GetEnquiryById(int enquiryId);
         Task<string> GetEnquiryFollowUp();
         Task<string> InsertEnquiry(object enqdata);
         Task<Int16> UpdateEnquiry(object enqdata);
         
    }
}

//Task <string> GetAllDepartments();
//Task<Department> GetById(int id);
//Task<Department> InsertDetpartment(Department department);
//Task<Department> UpdateDepartment(Department department);
//Task<Int16> DeleteDepartment(int id);
//Task<Int16> GetDepartmentById(int id);