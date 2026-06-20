using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using Newtonsoft.Json;
using System.Diagnostics;
using System.IO;
using System.Text.Json;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using static System.Net.Mime.MediaTypeNames;
using static System.Net.WebRequestMethods;
using static System.Runtime.InteropServices.JavaScript.JSType;
using Microsoft.AspNetCore.Hosting;
using NeuralShaft.Service.ServiceInterfaces.Upload;

namespace NeuralShaft.Server.Controllers
{
    //[EnableCors("corspolicy")]
    //[EnableRateLimiting("fixedWindow")]

    [ApiController]
    [Route("[controller]")]
    public class EnquiryController : Controller
    {
        private readonly IEnquiry _enqService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        //private List<IFormFile> uploadFiles;

        //private int enqHdrId = 0;

        //private object filename;
        string savePath = "/uploads/enquiry/";

        public EnquiryController(IEnquiry service, IWebHostEnvironment env, IUpload upload)
        {
            _enqService = service;
            _env = env;
            _uploadService = upload;

        }

        [HttpGet("GetEnquiry/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetEnquiry(string fromDate, string toDate)
        {
            //string ContentRoot = _env.ContentRootPath.ToString();
            //string WebRoot = _env.WebRootPath.ToString();

            string enquiry = await _enqService.GetEnquiry(fromDate, toDate);
            return Content(enquiry, "application/json");
        }

        [HttpGet("GetEnquiryHdrById/{enqHdrId}")]
        public async Task<ActionResult> GetEnquiryById(int enqHdrId)   //, int enqDtlId)
        {
            //string savePath = "/uploads/enquiry/";

            var enqHdrById = await _enqService.GetEnquiryHdrById(enqHdrId); //,  enqDtlId);

            //-------- Download files from the server
            var downloadImages = await _uploadService.DownloadFilesAsync(savePath, enqHdrId);
            //-------- Download files from the server

            return Ok(new
            {
                EnqHdr = enqHdrById,
                Images = downloadImages
            });
            //return Content(enqById, "application/json");
        }

        [HttpGet("GetEnquiryDtlById/{enqDtlId}")]
        public async Task<ActionResult> GetEnquiryDtlById(int enqDtlId)   //, int enqDtlId)
        {
            
            var enqDtlById = await _enqService.GetEnquiryDtlById(enqDtlId); //,  enqDtlId);
                       
            return Content(enqDtlById, "application/json");
        }

        [HttpPost("InsertEnqHdrDtl")]
        public async Task<IActionResult> InsertEnqHdrDtl([FromForm] string enqHdrDtl, [FromForm] List<IFormFile> attachments)
        {
            ////Console.WriteLine(app.Environment.ContentRootPath);
            ////Console.WriteLine(app.Environment.WebRootPath);

            var enqHdrId = await _enqService.InsertEnqHdrDtl(enqHdrDtl);

            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqHdrId.ToString()));

            return Ok(enqHdrId);

        }

