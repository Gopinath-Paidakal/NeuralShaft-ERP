using Microsoft.AspNetCore.Mvc;
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
