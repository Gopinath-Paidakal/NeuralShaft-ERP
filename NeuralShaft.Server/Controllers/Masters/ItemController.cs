using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;

//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System.Net.Mail;
using static System.Runtime.InteropServices.JavaScript.JSType;


namespace NeuralShaft.Server.Controllers.Masters
{
    [ApiController]
    [Route("[controller]")]
    public class ItemController : Controller
    {
        private readonly IItem _itemService;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;

        string savePath = "/uploads/item/";

        public ItemController(IItem service, IWebHostEnvironment env, IUpload upload)
        {
            _itemService = service;
            _env = env;
            _uploadService = upload;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetItem/{itemType}")]
        public async Task<ActionResult> GetItem(string itemType)
        {
            string getItem = await _itemService.GetItem(itemType);
            return Content(getItem, "application/json");
            //return Ok(getItem);
        }

        [HttpGet("GetItemById/{itemId}")]
        public async Task<ActionResult> GetItemById(int itemId)
        {
            string getItemById = await _itemService.GetItemById(itemId);
            return Content(getItemById, "application/json");
            //return Ok(getItemById);
        }

        //[HttpGet("GetItemById/{itemType}/{itemId}")]
        //public async Task<ActionResult> GetItemById(string itemType, int itemId)
        //{
        //    string getItemById = await _itemService.GetRawMatlForAssyByItemId(itemType, itemId);
        //    return Content(getItemById, "application/json");
        //    //return Ok(getItemById);
        //}

        [HttpPost("InsertItem/{itemType}")]
        public async Task<IActionResult> InsertItem(string itemType, [FromForm] string item, [FromForm] List<IFormFile> attachments)
        {
            var itemId = await _itemService.InsertItem(itemType, item);

            var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(itemId.ToString()));

            return Ok(itemId);

        }

        [HttpPost("UpdateItem/{ItemId}")]
        public async Task<IActionResult> UpdateItem(int ItemId, [FromBody] object item)
        {
            var updateItem = await _itemService.UpdateItem(ItemId, item);
            return Ok(updateItem);

        }
    }
}


//[HttpPost("InsertAssy/{itemType}")]
//public async Task<IActionResult> InsertAssembly(string itemType, [FromBody] object item)    //, [FromForm] List<IFormFile> attachments)
//{
//    var itemAssyId = await _itemService.InsertAssembly(itemType, item);

//    //var uploaded = await _uploadService.UploadFilesAsync(attachments, savePath, Convert.ToInt32(itemId.ToString()));

//    return Ok(itemAssyId);

//}