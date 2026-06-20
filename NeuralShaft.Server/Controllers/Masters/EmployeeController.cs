
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Upload;


//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using Newtonsoft.Json;
using Org.BouncyCastle.Ocsp;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.Masters
{
    [ApiController]
    [Route("[controller]")]
    public class EmployeeController : Controller
    {
        private readonly IEmployee _EmployeeService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/hrms/";

        public EmployeeController(IEmployee service, IWebHostEnvironment env, IUpload upload)
        {
            _EmployeeService = service;
            _env = env;
            _uploadService = upload;
        }

        [HttpGet("GetEmployee")]
        public async Task<ActionResult> GetEmployee()
        {
            string getEmployee = await _EmployeeService.GetEmployee();
            return Content(getEmployee, "application/json");
        }


        [HttpGet("GetEmployeeById/{empId}/{GetEmpData}")]
        public async Task<ActionResult> GetEmpById(int empId , string GetEmpData)
        {

            var empById = await _EmployeeService.GetEmpById(empId, GetEmpData);

            //-------- Download files from the server
            //var downloadImages = await _uploadService.DownloadFilesAsync(savePath, empId);

            // 🔹 3. Combine
            return Ok(new
            {
                EnqHdr = empById,
                //Images = downloadImages
            });
            //-------- Download files from the server

            //int len = json.ToString().Length;
            //return Content(empById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertEmployee/{InsertEmpData}")]
        ///[FromForm] string enqHdrDtl, [FromForm] List<IFormFile> attachments
        public async Task<IActionResult> InsertEmp([FromForm] string empData, [FromForm] List<IFormFile> attachments, string InsertEmpData)
        //public async Task<IActionResult> InsertEmp([FromBody] object empData)
        {
            var insertEmpId = await _EmployeeService.InsertEmp(InsertEmpData, empData);

            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(insertEmpId.ToString()));
            }

            return Ok(insertEmpId);

            //await _service.InsertEnquiry(data);
            //return Ok();

        }

        [HttpPost("UpdateEmployee/{EmpId}/{UpdateEmpData}")]
        public async Task<IActionResult> UpdateEmp(int empId, [FromForm] object empData, [FromForm] List<IFormFile> attachments, string updateEmpData)
        //public async Task<IActionResult> UpdateEmp(int EmpId, [FromBody] object empData)
        {
            var updateEmpId = await _EmployeeService.UpdateEmp(empId, updateEmpData, empData);

            ////================= Add Images in Edit only add files ????
            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(updateEmpId.ToString()));
            }

            //// ==============================
            ///
            return Ok(updateEmpId);
        }
    }
}


//var uploaded = await _EmployeeService.UploadImagesAsync(attachments, Convert.ToInt32(insertEmpId.ToString()));
//var uploaded = await _EmployeeService.UploadImagesAsync(attachments, Convert.ToInt32(updateEmpId.ToString()));


////====================================== Local Path
///// =========== Get Images 
////string folder = @"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.Server\UploadNew\Images\Enquiry";

////=============  Cloud Path
////string folder = "/var/www/backend/UploadNew/Images/Enquiry";
//string folder = "/var/www/uploads/hrms/";
////string folder = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");


//var files = Directory.GetFiles(folder, $"{empId}_*")
//                         .Select(f => Path.GetFileName(f))
//                         .ToList();

////var baseUrl = $"{Request.Scheme}://{Request.Host}/var/www/backend/UploadNew/images/enquiry/";
////var baseUrl = $"{Request.Scheme}://{Request.Host}/Images/Enquiry/";
//var baseUrl = $"{Request.Scheme}://{Request.Host}/uploads/hrms/";

//var imageUrls = files.Select(f => baseUrl + f).ToList();
////var imageUrls = files.Select(f => baseUrl + Uri.EscapeDataString(f)).ToList();
////===============================================