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
    public class SVRController : Controller
    {
        private readonly ISVR _svrService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/svr/";

        public SVRController(ISVR service, IWebHostEnvironment env, IUpload upload)
        {
            _svrService = service;
            _env = env;
            _uploadService = upload;

        }

        [HttpGet("GetSVR")]
        public async Task<ActionResult> GetSVR(string fromDate, string toDate)
        {
            string SVR = await _svrService.GetSVR(fromDate, toDate);
            return Content(SVR, "application/json");
        }


        [HttpGet("GetSVRById/{jobOrderSVRHdrId}")]
        public async Task<ActionResult> GetSVRById(int jobOrderSVRHdrId)
        {
            string getSVRById = await _svrService.GetSVRById(jobOrderSVRHdrId);
            return Content(getSVRById, "application/json");
        }


        [HttpPost("InsertSVR/{soDtlId}")]
        public async Task<IActionResult> InsertSVR([FromForm] string SVR, [FromForm] List<IFormFile> attachments, int soDtlId)
        {

            var insertSVR = await _svrService.InsertSVR(SVR);

            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, soDtlId);
            }

            return Ok(insertSVR);
        }

        [HttpPost("UpdateJOSVRHdrDtl/{JobOrderSVRHdrId}")]
        public async Task<IActionResult> UpdateJOSVRHdr(int JobOrderSVRHdrId, [FromBody] object JobOrderSVRHdr)  ///  , [FromForm] List<IFormFile> attachments)
        {
            var svrUpdateHdrId = await _svrService.UpdateJOSVRHdrDtl(JobOrderSVRHdrId, JobOrderSVRHdr);

            //////================= Add Images in Edit  as per discussion only add
            //var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqHdrId.ToString()));
            ////// ==============================
            return Ok(svrUpdateHdrId);
        }

        //[HttpPost("UpdateJOSVRDtl/{JobOrderSVRDtlId}")]
        //public async Task<IActionResult> UpdateJOSVRDtl(int JobOrderSVRDtlId, [FromBody] object JobOrderSVRDtl)
        //{
        //    var updateEnqDtlId = await _svrService.UpdateJOSVRDtl(JobOrderSVRDtlId, JobOrderSVRDtl);
        //    return Ok(updateEnqDtlId);

        //}

        [HttpPost("ReplaceFile")]
        public async Task<IActionResult> ReplaceFile([FromForm] string replaceFile, [FromForm] List<IFormFile> attachments)
        {

            JObject obj = JObject.Parse(replaceFile);

            string oldFile = (string)obj["OldFileName"];
            int jobOrderSVRDtlId = (int)obj["JobOrderSVRDtlId"];

            ///-----------  1.Replace or update the file name in the db table
            var svrUpdateDtlId = await _svrService.ReplaceFile(jobOrderSVRDtlId, attachments[0].FileName);

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
