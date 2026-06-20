using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Previlege;

namespace NeuralShaft.Server.Controllers.Previlege
{
    public class MenuPermissionsController : Controller
    {
        private readonly IMenuPermissions _menuPermissionsService;

        public MenuPermissionsController(IMenuPermissions service)
        {
            _menuPermissionsService = service;
        }

        [HttpGet("GetMenuPermissions")]
        public async Task<ActionResult> GetMenuPermissions()
        {
            string GetMenuPermissions = await _menuPermissionsService.GetMenuPermissions();
            return Ok(GetMenuPermissions);
        }

        [HttpGet("GetMenuPermissionsById/{empId}")]
        public async Task<ActionResult> GetMenuPermissionsById(int empId)
        {

            var GetMenuPermissionsById = await _menuPermissionsService.GetMenuPermissionsById(empId);
            //int len = json.ToString().Length;
            return Content(GetMenuPermissionsById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertMenuPermissions")]
        public async Task<IActionResult> InsertMenuPermissions([FromBody] object menuPermission)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertMenuPermissions = await _menuPermissionsService.InsertMenuPermissions(menuPermission);
            return Ok(insertMenuPermissions);

        }

        [HttpPost("UpdateMenuPermissions")]
        public async Task<IActionResult> UpdateMenuPermissions([FromBody] object menuPermission)
        {
            var updateMenuPermissions = await _menuPermissionsService.UpdateMenuPermissions(menuPermission);
            return Ok(updateMenuPermissions);

        }

        [HttpGet("DeleteMenuPermissions/{menuPermissionsId}")]
        public async Task<ActionResult> DeleteMenuPermissions(int menuPermissionsId)
        {

            var deleteMenuPermissions = await _menuPermissionsService.DeleteMenuPermissions(menuPermissionsId);
            //int len = json.ToString().Length;
            return Content(deleteMenuPermissions, "application/json");
            //return Ok(json);
        }
    }
}
