using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Upload;
//using NeuralShaft.Model;
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
using NeuralShaft.Service.ServiceInterfaces.TaxInvoice;

namespace NeuralShaft.Server.Controllers.TaxInvoice
{
    [ApiController]
    [Route("[controller]")]
    public class TaxInvController : Controller
    {
        private readonly ITaxInv _taxInvService;

        public TaxInvController(ITaxInv service)
        {
            _taxInvService = service;

        }

        [HttpGet("GetTaxInv")]
        public async Task<ActionResult> GetTaxInv()
        {
            string getTaxInv = await _taxInvService.GetTaxInv();
            return Content(getTaxInv, "application/json");
            //return Ok(getTaxInv);
        }

        [HttpGet("GetTaxInvdById/{taxInvId}")]
        public async Task<ActionResult> GetTaxInvEmpById(int taxInvId)
        {

            var getTaxInvById = await _taxInvService.GetTaxInvById(taxInvId);
            //int len = json.ToString().Length;
            return Content(getTaxInvById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertTaxInv")]
        public async Task<IActionResult> InsertTaxInv([FromBody] object taxInv)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertTaxInv = await _taxInvService.InsertTaxInv(taxInv);
            return Ok(insertTaxInv);
        }

        [HttpPost("UpdateTaxInv/{taxInvId}")]
        public async Task<IActionResult> UpdateTaxInv(int taxInvId, [FromBody] object taxInv)
        {
            var updateTaxInv = await _taxInvService.UpdateTaxInv(taxInvId, taxInv);
            return Ok(updateTaxInv);

        }
    }
}
