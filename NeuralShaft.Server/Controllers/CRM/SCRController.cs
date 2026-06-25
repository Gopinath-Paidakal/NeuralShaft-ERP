using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.CRM;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System.Net.Mail;
using Newtonsoft.Json.Linq;

namespace NeuralShaft.Server.Controllers.CRM
{
    [ApiController]
    [Route("[controller]")]
    public class SCRController : Controller
    {
        private readonly ISCR _scrService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/scr/";

        public SCRController(ISCR service, IWebHostEnvironment env, IUpload upload)
        {
            _scrService = service;
            _env = env;
            _uploadService = upload;

        }

        //[HttpGet("GetSCR")]
        //public async Task<ActionResult> GetSCR(string fromDate, string toDate)
        //{
        //    string SCR = await _scrService.GetSCR(fromDate, toDate);
        //    return Content(SCR, "application/json");
        //}


        [HttpGet("GetJobOrderSCRHdrById/{JobOrderSCRHdrId}")]
        public async Task<ActionResult> GetSCRById(int JobOrderSCRHdrId)
        {
            string getSCRById = await _scrService.GetSCRById(JobOrderSCRHdrId);
            return Content(getSCRById, "application/json");
        }


        [HttpPost("InsertJobOrderSCRHdr/{jobOrderSCRHdrId}")]
        public async Task<IActionResult> InsertJobOrderSCRHdr([FromForm] string jobOrderSCRHdr, [FromForm] List<IFormFile> attachments, int JobOrderSCRDtlId)
        {

            var insertSCR = await _scrService.InsertJobOrderSCRHdr(jobOrderSCRHdr);

            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, JobOrderSCRDtlId);
            }

            return Ok(insertSCR);
        }

        [HttpPost("UpdateJobOrderSCRHdr/{jobOrderSCRHdrId}")]
        public async Task<IActionResult> UpdateJobOrderSCRHdr(int jobOrderSCRHdrId, [FromBody] object JobOrderSCRHdr)  ///  , [FromForm] List<IFormFile> attachments)
        {
            var SCRUpdateHdrId = await _scrService.UpdateJobOrderSCRHdr(jobOrderSCRHdrId, JobOrderSCRHdr);

            //////================= Add Images in Edit  as per discussion only add
            //var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqHdrId.ToString()));
            ////// ==============================
            return Ok(SCRUpdateHdrId);
        }

        [HttpPost("ReplaceFile")]
        public async Task<IActionResult> ReplaceFile([FromForm] string replaceFile, [FromForm] List<IFormFile> attachments)
        {

            JObject obj = JObject.Parse(replaceFile);

            string oldFile = (string)obj["OldFileName"];
            int jobOrderSCRDtlId = (int)obj["JobOrderSCRHdrId"];

            ///-----------  1.Replace or update the file name in the db table
            var SCRUpdateDtlId = await _scrService.ReplaceFile(jobOrderSCRDtlId, attachments[0].FileName);

            ///-----------  2. Upload New File
            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, 0);

            /// ---------- 3. Delete the Old File
            bool result = await _uploadService.DeleteFileAsync(savePath, oldFile);

            if (!result)
                return NotFound("File not found.");

            return Ok("File replaced successfully.");
        }
    }
}

//[HttpPost("UpdateJOSCRDtl/{JobOrderSCRDtlId}")]
//public async Task<IActionResult> UpdateJOSCRDtl(int JobOrderSCRDtlId, [FromBody] object JobOrderSCRDtl)
//{
//    var updateEnqDtlId = await _SCRService.UpdateJOSCRDtl(JobOrderSCRDtlId, JobOrderSCRDtl);
//    return Ok(updateEnqDtlId);

//}