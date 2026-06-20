using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Previlege;

namespace NeuralShaft.Server.Controllers.Previlege
{
    public class MenuController : Controller
    {
        private readonly IMenus _menuService;

        public MenuController(IMenus service)
        {
            _menuService = service;
        }

        [HttpGet("GetMenus/{EmpId}")]
        public async Task<ActionResult> GetMenus(int EmpId)
        {
            string getMenus = await _menuService.GetMenus(EmpId);
            return Content(getMenus, "application/json");
            //return Ok(getMenus);
        }
    }
}
