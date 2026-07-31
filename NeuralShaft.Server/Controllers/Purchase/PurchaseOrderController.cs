using Microsoft.AspNetCore.Mvc;

using NeuralShaft.Service.ServiceInterfaces.Purchase;

namespace NeuralShaft.Server.Controllers.Purchase
{
    [ApiController]
    [Route("[controller]")]
    public class PurchaseOrderController : Controller
    {
        private readonly IPurchaseOrder _poService;

        public PurchaseOrderController(IPurchaseOrder service)
        {
            _poService = service;

        }

        //[HttpGet("GetOrdClientByIdDC/{ordClientHdrId}")]
        //public async Task<ActionResult> GetOrdClientByIdTaxInv(int ordClientHdrId)
        //{

        //    var GetOrdClientByIdDC = await _poService.GetOrdClientByIdPurchaseOrder(ordClientHdrId);
        //    //int len = json.ToString().Length;
        //    return Content(GetOrdClientByIdDC, "application/json");
        //    //return Ok(json);
        //}

        [HttpGet("GetPurchaseOrder/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetPurchaseOrder(string fromDate, string toDate)
        {
            string getPurchaseOrder = await _poService.GetPurchaseOrder(fromDate, toDate);
            return Content(getPurchaseOrder, "application/json");
            //return Ok(getPurchaseOrder);
        }

        [HttpGet("GetPurchaseOrderById/{purchaseOrderHdrId}")]
        public async Task<ActionResult> GetPurchaseOrderEmpById(int purchaseOrderHdrId)
        {

            var getPurchaseOrderById = await _poService.GetPurchaseOrderById(purchaseOrderHdrId);
            //int len = json.ToString().Length;
            return Content(getPurchaseOrderById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertPurchaseOrder")]
        public async Task<IActionResult> InsertPurchaseOrder([FromBody] object purchaseOrder)
        {
            var insertPurchaseOrder = await _poService.InsertPurchaseOrder(purchaseOrder);
            return Ok(insertPurchaseOrder);
        }

        [HttpPost("UpdatePurchaseOrder/{purchaseOrderHdrId}")]
        public async Task<IActionResult> UpdatePurchaseOrder(int purchaseOrderHdrId, [FromBody] object purchaseOrder)
        {
            var updatePurchaseOrder = await _poService.UpdatePurchaseOrderHdr(purchaseOrderHdrId, purchaseOrder);
            return Ok(updatePurchaseOrder);

        }

        [HttpPost("InsertPurchaseOrderDtl")]    // Inserts both hdr and item in add
        public async Task<IActionResult> InsertPurchaseOrderDtl([FromBody] object purchaseOrderDtl)
        {
            var insertPODtl = await _poService.InsertPurchaseOrderDtl(purchaseOrderDtl);
            return Ok(insertPODtl);
        }

        [HttpPost("UpdatePurchaseOrderDtl/{purchaseOrderDtlId}")]
        public async Task<IActionResult> UpdatePurchaseOrderDtl(int purchaseOrderDtlId, [FromBody] object purchaseOrderDtl)
        {
            var updatePODtl = await _poService.UpdatePurchaseOrderDtl(purchaseOrderDtlId, purchaseOrderDtl);
            return Ok(updatePODtl);

        }

        [HttpPost("DeletePurchaseOrderDtl/{purchaseOrderDtlId}")]
        public async Task<ActionResult> DeletePurchaseOrderDtl(int taxInvDtlId)
        {
            var deletePODtl = await _poService.DeletePurchaseOrderDtl(taxInvDtlId);
            return Content(deletePODtl, "application/json");
            //return Ok(quoteById);            
        }
    }
}
