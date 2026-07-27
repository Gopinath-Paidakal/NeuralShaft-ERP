using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.SalesOrderItem;


namespace NeuralShaft.Server.Controllers.SalesOrderItem
{
    public class SalesOrderItemController : Controller
    {
        private readonly ISalesOrderItem _soItemService;

        public SalesOrderItemController(ISalesOrderItem soItemService)
        {
            _soItemService = soItemService;
        }


        [HttpGet("GetSalesOrderItem/{fromDate}/{toDate}/{status}")]
        public async Task<ActionResult> GetSalesOrderItem(string fromDate, string toDate, string status)
        {
            string soitem = await _soItemService.GetSalesOrderItem(fromDate, toDate, status);
            return Content(soitem, "application/json");
        }

        [HttpGet("GetSalesOrderItemHdrById/{soItemHdrId}")]
        public async Task<ActionResult> GetSalesOrderItemHdrById(int soItemHdrId)
        {
            var soItemById = await _soItemService.GetSalesOrderItemHdrById(soItemHdrId);
            return Content(soItemById, "application/json");
            //return Ok(soById);            
        }

        [HttpPost("InsertSalesOrderItemHdrDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertSalesOrderItemHdr([FromBody] object salesOrderHdrItem)
        {
            var insertSOHdrItem = await _soItemService.InsertSalesOrderItemHdrDtl(salesOrderHdrItem);
            return Ok(insertSOHdrItem);

        }

        [HttpPost("UpdateSalesOrderItemHdr/{soItemHdrId}")]    // Inserts both hdr and item in add
        public async Task<IActionResult> UpdateSalesOrderItemHdr(int soItemHdrId, [FromBody] object soHdrItem)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var updateSOHdrItem = await _soItemService.UpdateSalesOrderItemHdr(soItemHdrId, soHdrItem);
            return Ok(updateSOHdrItem);

        }

        [HttpPost("InsertSalesOrderItemDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertSalesOrderItemDtl([FromBody] object soDtlItem)
        {
            var insertSODtlItem = await _soItemService.InsertSalesOrderItemDtl(soDtlItem);
            return Ok(insertSODtlItem);
        }


        //===== Adde on 26-05-2026 // Chnaged by Pavan
        [HttpPost("UpdateSalesOrderItemDtl/{soItemDtlId}")]
        public async Task<IActionResult> UpdateSalesOrderItemDtl(int soItemDtlId, [FromBody] object soDtlItem)
        {
            var soItemUpdateDtlId = await _soItemService.UpdateSalesOrderItemDtl(soItemDtlId, soDtlItem);
            return Ok(soItemUpdateDtlId);

        }

        [HttpPost("DeleteSalesOrderItemById/{soItemDtlId}")]
        public async Task<ActionResult> DeleteSalesOrderItemById(int soItemDtlId)
        {
            var deleteSOItemById = await _soItemService.DeleteSalesOrderItemDtl(soItemDtlId);
            return Content(deleteSOItemById, "application/json");
            //return Ok(soById);            
        }
    }
}
