using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Upload;


//using NeuralShaft.Model;
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
    public class DefaultDataDocsController : Controller
    {
        private readonly IDefaultDataDocs _docsService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/crm/";

        public DefaultDataDocsController(IDefaultDataDocs service, IWebHostEnvironment env, IUpload upload)
        {
            _docsService = service;
            _env = env;
            _uploadService = upload;
        }

        [HttpGet("GetDefaultDataDocs/{docsType}/")]
        public async Task<ActionResult> GetDefaultData(string docsType)
        {
            string getDocs = await _docsService.GetDefaultDataDocs(docsType);
            return Content(getDocs, "application/json");
        }

    }
}
