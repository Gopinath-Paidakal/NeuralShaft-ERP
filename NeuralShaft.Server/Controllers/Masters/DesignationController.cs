using NeuralShaft.Service.ServiceInterfaces.Masters;
using Microsoft.AspNetCore.Mvc;

namespace NeuralShaft.Server.Controllers.Masters
{
    public class DesignationController : Controller
    {
        private readonly IDesignation _desigService;

        public DesignationController(IDesignation service)
        {
            _desigService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetDesignation")]
        public async Task<ActionResult> GetDesignation()
        {
            string getDesig = await _desigService.GetDesignation();
            return Content(getDesig, "application/json");
            //return Ok(getDesig);
        }

        [HttpGet("GetDesigdById/{DesigId}")]
        public async Task<ActionResult> GetDesignationById(int desigId)
        {

            var getDesigById = await _desigService.GetDesignationById(desigId);
            //int len = json.ToString().Length;
            return Content(getDesigById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertDesignation")]
        public async Task<IActionResult> InsertDesignation([FromBody] object desig)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertDesig = await _desigService.InsertDesignation(desig);
            return Ok(insertDesig);

        }

        [HttpPost("UpdateDesignation/{DesigId}")]
        public async Task<IActionResult> UpdateDesignation(int DesigId, [FromBody] object Desig)
        {
            var updateDesig = await _desigService.UpdateDesignation(DesigId, Desig);
            return Ok(updateDesig);

        }
    }
}
