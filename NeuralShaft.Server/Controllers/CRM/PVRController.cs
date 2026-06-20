using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.CRM;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Upload;

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
    }
}
