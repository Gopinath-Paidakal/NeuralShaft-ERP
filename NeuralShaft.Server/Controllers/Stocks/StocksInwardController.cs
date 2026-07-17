using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Purchase;
using NeuralShaft.Service.ServiceInterfaces.Stocks;

namespace NeuralShaft.Server.Controllers.Stocks
{
    [ApiController]
    [Route("[controller]")]
    public class StocksInwardController : Controller
    {
        private readonly IStocksInward _siService;

        public StocksInwardController(IStocksInward service)
        {
            _siService = service;

        }

        [HttpGet("GetStocksInward/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetStocksInward(string fromDate, string toDate)
        {
            string getStocksInward = await _siService.GetStocksInward(fromDate, toDate);
            return Content(getStocksInward, "application/json");
            //return Ok(getStocksInward);
        }

        [HttpGet("GetStocksInwardById/{StocksInwardHdrId}")]
        public async Task<ActionResult> GetStocksInwardEmpById(int StocksInwardHdrId)
        {

            var getStocksInwardById = await _siService.GetStocksInwardById(StocksInwardHdrId);
            //int len = json.ToString().Length;
            return Content(getStocksInwardById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertStocksInward")]
        public async Task<IActionResult> InsertStocksInward([FromBody] object StocksInward)
        {
            var insertStocksInward = await _siService.InsertStocksInward(StocksInward);
            return Ok(insertStocksInward);
        }

        [HttpPost("UpdateStocksInward/{StocksInwardHdrId}")]
        public async Task<IActionResult> UpdateStocksInward(int dcHdrId, [FromBody] object StocksInward)
        {
            var updateStocksInward = await _siService.UpdateStocksInward(dcHdrId, StocksInward);
            return Ok(updateStocksInward);

        }
    }
}
