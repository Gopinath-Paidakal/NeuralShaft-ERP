using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;

//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using static System.Runtime.InteropServices.JavaScript.JSType;


namespace NeuralShaft.Server.Controllers.Masters
{
    [ApiController]
    [Route("[controller]")]
    public class ItemController : Controller
    {
        private readonly IItem _itemService;

        public ItemController(IItem service)
        {
            _itemService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetItem/{itemType}")]
        public async Task<ActionResult> GetItem(string itemType)
        {
            string getItem = await _itemService.GetItem(itemType);
            return Content(getItem, "application/json");
            //return Ok(getItem);
        }

        [HttpGet("GetItemById/{itemType}/{itemId}")]
        public async Task<ActionResult> GetItemById(string itemType, int itemId)
        {
            string getItemById = await _itemService.GetRawMatlForAssyByItemId(itemType, itemId);
            return Content(getItemById, "application/json");
            //return Ok(getItemById);
        }

        [HttpPost("InsertItem/{itemType}")]
        public async Task<IActionResult> InsertItem(string itemType, [FromBody] object item)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertItem = await _itemService.InsertItem(itemType, item);
            return Ok(insertItem);

        }

    }
}
