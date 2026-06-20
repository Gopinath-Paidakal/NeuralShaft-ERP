using Microsoft.AspNetCore.Mvc;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.OrderApprove;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System.Net.Mail;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.OrderApprove
{
    //[EnableCors("corspolicy")]
    //[EnableRateLimiting("fixedWindow")]

    [ApiController]
    [Route("[controller]")]

    public class OrdApproveController : Controller
    {
        private readonly IOrdApprove _service;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/ordclient/";

        public OrdApproveController(IOrdApprove service, IUpload upload)
        {
            _service = service;
            _uploadService = upload;
        }

        //[HttpGet("GetOrdApprove/{fromDate}/{toDate}")]
        //public async Task<ActionResult> GetOrdApprove(string fromDate, string toDate)
        //{
        //    string ordApproveDateData = await _service.GetOrdApprove(fromDate, toDate);
        //    //return Content(clientData, "application/json");
        //    return Ok(ordApproveDateData);
        //}

        [HttpGet("GetOrdApprove")]
        public async Task<ActionResult> GetOrdApprove()
        {
            string ordApproveDateData = await _service.GetOrdApprove();
            return Content(ordApproveDateData, "application/json");
            //return Ok(ordApproveDateData);
        }

        [HttpGet("GetOrdReject/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetOrdReject(string fromDate, string toDate)
        {
            string ordReject = await _service.GetOrdReject(fromDate, toDate);
            //return Content(clientData, "application/json");
            return Ok(ordReject);
        }

        [HttpPost("InsertOrdApprove")]
        public async Task<IActionResult> InsertOrdApprove([FromForm] string OrdApprove, [FromForm] List<IFormFile> attachments)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var enqHdrId = await _service.InsertOrdApprove(OrdApprove);

            // For Purchase Order Upload
            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(enqHdrId.ToString()));

            return Ok(enqHdrId);

        }

        [HttpPost("UpdateOrdRej/{enqDtlId}/{OrdRejected}")]
        public async Task<IActionResult> UpdateOrdRej(int enqDtlId, string OrdRejected)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var ordRejected = await _service.UpdateOrdRej(enqDtlId, OrdRejected);

            return Ok(ordRejected);

        }
    }
}
