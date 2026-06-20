using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Masters
{
    public class DepartmentController : Controller
    {
        private readonly IDepartment _deptService;

        public DepartmentController(IDepartment service)
        {
            _deptService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetDepartment")]
        public async Task<ActionResult> GetDepartment()
        {
            string getDept = await _deptService.GetDepartment();
            return Content(getDept, "application/json");
            //return Ok(getDept);
        }

        [HttpGet("GetDeptdById/{deptId}")]
        public async Task<ActionResult> GetDepartmentById(int deptId)
        {

            var getDeptById = await _deptService.GetDepartmentById(deptId);
            //int len = json.ToString().Length;
            return Content(getDeptById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertDepartment")]
        public async Task<IActionResult> InsertDepartment([FromBody] object dept)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertDept = await _deptService.InsertDepartment(dept);
            return Ok(insertDept);

        }

        [HttpPost("UpdateDepartment/{DeptId}")]
        public async Task<IActionResult> UpdateDepartment(int DeptId, [FromBody] object dept)
        {
            var updateDept = await _deptService.UpdateDepartment(DeptId, dept);
            return Ok(updateDept);

        }
    }
}
