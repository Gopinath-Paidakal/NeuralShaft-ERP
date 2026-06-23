using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.CRM;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using Newtonsoft.Json.Linq;

namespace NeuralShaft.Server.Controllers.CRM
{
    [ApiController]
    [Route("[controller]")]
    public class PVRController : Controller
    {
        private readonly IPVR _pvrService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/pvr/";

        public PVRController(IPVR service, IWebHostEnvironment env, IUpload upload)
        {
            _pvrService = service;
            _env = env;
            _uploadService = upload;

        }

        [HttpGet("GetPVR/{soDtlId}")]
        public async Task<ActionResult> GetPVR(int soDtlId)
        {
            string getPVR = await _pvrService.GetPVR(soDtlId);    
            return Content(getPVR, "application/json");
        }


        [HttpPost("InsertPVR/{soDtlId}")]
        public async Task<IActionResult> InsertPVR([FromForm] string PVR, [FromForm] List<IFormFile> attachments, int soDtlId)
        {
            var insertPVR = await _pvrService.InsertPVR(PVR);

            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, soDtlId);
            }

            return Ok(insertPVR);
        }

        [HttpPost("UpdateJOPVRDtl/{JobOrderPVRId}")]
        public async Task<IActionResult> UpdateJOPVR(int JobOrderPVRId, [FromBody] object JobOrderPVR)  
        {
            var pvrUpdateHdrId = await _pvrService.UpdateJOPVRHdrDtl(JobOrderPVRId, JobOrderPVR);

            //////================= Add Images in Edit  as per discussion only add
            //var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqHdrId.ToString()));
            ////// ==============================
            return Ok(pvrUpdateHdrId);
        }

        [HttpPost("ReplaceFile")]
        public async Task<IActionResult> UpdateJOPVR([FromForm] string replaceFile, [FromForm] List<IFormFile> attachments)
        {

            JObject obj = JObject.Parse(replaceFile);

            string oldFile = (string)obj["OldFileName"];
            int jobOrderPVRId = (int)obj["JobOrderPVRId"];

            ///-----------  1.Replace or update the file name in the db table
            var svrUpdateDtlId = await _pvrService.ReplaceFile(jobOrderPVRId, attachments[0].FileName);

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
