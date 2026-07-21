using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.QuotationAMC;

namespace NeuralShaft.Server.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class QuoteAMCController : Controller
    {
        private readonly IQuoteAMC _quoteAMCService;

        public QuoteAMCController(IQuoteAMC quoteService)
        {
            _quoteAMCService = quoteService;
        }

        [HttpGet("GetQuoteAMC/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetQuoteAMC(string fromDate, string toDate)
        {
            string quoteAMC = await _quoteAMCService.GetQuoteAMC(fromDate, toDate);
            return Content(quoteAMC, "application/json");
        }

        [HttpGet("GetQuoteAMCHdrById/{quoteAMCHdrId}")]
        public async Task<ActionResult> GetQuoteAMCHdrById(int quoteAMCHdrId)
        {
            var quoteAMCById = await _quoteAMCService.GetQuoteAMCHdrById(quoteAMCHdrId);
            return Content(quoteAMCById, "application/json");
            //return Ok(quoteById);            
        }

        [HttpPost("InsertQuoteAMCHdr")]    // Inserts both hdr and AMC in add
        public async Task<IActionResult> InsertQuoteAMCHdr([FromBody] object QuoteHdrAMC)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertQuoteHdrAMC = await _quoteAMCService.InsertQuoteAMCHdr(QuoteHdrAMC);
            return Ok(insertQuoteHdrAMC);

        }

        [HttpPost("UpdateQuoteAMCHdr/{quoteAMCHdrId}")]    // Inserts both hdr and AMC in add
        public async Task<IActionResult> UpdateQuoteAMCHdr(int quoteAMCHdrId, [FromBody] object quoteHdrAMC)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var updateQuoteHdrAMC = await _quoteAMCService.UpdateQuoteAMCHdr(quoteAMCHdrId, quoteHdrAMC);
            return Ok(updateQuoteHdrAMC);

        }

        //   ------------  QuoteAMC Dtl

        [HttpPost("InsertQuoteAMCDtl")]    // Inserts both hdr and AMC in add
        public async Task<IActionResult> InsertQuoteAMCDtl([FromBody] object quoteDtlAMC)
        {
            var insertQuoteDtlAMC = await _quoteAMCService.InsertQuoteAMCDtl(quoteDtlAMC);
            return Ok(insertQuoteDtlAMC);
        }


        //===== Adde on 26-05-2026 // Chnaged by Pavan
        [HttpPost("UpdateQuoteAMCDtl/{quoteAMCHdrId}")]
        public async Task<IActionResult> UpdateQuoteAMCDtl(int quoteAMCHdrId, [FromBody] object quoteAMCHdrDtl)
        {
            var quoteAMCUpdateDtlId = await _quoteAMCService.UpdateQuoteAMCDtl(quoteAMCHdrId, quoteAMCHdrDtl);
            return Ok(quoteAMCUpdateDtlId);

        }

        [HttpGet("DeleteQuoteAMCById/{quoteAMCDtlId}")]
        public async Task<ActionResult> DeleteQuoteAMCById(int quoteAMCDtlId)
        {
            var deleteQuoteAMCById = await _quoteAMCService.DeleteQuoteAMCDtl(quoteAMCDtlId);
            return Content(deleteQuoteAMCById, "application/json");
            //return Ok(quoteById);            
        }

    }
}
