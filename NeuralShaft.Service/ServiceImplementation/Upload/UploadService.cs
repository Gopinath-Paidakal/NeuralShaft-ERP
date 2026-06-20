using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Buffers.Text;
using System.Collections.Generic;
using System.Data;
using System.Text;


namespace NeuralShaft.Service.ServiceImplementation.Upload
{
    public class UploadService : IUpload
    {
        private readonly IJsonRepository _repoJSon;
        private readonly IWebHostEnvironment _env;
        private readonly IFile _fileService;

        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public UploadService(IJsonRepository repoJson, IWebHostEnvironment env, IHttpContextAccessor httpContextAccessor, IConfiguration configuration, IFile fileService)
        {
            _repoJSon = repoJson;
            _env = env;
            _httpContextAccessor = httpContextAccessor;
            _configuration = configuration;
            _fileService = fileService;
        }

        //public async Task<List<string>> UploadFilesAsync(IFormFile[] files, string path, int Id)
        public async Task<List<string>> UploadFilesAsync(List<IFormFile> attachments, string path, int Id)
        {
            try
            {
                var uploadedFiles = new List<string>();

                if (attachments == null || attachments.Count == 0)
                    return uploadedFiles;

                /// --------- Local path
                string uploadPath = _configuration["FileSettings:UploadPath"];
                uploadPath = uploadPath + path;

                //string uploadPath = Path.Combine(_env.ContentRootPath, "UploadsNew\\Images\\Enquiry");

                // --------- Path
                //string uploadPath = Path.Combine("/var/www/uploads/enquiry/");    //, trustedFileName);

                if (!Directory.Exists(uploadPath))
                    Directory.CreateDirectory(uploadPath);

                foreach (var file in attachments)
                {
                    if (file.Length > 0)
                    {
                        var fileName = Id + "_" + file.FileName;

                        var filePath = Path.Combine(uploadPath, fileName);

                        using (var stream = new FileStream(filePath, FileMode.Create))
                        {
                            await file.CopyToAsync(stream);
                        }
                        Console.WriteLine(fileName.ToString());
                        uploadedFiles.Add(fileName);
                    }
                }

                //====== save file path and file names in db table
                //===============================================
                for (int i = 0; i < attachments.Count; i++)
                {
                    int docFileId = Id;
                    //string docType = "Enquiry";
                    string docPath = uploadPath.ToString();     ///+ path;
                    string docFileName = uploadedFiles[i].ToString();

                    var fileJson = new
                    {
                        DocFileId = Id,
                        //DocType = docType,
                        DocPath = docPath,
                        DocFileName = docFileName
                    };

                    string insertFileJson = JsonConvert.SerializeObject(fileJson);
                    Console.WriteLine(insertFileJson.ToString());

                    var insertFile = await _fileService.InsertFile(insertFileJson);

                }

                return uploadedFiles;
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }

        }

