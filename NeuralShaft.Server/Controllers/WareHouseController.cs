using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
//using NeuralShaft.Service.ServiceInterfaces.WareHouse;

namespace NeuralShaft.Server.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WareHouseController : Controller
    {
        private readonly IWareHouse _warehouseService;

        public WareHouseController(IWareHouse service)
        {
            _warehouseService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetWareHouse")]
        public async Task<ActionResult> GetWareHouse()
        {
            string getWareHouse = await _warehouseService.GetWareHouse();
            return Content(getWareHouse, "application/json");
            //return Ok(getDept);
        }

        [HttpGet("GetDeptdById/{wareHouseHdrId}")]
        public async Task<ActionResult> GetWareHouseById(int wareHouseHdrId)
        {

            var getWareHouseById = await _warehouseService.GetWareHouseById(wareHouseHdrId);
            //int len = json.ToString().Length;
            return Content(getWareHouseById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertWareHouse")]
        public async Task<IActionResult> InsertWareHouse([FromBody] object wareHouse)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertWareHouse = await _warehouseService.InsertWareHouse(wareHouse);
            return Ok(insertWareHouse);

        }

        [HttpPost("UpdateWareHouse/{wareHouseHdrId}")]
        public async Task<IActionResult> UpdateWareHouse(int wareHouseHdrId, [FromBody] object wareHouse)
        {
            var updateDept = await _warehouseService.UpdateWareHouse(wareHouseHdrId, wareHouse);
            return Ok(updateDept);

        }
    }
}
