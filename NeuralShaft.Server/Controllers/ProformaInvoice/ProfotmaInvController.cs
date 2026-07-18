using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Upload;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.ProformaInvoice;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using Newtonsoft.Json;
using System.Diagnostics;
using System.IO;
using System.Text.Json;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using static System.Net.Mime.MediaTypeNames;
using static System.Net.WebRequestMethods;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.ProformaInvoice
{
    [ApiController]
    [Route("[controller]")]
    public class ProfotmaInvController : Controller
    {
        private readonly IProformaInv _proInvService;
        public ProfotmaInvController(IProformaInv service)
        {
            _proInvService = service;

        }

        [HttpGet("GetOrdClientByIdProInv/{ordClientHdrId}")]
        public async Task<ActionResult> GetOrdClientByIdProInv(int ordClientHdrId)  //, string proformaType)
        {

            var GetOrdClientByIdProInv = await _proInvService.GetOrdClientByIdProInv(ordClientHdrId);  // , proformaType);
            //int len = json.ToString().Length;
            return Content(GetOrdClientByIdProInv, "application/json");
            //return Ok(json);
        }

        [HttpGet("GetOrdClientByProformaType/{ordClientHdrId}/{proformaType}")]
        public async Task<ActionResult> GetOrdClientByProformaType(int ordClientHdrId, string proformaType)
        {

            var GetOrdClientByIdProInvType = await _proInvService.GetOrdClientByProformaType(ordClientHdrId, proformaType);
            //int len = json.ToString().Length;
            return Content(GetOrdClientByIdProInvType, "application/json");
            //return Ok(json);
        }

        [HttpGet("GetOrdClientByIdSoDtl/{SOHdrId}")]
        public async Task<ActionResult> GetOrdClientByIdSoDtl(int SOHdrId)
        {

            var GetOrdClientByIdSODtl = await _proInvService.GetOrdClientByIdSODtl(SOHdrId);
            //int len = json.ToString().Length;
            return Content(GetOrdClientByIdSODtl, "application/json");
            //return Ok(json);
        }

        [HttpGet("GetOrdClientQuoteItem/{itemQuoteHdrId}")]
        public async Task<ActionResult> GetOrdClientQuoteItem(int itemQuoteHdrId)
        {

            var GetOrdClientQuoteItem = await _proInvService.GetOrdClientQuoteItem(itemQuoteHdrId);
            //int len = json.ToString().Length;
            return Content(GetOrdClientQuoteItem, "application/json");
            //return Ok(json);
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetProformaInv/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetProformaInv(string fromDate, string toDate)
        {
            string enquiry = await _proInvService.GetProformaInv(fromDate, toDate);
            return Content(enquiry, "application/json");
        }

        [HttpGet("GetProformaInvdById/{proformaInvId}")]
        public async Task<ActionResult> GetProformaInvEmpById(int proformaInvId)
        {
            var getProformaInvById = await _proInvService.GetProformaInvById(proformaInvId);
            //int len = json.ToString().Length;
            return Content(getProformaInvById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertProformaInv")]
        public async Task<IActionResult> InsertProformaInv([FromBody] object ProformaInv)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertProformaInv = await _proInvService.InsertProformaInv(ProformaInv);
            return Ok(insertProformaInv);
        }

        [HttpPost("UpdateProformaInv/{proformaInvId}")]
        public async Task<IActionResult> UpdateProformaInv(int proformaInvId, [FromBody] object proformaInv)
        {
            var updateProformaInv = await _proInvService.UpdateProformaInv(proformaInvId, proformaInv);
            return Ok(updateProformaInv);

        }
    }
}
