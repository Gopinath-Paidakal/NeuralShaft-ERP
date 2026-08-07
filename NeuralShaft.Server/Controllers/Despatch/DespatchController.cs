using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Despatch;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Despatch
{
    [ApiController]
    [Route("[controller]")]
    public class DespatchController : Controller
    {

        private readonly IDespatch _despatchService;

        public DespatchController(IDespatch service)
        {
            _despatchService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetDespatch/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetDespatch(string fromDate, string toDate)
        {
            string getDespatch = await _despatchService.GetDespatch(fromDate, toDate);
            return Content(getDespatch, "application/json");
            //return Ok(getDespatch);
        }

        [HttpGet("GetDespatchdById/{despatchId}")]
        public async Task<ActionResult> GetDespatchById(int despatchId)
        {

            var getDespatchById = await _despatchService.GetDespatchById(despatchId);
            //int len = json.ToString().Length;
            return Content(getDespatchById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertDespatch")]
        public async Task<IActionResult> InsertDespatch([FromBody] object despatch)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertDespatch = await _despatchService.InsertDespatch(despatch);
            return Ok(insertDespatch);

        }

        [HttpPost("UpdateDespatch/{despatchId}")]
        public async Task<IActionResult> UpdateDespatch(int despatchId, [FromBody] object despatch)
        {
            var updateDespatch = await _despatchService.UpdateDespatch(despatchId, despatch);
            return Ok(updateDespatch);

        }
    }
}
