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

        [HttpGet("GetBOMMstByProdId/{productId}")]
        public async Task<ActionResult> GetBOMMstByProdId(int productId)
        {
            string getItemById = await _BOMService.GetBOMByProdId(productId);
            return Content(getItemById, "application/json");
            //return Ok(getItemById);
        }

        [HttpPost("InsertBOMMst")]
        public async Task<IActionResult> InsertBOM([FromBody] object BOM)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertBOM = await _BOMService.InsertBOMMst(BOM);
            return Ok(insertBOM);

        }

        [HttpPost("DeleteBOMMst/{BOMMstId}")]
        public async Task<IActionResult> DeleteBOMMst(int BOMMstId)
        {
            var DelItemAssyId = await _BOMService.DeleteBOMById(BOMMstId);
            return Ok(DelItemAssyId);

        }
    }
}
