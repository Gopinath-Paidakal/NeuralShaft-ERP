using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IEmployee
    {
        Task<string> GetEmployee();
        Task<string> GetEmpById(int empId, string getEmpData);
        Task<string> InsertEmp(string insertEmpData, object empData);
        Task<string> UpdateEmp(int EmpId, string updateEmpData, object empData);



        //Task<List<string>> UploadImagesAsync(List<IFormFile> files, int empId);
    }
}
