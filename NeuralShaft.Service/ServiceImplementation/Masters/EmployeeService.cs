using Dapper;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class EmployeeService : IEmployee
    {
        private readonly IJsonRepository _EmpJSon;
        private readonly IWebHostEnvironment _env;

        public EmployeeService(IJsonRepository repoJson, IWebHostEnvironment env)
        {
            _EmpJSon = repoJson;
            _env = env;
        }

        public async Task<string> GetEmpById(int empId, string getEmpData)
        {
            try
            {
                return await _EmpJSon.ExecuteJsonSPWithParameter("SP_GetEmp_ById", new { @EmpId = empId , @GetEmpData = getEmpData });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // 
            }
        }

        public async Task<string> GetEmployee()
        {
            try
            {
                string Employee = await _EmpJSon.ExecuteJsonSPWithoutParameter("SP_GetEmployee");
                return Employee;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertEmp(string insertEmpData, object empData)
        {
            try
            {
                string addEmpData = await _EmpJSon.ExecuteJsonSPWithParameter("SP_InsertEmp", 
                                    new { @InserEmpData = insertEmpData, @Emp = empData.ToString() });
                return (addEmpData);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateEmp(int EmpId, string updateEmpData, object empData)
        {
            try
            {
                string editEmpData = await _EmpJSon.ExecuteJsonSPWithParameter("SP_UpdateEmp", 
                                    new { @EmpId = EmpId, @UpdateEmpData = updateEmpData, @Emp = empData.ToString() });
                return (editEmpData);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        //public async Task<List<string>> UploadImagesAsync(List<IFormFile> files, int empId)
        //{
        //    var uploadedFiles = new List<string>();

        //    if (files == null || files.Count == 0)
        //        return uploadedFiles;

        //    /// --------- Local path
        //    string uploadPath = Path.Combine(_env.ContentRootPath, "UploadNew\\Images\\Hrms");

        //    // --------- Cloud Path
        //    //string uploadPath = Path.Combine("/var/www/uploads/hrms/");    //, trustedFileName);

        //    if (!Directory.Exists(uploadPath))
        //        Directory.CreateDirectory(uploadPath);

        //    foreach (var file in files)
        //    {
        //        if (file.Length > 0)
        //        {
        //            var fileName = empId + "_" + file.FileName;
        //            //var fileName = "108_" + Path.GetExtension(file.FileName);
        //            //var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
        //            var filePath = Path.Combine(uploadPath, fileName);

        //            using (var stream = new FileStream(filePath, FileMode.Create))
        //            {
        //                await file.CopyToAsync(stream);
        //            }
        //            uploadedFiles.Add(fileName);
        //        }
        //    }
        //    return uploadedFiles;
        //}
    }
}


//string uploadPath = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");
//string uploadPath = Path.Combine(_env.WebRootPath, "UploadNew", "Images", "Enquiry");
//string uploadPath = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");