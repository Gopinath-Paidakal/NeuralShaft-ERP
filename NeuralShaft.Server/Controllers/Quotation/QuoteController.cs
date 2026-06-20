using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Previlege;

using NeuralShaft.Service.ServiceImplementation.Upload;

//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Quotation;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.Quotation
{
    [ApiController]
    [Route("[controller]")]
    public class QuoteController : Controller
    {
        private readonly IQuoteService _QuoteService;

        public QuoteController(IQuoteService quoteService)
        {
            _QuoteService = quoteService;
        }

        [HttpGet("GetQuote/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetQuote(string fromDate, string toDate)
        {
            string quote = await _QuoteService.GetQuote(fromDate, toDate);
            return Content(quote, "application/json");
        }

        [HttpGet("GetQuoteDtlById/{quoteHdrId}")]
        public async Task<ActionResult> GetQuoteDtlById(int quoteHdrId)
        {
            var quoteById = await _QuoteService.GetQuoteDtlById(quoteHdrId);
            return Content(quoteById, "application/json");
            //return Ok(quoteById);            
        }

        [HttpPost("InsertQuoteHdr/{enqHdrId}")]
        public async Task<IActionResult> InsertQuote(int  enqHdrId)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var id = await _QuoteService.InsertQuoteHdr(enqHdrId);
            return Ok(id);

        }

        [HttpPost("UpdateQuoteHdr/{quoteHdrId}")]
        public async Task<IActionResult> UpdateQuoteHdr(int quoteHdrId, [FromBody] object quoteHdr)
        {
            var quoteUpdateHdrId = await _QuoteService.UpdateQuoteHdr(quoteHdrId, quoteHdr);
            return Ok(quoteUpdateHdrId);

        }

        //===== Adde on 26-05-2026
        [HttpPost("UpdateQuoteDtl/{quoteDtlId}")]
        public async Task<IActionResult> UpdateQuoteDtl(int quoteDtlId, [FromBody] object quoteDtl)
        {
            var quoteUpdateDtlId = await _QuoteService.UpdateQuoteHdr(quoteDtlId, quoteDtl);
            return Ok(quoteUpdateDtlId);

        }
    }
}
