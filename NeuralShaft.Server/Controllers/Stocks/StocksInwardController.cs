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

        [HttpGet("GetStocksInwardById/{stocksInwardHdrId}")]
        public async Task<ActionResult> GetStocksInwardEmpById(int stocksInwardHdrId)
        {

            var getStocksInwardById = await _siService.GetStocksInwardById(stocksInwardHdrId);
            //int len = json.ToString().Length;
            return Content(getStocksInwardById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertStocksInward")]
        public async Task<IActionResult> InsertStocksInward([FromBody] object stocksInward)
        {
            var insertStocksInward = await _siService.InsertStocksInward(stocksInward);
            return Ok(insertStocksInward);
        }

        [HttpPost("UpdateStocksInwardHdr/{stocksInwardHdrId}")]
        public async Task<IActionResult> UpdateStocksInward(int stocksInwardHdrId, [FromBody] object stocksInward)
        {
            var updateStocksInward = await _siService.UpdateStocksInwardHdr(stocksInwardHdrId, stocksInward);
            return Ok(updateStocksInward);

        }

        [HttpPost("InsertStocksInwardDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertStocksInwardDtl([FromBody] object siInwardDtl)
        {
            var insertStocksInwardDtl = await _siService.InsertStocksInwardDtl(siInwardDtl);
            return Ok(insertStocksInwardDtl);
        }

        [HttpPost("UpdateStocksInwardDtl/{stocksInwardDtlId}")]
        public async Task<IActionResult> UpdateStocksInwardeDtl(int stocksInwardDtlId, [FromBody] object siInwardDtl)
        {
            var stocksInwardUpdateDtl = await _siService.UpdateStocksInwardDtl(stocksInwardDtlId, siInwardDtl);
            return Ok(stocksInwardUpdateDtl);

        }

        [HttpPost("DeleteStocksInwardDtl/{stocksInwardDtlId}")]
        public async Task<ActionResult> DeleteStocksInwardDtl(int stocksInwardDtlId)
        {
            var deleteStocksInwardDtl = await _siService.DeleteStocksInwardDtl(stocksInwardDtlId);
            return Content(deleteStocksInwardDtl, "application/json");
            //return Ok(quoteById);            
        }
    }
}
