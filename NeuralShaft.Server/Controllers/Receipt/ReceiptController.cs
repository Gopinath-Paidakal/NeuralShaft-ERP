using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Receipt;

namespace NeuralShaft.Server.Controllers.Receipt
{
    [ApiController]
    [Route("[controller]")]
    public class ReceiptController : Controller
    {
        private readonly IReceipt _receiptService;

        public ReceiptController(IReceipt service)
        {
            _receiptService = service;
        }

        [HttpGet("GetReceipt/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetDepartment(string fromDate, string toDate)
        {
            string getReceipt = await _receiptService.GetReceipt(fromDate, toDate);
            return Content(getReceipt, "application/json");
            //return Ok(getDept);
        }

        [HttpGet("GetReceiptById/{receiptHdrId}")]
        public async Task<ActionResult> GetReceiptById(int receiptHdrId)
        {

            var getReceiptById = await _receiptService.GetReceiptById(receiptHdrId);
            //int len = json.ToString().Length;
            return Content(getReceiptById, "application/json");
            //return Ok(json);
        }


        [HttpGet("GetSOByOrdClientId/{ordClientHdrId}")]
        public async Task<ActionResult> GetPaymentsByOrdClientId(int ordClientHdrId)
        {

            var getReceiptPayments = await _receiptService.GetSOByOrdClientId(ordClientHdrId);
            //int len = json.ToString().Length;
            return Content(getReceiptPayments, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertReceipt")]
        public async Task<IActionResult> InsertReceipt([FromBody] object receipt)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertDept = await _receiptService.InsertReceipt(receipt);
            return Ok(insertDept);

        }

        [HttpPost("UpdateReceipt/{receiptHdrId}")]
        public async Task<IActionResult> UpdateReceipt(int receiptHdrId, [FromBody] object receipt)
        {
            var updateReceipt = await _receiptService.UpdateReceipt(receiptHdrId, receipt);
            return Ok(updateReceipt);

        }
    }
}
