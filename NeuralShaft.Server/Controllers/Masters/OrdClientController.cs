using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Upload;

//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using Newtonsoft.Json;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.Masters
{
    //[EnableCors("corspolicy")]
    //[EnableRateLimiting("fixedWindow")]

    [ApiController]
    [Route("[controller]")]
    public class OrdClientController : Controller
    {
        private readonly IOrdClient _OrdClientService;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/ordclient/";

        public OrdClientController(IOrdClient service, IUpload upload)
        {
            _OrdClientService = service;
            _uploadService = upload;
        }

        [HttpGet("GetOrdClient")]
        public async Task<ActionResult> GetOrdClient()
        {
            //var data = await _service.GetDepartments();
            //return Ok(data);
            string ordClient = await _OrdClientService.GetOrdClient();
            return Content(ordClient, "application/json");
        }

        [HttpGet("GetOrdClientById/{OrdClientHdrId}")]
        public async Task<ActionResult> GetOrdClientById(int OrdClientHdrId)
        {

            var ordClientById = await _OrdClientService.GetOrdClientById(OrdClientHdrId);
            //int len = json.ToString().Length;
            return Content(ordClientById, "application/json");
            //return Ok(json);
        }

        //[HttpPost("InsertOrdClientHdrDtl")]
        //public async Task<IActionResult> InsertOrdClientHdr([FromBody] object ordClientHdr)
        //{
        //    //await _service.InsertEnquiry(data);
        //    //return Ok();
        //    var insertOrdClientHdrId = await _OrdClientService.InsertOrdClientHdrDtl(ordClientHdr);


        //    return Ok(insertOrdClientHdrId);

        //}

        [HttpPost("InsertOrdClientHdrDtl/{EnqDtlId}")]
        public async Task<IActionResult> InsertOrdClientHdr([FromForm] string ordClientData, int EnqDtlId, [FromForm] List<IFormFile> attachments)  //, string InsertOrdClient)
        //public async Task<IActionResult> InsertOrdClientHdr([FromBody] object ordClientHdr)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertOrdClientHdrId = await _OrdClientService.InsertOrdClientHdrDtl(ordClientData, EnqDtlId);

            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(insertOrdClientHdrId.ToString()));
            }

            return Ok(insertOrdClientHdrId);

        }

        [HttpPost("UpdateOrdClientHdr/{OrdClientHdrId}")]
        public async Task<IActionResult> UpdateOrdClientHdr(int OrdClientHdrId, [FromBody] object ordClientHdr)
        {
            var updateOrdClientHdrId = await _OrdClientService.UpdateOrdClientHdr(OrdClientHdrId, ordClientHdr);
            return Ok(updateOrdClientHdrId);

        }

        // ------------------ Ord Client Address

        [HttpPost("InsertOrdClientAddr/{OrdClientHdrId}")]
        public async Task<IActionResult> InsertOrdClientAddr(int OrdClientHdrId, [FromForm] string ordClientAddr, [FromForm] List<IFormFile> attachments)
        {
            var insertOrdClientAddrId = await _OrdClientService.InsertOrdClientAddr(OrdClientHdrId, ordClientAddr);

            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(OrdClientHdrId.ToString()));

            return Ok(insertOrdClientAddrId);

        }

        //[HttpPost("UpdateEnqDtl")]
        [HttpPost("UpdateOrdClientAddr/{OrdClientAddrId}")]
        public async Task<IActionResult> UpdateOrdClientAddr(int OrdClientAddrId, [FromBody] object ordClientAddr)
        {
            var updateOrdClientAddrId = await _OrdClientService.UpdateOrdClientAddr(OrdClientAddrId, ordClientAddr);
            return Ok(updateOrdClientAddrId);

        }

        [HttpDelete("DeleteOrdClientAddrById/{ordClientAddrId}")]
        public async Task<IActionResult> DeleteOrdClientAddrById(int ordClientAddrId)
        {
            var deletOrdClientAddrId = await _OrdClientService.DeleteOrdClientAddr(ordClientAddrId);
            return Ok(deletOrdClientAddrId);
        }
    }
}
