using Microsoft.AspNetCore.Mvc;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using Newtonsoft.Json;
//using Newtonsoft.Json;
using System.Text.Json;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.CRM
{
    [ApiController]
    [Route("[controller]")]
    public class CRMDocsController : Controller
    {
        private readonly ICRMDocs _crmDocsService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/crm/";


        public CRMDocsController(ICRMDocs service, IWebHostEnvironment env, IUpload upload)
        {
            _crmDocsService = service;
            _env = env;
            _uploadService = upload;
        }

        [HttpPost("InsertCRMDocs/{soDtlId}")]
        public async Task<IActionResult> InsertCRMDocs([FromForm] string crmDocs, [FromForm] List<IFormFile> attachments, int soDtlId)

        {
            var insertCRMDocs = await _crmDocsService.InsertCRMDocs(crmDocs);

            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, soDtlId);   
            }

            return Ok(insertCRMDocs);

            //await _service.InsertEnquiry(data);
            //return Ok();

        }
    }
}