        //[HttpPost("UpdateEnqHdr")]
        [HttpPost("UpdateEnqHdr/{enqHdrId}")]
        public async Task<IActionResult> UpdateEnqHdr(int enqHdrId, [FromForm] string enqHdr, [FromForm] List<IFormFile> attachments)
        {
            var enqUpdateHdrId = await _enqService.UpdateEnqHdr(enqHdrId, enqHdr);

            ////================= Add Images in Edit  as per discussion only add
            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqHdrId.ToString()));
            //// ==============================
            return Ok(enqUpdateHdrId);
        }

        //[HttpPost("UpdateEnqDtl")]
        [HttpPost("InsertEnqDtl/{enqHdrId}")]
        public async Task<IActionResult> InsertEnqDtl(int enqHdrId, [FromBody] object enqDtl)
        {
            var insertEnqDtlId = await _enqService.InsertEnqDtl(enqHdrId, enqDtl);
            return Ok(insertEnqDtlId);

        }

        //[HttpPost("UpdateEnqDtl")]
        [HttpPost("UpdateEnqDtl/{enqDtlId}")]
        public async Task<IActionResult> UpdateEnqDtl(int enqDtlId, [FromBody] object enqDtl)
        {
            var updateEnqDtlId = await _enqService.UpdateEnqDtl(enqDtlId, enqDtl);
            return Ok(updateEnqDtlId);

        }

        [HttpDelete("DeleteEnqDtlById/{enqDtlId}")]
        public async Task<IActionResult> DeleteEnqDtlById(int enqDtlId)
        {
            var deleteEnqDtlId = await _enqService.DeleteEnqDtlById(enqDtlId);
            return Ok(deleteEnqDtlId);
        }

        [HttpGet("GetEnqDtlAmtById/{enqDtlId}")]
        public async Task<ActionResult> GetEnqDtlAmtById(int enqDtlId)   //, int enqDtlId)
        {

            var getEnqDtlAmtId = await _enqService.GetEnqDtlAmtById(enqDtlId); //,  enqDtlId);

            return Content(getEnqDtlAmtId, "application/json");
        }


        [HttpPost("UpdateEnqDtlAmt/{enqDtlId}")]
        public async Task<IActionResult> UpdateEnqDtlAmt(int enqDtlId, [FromBody] object enqDtl)
        {
            var updateEnqDtlAmtId = await _enqService.UpdateEnqDtlAmt(enqDtlId, enqDtl);
            return Ok(updateEnqDtlAmtId);

        }

        [HttpGet("GetEnqSourceBy/{enqSource}")]
        public async Task<ActionResult> GetEnqSourcyBy(string enqSource)
        {
            //string ContentRoot = _env.ContentRootPath.ToString();
            //string WebRoot = _env.WebRootPath.ToString();

            string enqSourceBy = await _enqService.GetEnqSourceBy(enqSource);
            return Content(enqSourceBy, "application/json");
        }


        //[HttpPost("EnqUploadImages")]       
        //public async Task<IActionResult> UploadImages([FromForm] List<IFormFile> files, int enqHdrId)
        //{
        //    if (files == null || files.Count == 0)
        //        return BadRequest("No files uploaded.");

        //    //uploadFiles = files;

        //    //var result = await _enqService.UploadImagesAsync(files, enqHdrId);

        //    var uploaded = await _uploadService.UploadFilesAsync(files, savePath, Convert.ToInt32(enqHdrId.ToString()));

        //    return Ok(new
        //    {
        //        Message = "Images uploaded successfully",
        //        Files = result
        //    });
        //}

        //[HttpGet("GetServerPath")]
        //public IActionResult GetPaths()
        //{
        //    return Ok(new
        //    {
        //        Message = _env.ContentRootPath.ToString() + "   " + _env.WebRootPath.ToString()

        //    });
        //}

    }
}


//var uploaded = await _enqService.UploadImagesAsync(attachments, Convert.ToInt32(enqHdrId.ToString()));
//var uploaded = await _enqService.UploadImagesAsync(attachments, Convert.ToInt32(enqHdrId.ToString()));

////====================================== Local Path
///// =========== Local Path 
////string folder = @"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.Server\UploadNew\Images\Enquiry";

////=============  Cloud Path
////string folder = "/var/www/backend/UploadNew/Images/Enquiry";
//string folder = "/var/www/uploads/enquiry/";
////string folder = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");


//var files = Directory.GetFiles(folder, $"{enqHdrId}_*")
//                         .Select(f => Path.GetFileName(f))
//                         .ToList();

////var baseUrl = $"{Request.Scheme}://{Request.Host}/var/www/backend/UploadNew/images/enquiry/";
////var baseUrl = $"{Request.Scheme}://{Request.Host}/Images/Enquiry/";
//var baseUrl = $"{Request.Scheme}://{Request.Host}/uploads/enquiry/";

