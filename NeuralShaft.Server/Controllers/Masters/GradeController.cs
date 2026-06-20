using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceInterfaces.Masters;


namespace NeuralShaft.Server.Controllers.Masters
{
    public class GradeController : Controller
    {
        private readonly IGrade _gradeService;

        public GradeController(IGrade service)
        {
            _gradeService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetGrade")]
        public async Task<ActionResult> GetGrade()
        {
            string getGrade = await _gradeService.GetGrade();
            return Content(getGrade, "application/json");
            //return Ok(getGrade);
        }

        [HttpGet("GetGradeById/{gradeId}")]
        public async Task<ActionResult> GetGradeById(int gradeId)
        {

            var getGradeById = await _gradeService.GetGradeById(gradeId);
            //int len = json.ToString().Length;
            return Content(getGradeById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertGrade")]
        public async Task<IActionResult> InsertGrade([FromBody] object grade)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertGrade = await _gradeService.InsertGrade(grade);
            return Ok(insertGrade);

        }

        [HttpPost("UpdateGrade/{GradeId}")]
        public async Task<IActionResult> UpdateGrade(int GradeId, [FromBody] object grade)
        {
            var updateGrade = await _gradeService.UpdateGrade(GradeId, grade);
            return Ok(updateGrade);

        }
    }
}
