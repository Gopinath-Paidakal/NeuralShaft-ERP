using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.SalesOrder;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.SalesOrder;
using Newtonsoft.Json;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.SalesOrder
{
    //[EnableCors("corspolicy")]
    //[EnableRateLimiting("fixedWindow")]

    [ApiController]
    [Route("[controller]")]
    public class SOController : Controller
    {
        private readonly ISalesOrder _soService;

        public SOController(ISalesOrder service)
        {
            _soService = service;
        }

        [HttpGet("GetSO/{fromDate}/{toDate}")]
        public async Task<IActionResult> GetSOHdr(string fromDate, string toDate)
        {
            var getSO = await _soService.GetSalesOrder(fromDate, toDate);
            return Content(getSO, "application/json");
            //return Ok(salesOrder);

        }

        [HttpGet("GetSOHdrById/{SOHdrId}")]
        public async Task<ActionResult> GetSOHdrById(int SOHdrId)   
        {

            var getSOHdrById = await _soService.GetSOHdrById(SOHdrId);    
            //int len = json.ToString().Length;
            return Content(getSOHdrById, "application/json");
            //return Ok(json);
        }

        [HttpGet("GetSODtlById/{soDtlId}")]
        public async Task<ActionResult> GetSODtlById(int soDtlId)   
        {

            var getSODtlById = await _soService.GetSODtlById(soDtlId); 

            return Content(getSODtlById, "application/json");
        }


        //[HttpPost("InsertSOHdr/{OrdApproveId}")]
        //public async Task<IActionResult> InsertSOHdr(int OrdApproveId)
        //{
        //    var insertSOHdrId = await _soService.InsertSOHdr(OrdApproveId);
        //    return Ok(insertSOHdrId);
        //}

        [HttpPost("InsertSOHdr")]
        public async Task<IActionResult> InsertSOHdr(object SOHdr)
        {
            var insertSOHdrId = await _soService.InsertSOHdr(SOHdr);
            return Ok(insertSOHdrId);
        }


        [HttpPost("UpdateSOHdr/{SOHdrId}")]
        public async Task<IActionResult> UpdateSOHdr(int SOHdrId, [FromBody] object SOHdr)
        {
            var SOUpdateHdrId = await _soService.UpdateSOHdr(SOHdrId, SOHdr);
            return Ok(SOUpdateHdrId);

        }

        [HttpPost("InsertSODtl/{SOHdrId}")]
        public async Task<IActionResult> InsertSODtl(int SOHdrId, [FromBody] object SODtl)
        {
            var updateSODtlId = await _soService.InsertSODtl(SOHdrId, SODtl);
            return Ok(updateSODtlId);

        }

        [HttpPost("UpdateSODtl/{SODtlId}")]
        public async Task<IActionResult> UpdateSODtl(int SODtlId, [FromBody] object SODtl)
        {
            var updateSODtlId = await _soService.UpdateSODtl(SODtlId, SODtl);
            return Ok(updateSODtlId);

        }

        [HttpDelete("DeleteSODtlById/{SODtlId}")]
        public async Task<IActionResult> DeleteSODtlById(int SODtlId)
        {
            var deleteSODtlId = await _soService.DeleteSODtlById(SODtlId);
            return Ok(deleteSODtlId);
        }

        [HttpGet("GetSODtlAmtById/{soDtlId}")]
        public async Task<ActionResult> GetSODtlAmtById(int soDtlId)  
        {

            var getSODtlAmtId = await _soService.GetSODtlAmtById(soDtlId); 

            return Content(getSODtlAmtId, "application/json");
        }


        [HttpPost("UpdateSODtlAmt/{soDtlId}")]
        public async Task<IActionResult> UpdateSODtlAmt(int soDtlId, [FromBody] object soDtl)
        {
            var updateSODtlAmtId = await _soService.UpdateSODtlAmt(soDtlId, soDtl);
            return Ok(updateSODtlAmtId);

        }
    }
}
