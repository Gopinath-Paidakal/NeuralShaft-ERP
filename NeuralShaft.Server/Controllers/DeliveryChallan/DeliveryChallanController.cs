using Microsoft.AspNetCore.Mvc;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces.DeliveryChallan;

namespace NeuralShaft.Server.Controllers.DeliveryChallan
{
    [ApiController]
    [Route("[controller]")]
    public class DeliveryChallanController : Controller
    {

        private readonly IDeliveryChallan _dcService;

        public DeliveryChallanController(IDeliveryChallan service)
        {
            _dcService = service;

        }

        [HttpGet("GetOrdClientByIdDC/{ordClientHdrId}")]
        public async Task<ActionResult> GetOrdClientByIdTaxInv(int ordClientHdrId)
        {

            var GetOrdClientByIdDC = await _dcService.GetOrdClientByIdDeliveryChallan(ordClientHdrId);
            //int len = json.ToString().Length;
            return Content(GetOrdClientByIdDC, "application/json");
            //return Ok(json);
        }

        [HttpGet("GetDeliveryChallan/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetDeliveryChallan(string fromDate, string toDate)
        {
            string getDeliveryChallan = await _dcService.GetDeliveryChallan(fromDate, toDate);
            return Content(getDeliveryChallan, "application/json");
            //return Ok(getDeliveryChallan);
        }

        [HttpGet("GetDeliveryChallandById/{dcHdrId}")]
        public async Task<ActionResult> GetDeliveryChallanEmpById(int dcHdrId)
        {

            var getDeliveryChallanById = await _dcService.GetDeliveryChallanById(dcHdrId);
            //int len = json.ToString().Length;
            return Content(getDeliveryChallanById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertDeliveryChallan")]
        public async Task<IActionResult> InsertDeliveryChallan([FromBody] object deliveryChallan)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertDeliveryChallan = await _dcService.InsertDeliveryChallan(deliveryChallan);
            return Ok(insertDeliveryChallan);
        }

        [HttpPost("UpdateDeliveryChallan/{dcHdrId}")]
        public async Task<IActionResult> UpdateDeliveryChallan(int dcHdrId, [FromBody] object deliveryChallan)
        {
            var updateDeliveryChallan = await _dcService.UpdateDeliveryChallan(dcHdrId, deliveryChallan);
            return Ok(updateDeliveryChallan);

        }
    }
}
