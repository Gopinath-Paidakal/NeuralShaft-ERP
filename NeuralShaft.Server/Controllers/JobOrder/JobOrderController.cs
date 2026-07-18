using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Quotation;
using NeuralShaft.Service.ServiceInterfaces.JobOrder;
using NeuralShaft.Service.ServiceInterfaces.Quotation;

namespace NeuralShaft.Server.Controllers.JobOrder
{
    [ApiController]
    [Route("[controller]")]
    public class JobOrderController : Controller
    {
        private readonly IJobOrder _JobOrderService;

        public JobOrderController(IJobOrder jobOrderService)
        {
            _JobOrderService = jobOrderService;
        }

        [HttpGet("GetJobOrder/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetJobOrder(string fromDate, string toDate)
        {
            string jobOrderList = await _JobOrderService.GetJobOrder(fromDate, toDate);
            return Content(jobOrderList, "application/json");
        }

        [HttpGet("GetJobOrderByOrdClientHdrId/{ordClientHdrId}")]
        public async Task<ActionResult> GetJobOrderByOrdClientHdrId(int ordClientHdrId)
        {
            string jobOrderNosList = await _JobOrderService.GetJobOrderByOrdClientHdrId(ordClientHdrId);
            return Content(jobOrderNosList, "application/json");
        }

        [HttpGet("GetJobOrderBOM/{ddProductId}/{soDtlId}")]
        public async Task<ActionResult> GetJobOrderBOM(int ddProductId, int soDtlId)
        {
            string jobOrderBOM = await _JobOrderService.GetJobOrderBOM(ddProductId, soDtlId);
            return Content(jobOrderBOM, "application/json");
        }

        [HttpGet("GetJobOrderBOMUpdate/{soDtlId}")]
        public async Task<ActionResult> GetJobOrderBOMUpdate(int soDtlId)
        {
            string jobOrderBOMUpdate = await _JobOrderService.GetJobOrderBOMUpdate(soDtlId);
            return Content(jobOrderBOMUpdate, "application/json");
        }

        [HttpPost("InsertJobOrderBOM")]
        public async Task<IActionResult> InsertJobOrderBOM([FromBody] object jobOrderBOM)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertJOBOM = await _JobOrderService.InsertJobOrderBOM(jobOrderBOM);
            return Ok(insertJOBOM);

        }

        [HttpPost("InsertJOBOMItem")]
        public async Task<IActionResult> InsertJOBOMItem([FromBody] object jobOrderBOM)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertJOBOMItem = await _JobOrderService.InsertJOBOMItem(jobOrderBOM);
            return Ok(insertJOBOMItem);

        }

        [HttpPost("UpdateJOBOMItem/{JobOrderBOMId}/{qty}")]
        public async Task<IActionResult> UpdateJOBOMItem(int JobOrderBOMId, int qty)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var updateJOBOMItem = await _JobOrderService.UpdateJOBOMItem(JobOrderBOMId, qty);
            return Ok(updateJOBOMItem);

        }

        [HttpPost("DeleteJOBOMItem/{JobOrderBOMId}")]
        public async Task<IActionResult> DeleteJOBOMItem(int JobOrderBOMId)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var deleteJOBOMItem = await _JobOrderService.DeleteJOBOMItem(JobOrderBOMId);
            return Ok(deleteJOBOMItem);

        }
    }
}
