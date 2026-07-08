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

        [HttpGet("GetJobOrderBOM/{ddProductId}/{soDtlId}")]
        public async Task<ActionResult> GetJobOrderBOM(int ddProductId, int soDtlId)
        {
            string jobOrderBOM = await _JobOrderService.GetJobOrderBOM(ddProductId, soDtlId);
            return Content(jobOrderBOM, "application/json");
        }

        [HttpPost("InsertJobOrderBOM")]
        public async Task<IActionResult> InsertJobOrderBOM([FromBody] object jobOrderBOM)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertJOBOM = await _JobOrderService.InsertJobOrderBOM(jobOrderBOM);
            return Ok(insertJOBOM);

        }
    }
}
