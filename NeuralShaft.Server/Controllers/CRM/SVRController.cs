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

        [HttpGet("GetSVR/{soDtlId}")]
        public async Task<ActionResult> GetSVR(int soDtlId)
        {
            string enquiry = await _svrService.GetSVR(soDtlId);   
            return Content(enquiry, "application/json");
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
    }
}
