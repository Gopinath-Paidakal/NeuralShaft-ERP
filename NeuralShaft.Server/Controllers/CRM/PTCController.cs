using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
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
    public class PTCController : Controller
    {
        private readonly IPTC _ptcService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/ptc/";

        public PTCController(IPTC service, IWebHostEnvironment env, IUpload upload)
        {
            _ptcService = service;
            _env = env;
            _uploadService = upload;

        }

        //[HttpGet("GetPTC")]
        //public async Task<ActionResult> GetPTC(string fromDate, string toDate)
        //{
        //    string PTC = await _ptcService.GetPTC(fromDate, toDate);
        //    return Content(PTC, "application/json");
        //}


        [HttpGet("GetPTCById/{JobOrderPTCDtlId}")]
        public async Task<ActionResult> GetPTCById(int JobOrderPTCDtlId)
        {
            string getPTCById = await _ptcService.GetPTCById(JobOrderPTCDtlId);
            return Content(getPTCById, "application/json");
        }


        [HttpPost("InsertJobOrderPTCDtl")]
        public async Task<IActionResult> InsertPTC([FromBody] object jobOrderPTCDtl)     //, [FromForm] List<IFormFile> attachments, int jobOrderPTCDtlId)
        {

            var insertJobOrderPTCDtl = await _ptcService.InsertJobOrderPTCDtl(jobOrderPTCDtl);

            //if (attachments.Count > 0)
            //{
            //    var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, jobOrderPTCDtlId);
            //}

            return Ok(insertJobOrderPTCDtl);
        }

        [HttpPost("UpdateJobOrderPTCDtl/{jobOrderPTCDtlId}")]
        public async Task<IActionResult> UpdateJOPTCDtlDtl(int jobOrderPTCDtlId, [FromBody] object jobOrderPTCDtl)  ///  , [FromForm] List<IFormFile> attachments)
        {
            var PTCUpdateDtlId = await _ptcService.UpdateJobOrderPTCDtl(jobOrderPTCDtlId, jobOrderPTCDtl);

            //////================= Add Images in Edit  as per discussion only add
            //var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqDtlId.ToString()));
            ////// ==============================
            return Ok(PTCUpdateDtlId);
        }

        //[HttpPost("UpdateJOPTCDtl/{JobOrderPTCDtlId}")]
        //public async Task<IActionResult> UpdateJOPTCDtl(int JobOrderPTCDtlId, [FromBody] object JobOrderPTCDtl)
        //{
        //    var updateEnqDtlId = await _PTCService.UpdateJOPTCDtl(JobOrderPTCDtlId, JobOrderPTCDtl);
        //    return Ok(updateEnqDtlId);

        //}

        //[HttpPost("ReplaceFile")]
        //public async Task<IActionResult> ReplaceFile([FromForm] string replaceFile, [FromForm] List<IFormFile> attachments)
        //{

        //    JObject obj = JObject.Parse(replaceFile);

        //    string oldFile = (string)obj["OldFileName"];
        //    int jobOrderPTCDtlId = (int)obj["JobOrderPTCDtlId"];

        //    ///-----------  1.Replace or update the file name in the db table
        //    var PTCUpdateDtlId = await _ptcService.ReplaceFile(jobOrderPTCDtlId, attachments[0].FileName);

        //    ///-----------  2. Upload New File
        //    var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, 0);

        //    /// ---------- 3. Delete the Old File
        //    bool result = await _uploadService.DeleteFileAsync(savePath, oldFile);

        //    if (!result)
        //        return NotFound("File not found.");

        //    return Ok("File replaced successfully.");
        //}

    }
}