        public async Task<List<string>> DownloadFilesAsync(string path, int Id)
        {
            try
            {
                //// ========= Get the path and files from db
                /// ==============================================
                var baseFullUrl = new List<string>();

                string baseUrl = _configuration["FileSettings:DownloadPath"];
                //baseUrl = baseUrl + path;

                var getFilesById = await _fileService.GetFileById(Id);

                JObject obj = JObject.Parse(getFilesById);

                foreach (JObject file in obj["Files"])
                {
                    string docPath = path;                                     // file["DocPath"]?.ToString() ?? "";
                    string fileName = file["DocFileName"]?.ToString() ?? "";

                    // remove duplicate slashes
                    string fullUrl =
                        $"{baseUrl.TrimEnd('/')}/" +
                        $"{docPath.Trim('/').Replace("\\", "/")}/" +
                        $"{fileName}";

                    //file["DocURL"] = fullUrl;
                    baseFullUrl.Add(fullUrl);
                }

                //return imageUrls;
                return baseFullUrl;
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }


        public async Task<List<string>> DownloadFilesAsync(string path)
        {
            try
            {

                //// ========= Get the path and files from db
                /// ==============================================
                var baseFullUrl = new List<string>();

                string baseUrl = _configuration["FileSettings:DownloadPath"];
                baseUrl = baseUrl + path;

                //var getFilesById = await _fileService.GetFileById(Id);

                //JObject obj = JObject.Parse(getFilesById);

                var files = Directory.GetFiles(baseUrl);

                foreach (var file in files)
                {
                    string docPath = path;                                     // file["DocPath"]?.ToString() ?? "";
                    //string fileName = file["DocFileName"]?.ToString() ?? "";

                    string fileName = Path.GetFileName(file);

                    // remove duplicate slashes
                    string fullUrl =
                        $"{baseUrl.TrimEnd('/')}/" +
                        $"{docPath.Trim('/').Replace("\\", "/")}/" +
                        $"{fileName}";

                    //file["DocURL"] = fullUrl;
                    baseFullUrl.Add(fullUrl);
                }

                //return imageUrls;
                return baseFullUrl;
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


/////var Request = _httpContextAccessor.HttpContext.Request;

////////====================================== Local Path
///////// =========== Local Path 
////////string folder = @"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.Server\UploadNew\Images\Enquiry";

////////=============  Cloud Path
////////string folder = "/var/www/uploads/enquiry/";

//////string downLoadPath = _configuration["FileSettings:DownloadPath"];
//////downLoadPath = downLoadPath + path;

//////var files = Directory.GetFiles(downLoadPath, $"{Id}_*")
//////                         .Select(f => Path.GetFileName(f))
//////                         .ToList();

//////// --- Local Path
////////var baseUrl = $"{Request.Scheme}://{Request.Host}\\UploadsNew\\Images\\Enquiry\\";

//////// Cloud Path
//////var baseUrl = $"{Request.Scheme}://{Request.Host}" + downLoadPath.ToString();    



//////var imageUrls = files.Select(f => baseUrl + f).ToList();




//using Newtonsoft.Json.Linq;

//string baseUrl = "https://abc.com";

//string json = @"{
//  'Files': [
//    {
//      'FilesId': 2,
//      'DocPath': '/uploads/enquiry/',
//      'DocFileName': 'abc.jpg'
//    },
//    {
//      'FilesId': 3,
//      'DocPath': '/uploads/enquiry/',
//      'DocFileName': 'abc.pdf'
//    }
//  ]
//}";

//JObject obj = JObject.Parse(json);

//foreach (JObject file in obj["Files"])
//{
//    string docPath = file["DocPath"]?.ToString() ?? "";
//    string fileName = file["DocFileName"]?.ToString() ?? "";

//    // remove duplicate slashes
//    string fullUrl =
//        $"{baseUrl.TrimEnd('/')}/" +
//        $"{docPath.Trim('/').Replace("\\", "/")}/" +
//        $"{fileName}";

//    file["DocURL"] = fullUrl;
//}

//Console.WriteLine(obj.ToString());

//public async Task<List<string>> DownloadFilesAsync(int Id)
//{
//    try
//    {
//        //====================================== Local Path
//        /// =========== Local Path 
//        //string folder = @"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.Server\UploadNew\Images\Enquiry";

//        //=============  Cloud Path

//        string folder = "/var/www/uploads/enquiry/";
//        //string folder = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");


//        var files = Directory.GetFiles(folder, $"{Id}_*")
//                                 .Select(f => Path.GetFileName(f))
//                                 .ToList();

//        //var baseUrl = $"{Request.Scheme}://{Request.Host}/var/www/backend/UploadNew/images/enquiry/";
//        //var baseUrl = $"{Request.Scheme}://{Request.Host}/Images/Enquiry/";
//        var baseUrl = $"{Request.Scheme}://{Request.Host}/uploads/enquiry/";

//        var imageUrls = files.Select(f => baseUrl + f).ToList();
//        //var imageUrls = files.Select(f => baseUrl + Uri.EscapeDataString(f)).ToList();
//        //===============================================

//        return imageUrls;

//        // 🔹 3. Combine
//        return Ok(new
//        {
//            EnqHdr = enqById,
//            Images = imageUrls
//        });
//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}


//int len = json.ToString().Length;
//return Content(getDeptById, "application/json");
//return Ok(json);
//===============================================