using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using NeuralShaft.Service.ServiceInterfaces.Vendor;

namespace NeuralShaft.Server.Controllers.Vendor
{
    [ApiController]
    [Route("[controller]")]
    public class VendorController : Controller
    {
        private readonly IVendor _vendorService;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/vendor/";

        public VendorController(IVendor service, IUpload upload)
        {
            _vendorService = service;
            _uploadService = upload;
        }

        [HttpGet("GetVendor")]
        public async Task<ActionResult> GetVendor()
        {
            //var data = await _service.GetDepartments();
            //return Ok(data);
            string getVendor = await _vendorService.GetVendor();
            return Content(getVendor, "application/json");
        }

        [HttpGet("GetVendorById/{vendorHdrId}")]
        public async Task<ActionResult> GetVendorById(int vendorHdrId)
        {

            var getVendorById = await _vendorService.GetVendorById(vendorHdrId);
            //int len = json.ToString().Length;
            return Content(getVendorById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertVendorHdrDtl")]
        public async Task<IActionResult> InsertVendorHdr([FromForm] string vendor, [FromForm] List<IFormFile> attachments)  //, string InsertOrdClient)
        {
            var insertVendorHdrId = await _vendorService.InsertVendorHdrDtl(vendor);
            if (attachments.Count > 0)
            {
                var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(insertVendorHdrId.ToString()));
            }
                       
            return Ok(insertVendorHdrId);

        }

        [HttpPost("UpdateVendorHdr/{VendorHdrId}")]
        public async Task<IActionResult> UpdateVendorHdr(int vendorHdrId, [FromBody] object vendorHdr)
        {
            var updateVendorHdrId = await _vendorService.UpdateVendorHdr(vendorHdrId, vendorHdr);
            return Ok(updateVendorHdrId);

        }

        // ------------------ Vendor Detail

        [HttpPost("InsertVendorDtl/{vendorHdrId}")]
        public async Task<IActionResult> InsertVendorDtl(int vendorHdrId, [FromForm] string vendorDtl, [FromForm] List<IFormFile> attachments)
        {
            var insertVendorDtlId = await _vendorService.InsertVendorDtl(vendorHdrId, vendorDtl);

            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(vendorHdrId.ToString()));

            return Ok(insertVendorDtlId);

        }

        //[HttpPost("UpdateEnqDtl")]
        [HttpPost("UpdateVendorDtl/{vendorDtlId}")]
        public async Task<IActionResult> UpdateVendorDtl(int vendorDtlId, [FromBody] object vendorDtl)
        {
            var updateVendorDtlId = await _vendorService.UpdateVendorDtl(vendorDtlId, vendorDtl);
            return Ok(updateVendorDtlId);

        }

        [HttpDelete("DeleteVendorDtlById/{vendorDtlId}")]
        public async Task<IActionResult> DeleteVendorDtlById(int vendorDtlId)
        {
            var deletVendorDtlId = await _vendorService.DeleteVendorDtl(vendorDtlId);
            return Ok(deletVendorDtlId);
        }
    }
}
