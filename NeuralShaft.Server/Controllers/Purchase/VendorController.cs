using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Vendor;

namespace NeuralShaft.Server.Controllers.Vendor
{
    [ApiController]
    [Route("[controller]")]
    public class VendorController : Controller
    {
        private readonly IVendor _vendorService;

        public VendorController(IVendor service)
        {
            _vendorService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetVendor")]
        public async Task<ActionResult> GetVendor()
        {
            string getVendor = await _vendorService.GetVendor();
            return Content(getVendor, "application/json");
            //return Ok(getDept);
        }

        [HttpGet("GetDeptdById/{vendorHdrId}")]
        public async Task<ActionResult> GetVendorById(int vendorHdrId)
        {

            var getVendorById = await _vendorService.GetVendorById(vendorHdrId);
            //int len = json.ToString().Length;
            return Content(getVendorById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertVendor")]
        public async Task<IActionResult> InsertVendor([FromBody] object vendor)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertVendor = await _vendorService.InsertVendor(vendor);
            return Ok(insertVendor);

        }

        [HttpPost("UpdateVendor/{vendorHdrId}")]
        public async Task<IActionResult> UpdateVendor(int vendorHdrId, [FromBody] object vendor)
        {
            var updateDept = await _vendorService.UpdateVendor(vendorHdrId, vendor);
            return Ok(updateDept);

        }
    }
}
