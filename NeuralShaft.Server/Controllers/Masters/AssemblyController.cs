using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;

//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System.Net.Mail;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.Masters
{
    [ApiController]
    [Route("[controller]")]
    public class AssemblyController : Controller
    {
        private readonly IAssembly _assyService;

        public AssemblyController(IAssembly service)
        {
            _assyService = service;
            
        }

        [HttpGet("GetAssemblyHdr")]
        public async Task<ActionResult> GetAssy()
        {
            string getItem = await _assyService.GetAssemblyHdr();
            return Content(getItem, "application/json");
            //return Ok(getItem);
        }

        [HttpGet("GetAssemblyById/{assemblyHdrId}")]
        public async Task<ActionResult> GetAssemblyById(int assemblyHdrId)
        {
            string getItemById = await _assyService.GetAssemblyById(assemblyHdrId);
            return Content(getItemById, "application/json");
            //return Ok(getItemById);
        }

        [HttpPost("InsertAssy/{itemType}")]
        public async Task<IActionResult> InsertAssembly([FromBody] object Assy) 
        {
            var itemAssyId = await _assyService.InsertAssembly(Assy);

            //var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(itemId.ToString()));

            return Ok(itemAssyId);

        }

        [HttpPost("DeleteAssyItem/{assemblyItemId}")]
        public async Task<IActionResult> DeleteAssyItem(int assemblyItemId)
        {
            var DelItemAssyId = await _assyService.DeleteAssyItem(assemblyItemId);
            return Ok(DelItemAssyId);

        }
    }
}
