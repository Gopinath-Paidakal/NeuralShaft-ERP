using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Desparch;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.MPL;

namespace NeuralShaft.Server.Controllers.MPL
{
    [ApiController]
    [Route("[controller]")]
    public class MPLController : Controller
    {
        private readonly IMPL _mplService;

        public MPLController(IMPL service)
        {
            _mplService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetMPL/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetMPL(string fromDate, string toDate)
        {
            string getMPL = await _mplService.GetMPL(fromDate, toDate);
            return Content(getMPL, "application/json");
            //return Ok(getMPL);
        }

        [HttpGet("GetMPLById/{mplHdrId}")]
        public async Task<ActionResult> GetMPLById(int mplHdrId)
        {

            var getMPLById = await _mplService.GetMPLById(mplHdrId);
            //int len = json.ToString().Length;
            return Content(getMPLById, "application/json");
            //return Ok(json);
        }


        [HttpPost("InsertMPL/{jobOrderId}")]
        public async Task<IActionResult> InsertMPL([FromBody] object mplHdr)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertMPL = await _mplService.InsertMPLHdrDtl(mplHdr);
            return Ok(insertMPL);

        }

    }
}
