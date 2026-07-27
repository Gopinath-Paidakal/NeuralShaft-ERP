using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.SalesOrderAMC;

namespace NeuralShaft.Server.Controllers.SalesOrderAMC
{
    public class SalesOrderAMCController : Controller
    {
        private readonly ISalesOrderAMC _soAMCService;

        public SalesOrderAMCController(ISalesOrderAMC soAmcService)
        {
            _soAMCService = soAmcService;
        }


        [HttpGet("GetSalesOrderAMC/{fromDate}/{toDate}/{status}")]
        public async Task<ActionResult> GetSOAMC(string fromDate, string toDate, string status)
        {
            string soAMC = await _soAMCService.GetSalesOrderAMC(fromDate, toDate, status);
            return Content(soAMC, "application/json");
        }

        [HttpGet("GetSalesOrderAMCHdrById/{quoteItemHdrId}")]
        public async Task<ActionResult> GetSOAMCHdrById(int soAMCdrId)
        {
            var soAMCById = await _soAMCService.GetSalesOrderAMCHdrById(soAMCdrId);
            return Content(soAMCById, "application/json");
            //return Ok(quoteById);            
        }

        [HttpPost("InsertSalesOrderAMCHdrDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertSOAMCHdr([FromBody] object salesOrderAMCHdrDtl)
        {
            var insertQuoteHdrItem = await _soAMCService.InsertSalesOrderAMCHdrDtl(salesOrderAMCHdrDtl);
            return Ok(insertQuoteHdrItem);

        }

        [HttpPost("UpdateSalesOrderAMCHdr/{quoteItemHdrId}")]    // Inserts both hdr and item in add
        public async Task<IActionResult> UpdateSOAMCHdr(int salesOrderAMCHdrId, [FromBody] object salesOrderAMCHdr)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var updateQuoteHdrItem = await _soAMCService.UpdateSalesOrderAMCHdr(salesOrderAMCHdrId, salesOrderAMCHdr);
            return Ok(updateQuoteHdrItem);

        }

        [HttpPost("InsertSalesOrderAMCDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertSOAMCDtl([FromBody] object salesOrderAMCDtl)
        {
            var insertsoAMCDtl = await _soAMCService.InsertSalesOrderAMCDtl(salesOrderAMCDtl);
            return Ok(insertsoAMCDtl);
        }


        //===== Adde on 26-05-2026 // Chnaged by Pavan
        [HttpPost("UpdateSalesOrderAMCDtl/{quoteItemDtlId}")]
        public async Task<IActionResult> UpdateSOAMCDtl(int quoteItemDtlId, [FromBody] object quoteDtlItem)
        {
            var soAMCUpdateDtlId = await _soAMCService.UpdateSalesOrderAMCDtl(quoteItemDtlId, quoteDtlItem);
            return Ok(soAMCUpdateDtlId);

        }

        [HttpPost("DeleteSalesOrderAMCDtlById/{quoteItemDtlId}")]
        public async Task<ActionResult> DeleteSOAMCById(int salesOrderAMCDtlId)
        {
            var deleteSOAMCById = await _soAMCService.DeleteSalesOrderAMCDtl(salesOrderAMCDtlId);
            return Content(deleteSOAMCById, "application/json");
            //return Ok(quoteById);            
        }
    }
}
