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

        [HttpGet("GetReceiptById/{receiptId}")]
        public async Task<ActionResult> GetReceiptById(int receiptId)
        {

            var getReceiptById = await _receiptService.GetReceiptById(receiptId);
            //int len = json.ToString().Length;
            return Content(getReceiptById, "application/json");
            //return Ok(json);
        }


        [HttpGet("GetPaymentsByOrdClientId/{ordClientHdrId}")]
        public async Task<ActionResult> GetPaymentsByOrdClientId(int ordClientHdrId)
        {

            var getReceiptPayments = await _receiptService.GetPaymentsByOrdClientId(ordClientHdrId);
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

        //[HttpPost("UpdateDepartment/{DeptId}")]
        //public async Task<IActionResult> UpdateDepartment(int DeptId, [FromBody] object dept)
        //{
        //    var updateDept = await _receiptService.UpdateDepartment(DeptId, dept);
        //    return Ok(updateDept);

        //}
    }
}
