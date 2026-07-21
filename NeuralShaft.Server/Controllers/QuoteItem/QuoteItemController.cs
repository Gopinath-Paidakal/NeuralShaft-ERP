using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Quotation;
using NeuralShaft.Service.ServiceInterfaces.QuoteItem;

namespace NeuralShaft.Server.Controllers.QuoteItem
{
    [ApiController]
    [Route("[controller]")]
    public class QuoteItemController : Controller
    {
        private readonly IQuoteItem _quoteItemService;

        public QuoteItemController(IQuoteItem quoteService)
        {
            _quoteItemService = quoteService;
        }


        [HttpGet("GetQuoteItem/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetQuoteItem(string fromDate, string toDate)
        {
            string quoteitem = await _quoteItemService.GetQuoteItem(fromDate, toDate);
            return Content(quoteitem, "application/json");
        }

        [HttpGet("GetQuoteItemHdrById/{quoteItemHdrId}")]
        public async Task<ActionResult> GetQuoteItemHdrById(int quoteItemHdrId)
        {
            var quoteItemById = await _quoteItemService.GetQuoteItemHdrById(quoteItemHdrId);
            return Content(quoteItemById, "application/json");
            //return Ok(quoteById);            
        }

        [HttpPost("InsertQuoteItemHdr")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertQuoteItemHdr([FromBody] object QuoteHdrItem)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertQuoteHdrItem = await _quoteItemService.InsertQuoteItemHdr(QuoteHdrItem);
            return Ok(insertQuoteHdrItem);

        }

        [HttpPost("UpdateQuoteItemHdr/{quoteItemHdrId}")]    // Inserts both hdr and item in add
        public async Task<IActionResult> UpdateQuoteItemHdr(int quoteItemHdrId, [FromBody] object quoteHdrItem)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var updateQuoteHdrItem = await _quoteItemService.UpdateQuoteItemHdr(quoteItemHdrId, quoteHdrItem);
            return Ok(updateQuoteHdrItem);

        }

        [HttpPost("InsertQuoteItemDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertQuoteItemDtl([FromBody] object quoteDtlItem)
        {
            var insertQuoteDtlItem = await _quoteItemService.InsertQuoteItemDtl(quoteDtlItem);
            return Ok(insertQuoteDtlItem);
        }


        //===== Adde on 26-05-2026 // Chnaged by Pavan
        [HttpPost("UpdateQuoteItemDtl/{quoteItemDtlId}")]
        public async Task<IActionResult> UpdateQuoteItemDtl(int quoteItemDtlId, [FromBody] object quoteDtlItem)
        {
            var quoteItemUpdateDtlId = await _quoteItemService.UpdateQuoteItemDtl(quoteItemDtlId, quoteDtlItem);
            return Ok(quoteItemUpdateDtlId);

        }

        [HttpPost("DeleteQuoteItemById/{quoteItemDtlId}")]
        public async Task<ActionResult> DeleteQuoteItemById(int quoteItemDtlId)
        {
            var deleteQuoteItemById = await _quoteItemService.DeleteQuoteItemDtl(quoteItemDtlId);
            return Content(deleteQuoteItemById, "application/json");
            //return Ok(quoteById);            
        }

    }
}
