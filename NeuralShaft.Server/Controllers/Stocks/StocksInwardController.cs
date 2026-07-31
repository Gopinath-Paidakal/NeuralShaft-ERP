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

        [HttpPost("UpdateStocksInwardHdr/{StocksInwardHdrId}")]
        public async Task<IActionResult> UpdateStocksInward(int stocksInwardHdrId, [FromBody] object StocksInward)
        {
            var updateStocksInward = await _siService.UpdateStocksInwardHdr(stocksInwardHdrId, StocksInward);
            return Ok(updateStocksInward);

        }

        [HttpPost("InsertStocksInwardDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertStocksInwardDtl([FromBody] object siInwardDtl)
        {
            var insertQuoteDtlItem = await _siService.InsertStocksInwardDtl(siInwardDtl);
            return Ok(insertQuoteDtlItem);
        }

        [HttpPost("UpdateStocksInwardDtl/{stocksInwardDtlId}")]
        public async Task<IActionResult> UpdateStocksInwardeDtl(int stocksInwardDtlId, [FromBody] object siInwardDtl)
        {
            var quoteItemUpdateDtlId = await _siService.UpdateStocksInwardDtl(stocksInwardDtlId, siInwardDtl);
            return Ok(quoteItemUpdateDtlId);

        }

        [HttpPost("DeleteStocksInwardDtl/{stocksInwardDtlId}")]
        public async Task<ActionResult> DeleteStocksInwardDtl(int stocksInwardDtlId)
        {
            var deleteQuoteItemById = await _siService.DeleteStocksInwardDtl(stocksInwardDtlId);
            return Content(deleteQuoteItemById, "application/json");
            //return Ok(quoteById);            
        }
    }
}