//var imageUrls = files.Select(f => baseUrl + f).ToList();
////var imageUrls = files.Select(f => baseUrl + Uri.EscapeDataString(f)).ToList();
////===============================================



//string folder = @"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.RunTime\Debug\net10.0\Images"; // Not working
////======================================Image retrieval
/// //int len = json.ToString().Length;

//return Ok(json);

//string folder = "/var/www/images/enquiry";
//---- server path  /var/www/backend /\var\www\images\enquiry
//string folder = "D:\\NEURALSHAFT\\BackEnd\\NEURAL-SHAFT-ERP\\NeuralShaft.Server\\Images\\Enquiry";
//string folder = "http:\\196.168.1.54:5143\\Images\\Enquiry\\";


//////var files = Directory.GetFiles(folder, $"{enqHdrId}_*")
//////                     .Select(f => Path.GetFileName(f))
//////                     .ToList();

//var files = Directory.GetFiles(folder, $"{enqHdrId}_*")
//            .Select(f => new
//            {
//                FileName = Path.GetFileName(f),
//                FilePath = f
//            })
//            .ToList();

/////////var baseUrl = $"{Request.Scheme}://{Request.Host}/images/enquiry/";

//////var imageUrls = files.Select(f => baseUrl + f);

/// ===============================================Image retrieval
/// 







//public async Task<IActionResult> InsertEnqHdrDtl([FromBody] object enqHdrDtl)

//var data = await _service.GetDepartments();
//return Ok(data);

//[HttpPost("upload")]
//public async Task<IActionResult> UploadImages([FromForm] enqImgUpload)
//{
//    {
//        if (enqImgUpload.Files == null || enqImgUpload.Files.Count == 0)
//            return BadRequest("No files uploaded.");

//        var result = await _enqService.UploadImagesAsync(enqImgUpload.Files);

//        return Ok(new
//        {
//            Message = "Images uploaded successfully",
//            Files = result
//        });
//    }

//}

//[HttpGet("GetEnquiryFollowUp")]
//public async Task<ActionResult> GetEnquiryFollowUp()
//{
//    //var data = await _service.GetDepartments();
//    //return Ok(data);
//    string enqFollowUp = await _enqService.GetEnquiryFollowUp();
//    return Content(enqFollowUp, "application/json");
//}

//[HttpPost("InsertEnqFollowUp")]
//public async Task<IActionResult> InsertEnqFollowUp([FromBody] object enqFollowUp)
//{
//    var insertEnqDtlId = await _enqService.InsertEnqFollowUp(enqFollowUp);
//    return Ok(insertEnqDtlId);

//}

//[HttpPost("UpdateEnqFollowUp")]
//public async Task<IActionResult> UpdateEnqFollowUp(int EnqFollowUpIdUpdate, [FromBody] object enqFollowUp)
//{
//    var insertEnqDtlId = await _enqService.UpdateEnqFollowUp(EnqFollowUpIdUpdate, enqFollowUp);
//    return Ok(insertEnqDtlId);

//}

//[HttpGet("GetEnqFollowUpById/{EnqHdrId}")]
//public async Task<ActionResult> GetEnqFollowUpById(int EnqHdrId)
//{

//    var enqById = await _enqService.GetEnquiryFollowUpById(EnqHdrId);
//    //int len = json.ToString().Length;
//    return Content(enqById, "application/json");
//    //return Ok(json);
//}























































//[HttpGet("GetEnquiryFollowUp")]
//public async Task<ActionResult> GetEnquiryFollowUp()
//{
//    //var data = await _service.GetDepartments();
//    //return Ok(data);
//    var json = await _service.GetEnquiry();
//    return Content(json, "application/json");
//}

//[HttpGet("GetJSonDepartment")]
//public async Task<IActionResult> GetJSonDepartments()
//{
//    var json = await _service.GetJSonDepartments();
//    return Content(json, "application/json");
//}
