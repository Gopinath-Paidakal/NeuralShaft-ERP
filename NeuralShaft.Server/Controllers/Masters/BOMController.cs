using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Masters
{
    [ApiController]
    [Route("[controller]")]
    public class BOMController : Controller
    {
        private readonly IBOM _BOMService;

        public BOMController(IBOM service)
        {
            _BOMService = service;
        }


        [HttpGet("GetBOM")]
        public async Task<ActionResult> GetBOM()
        {
            string getBOM = await _BOMService.GetBOM();
            return Content(getBOM, "application/json");
            //return Ok(getBOM);
        }

        [HttpPost("InsertBOM")]
        public async Task<IActionResult> InsertBOM([FromBody] object BOM)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertBOM = await _BOMService.InsertBOM(BOM);
            return Ok(insertBOM);

        }
    }
}
