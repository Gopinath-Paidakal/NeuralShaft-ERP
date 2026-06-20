using Microsoft.AspNetCore.Mvc;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using static System.Runtime.InteropServices.JavaScript.JSType;
using Newtonsoft.Json;
using NeuralShaft.Service.ServiceInterfaces.Enquiry;

namespace NeuralShaft.Server.Controllers.Enquiry
{
    [ApiController]
    [Route("[controller]")]
    public class EnqFollowUpController : Controller
    {
        private readonly IEnqFollowUp _enqFollowUpService;

        public EnqFollowUpController(IEnqFollowUp service)
        {
            _enqFollowUpService = service;
        }


        [HttpGet("GetEnquiryFollowUp/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetEnquiryFollowUp(string fromDate, string toDate)
        {
            string enqFollowUp = await _enqFollowUpService.GetEnquiryFollowUp(fromDate, toDate);
            return Content(enqFollowUp, "application/json");
        }

        [HttpPost("InsertEnqFollowUp")]
        public async Task<IActionResult> InsertEnqFollowUp([FromBody] object enqFollowUp)
        {
            var insertEnqDtlId = await _enqFollowUpService.InsertEnqFollowUp(enqFollowUp);
            return Ok(insertEnqDtlId);

        }

        [HttpPost("UpdateEnqFollowUp/{EnqFollowUpIdUpdate}")]
        public async Task<IActionResult> UpdateEnqFollowUp(int EnqFollowUpIdUpdate, [FromBody] object enqFollowUp)
        {
            var insertEnqDtlId = await _enqFollowUpService.UpdateEnqFollowUp(EnqFollowUpIdUpdate, enqFollowUp);
            return Ok(insertEnqDtlId);

        }

        [HttpGet("GetEnqFollowUpById/{EnqHdrId}")]
        public async Task<ActionResult> GetEnqFollowUpById(int EnqHdrId)
        {

            var enqById = await _enqFollowUpService.GetEnquiryFollowUpById(EnqHdrId);
            //int len = json.ToString().Length;
            return Content(enqById, "application/json");
            //return Ok(json);
        }
    }
}
