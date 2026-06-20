using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using Newtonsoft.Json;
//using Newtonsoft.Json;
using System.Text.Json;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers.Masters
{
    //[EnableCors("corspolicy")]
    //[EnableRateLimiting("fixedWindow")]

    [ApiController]
    [Route("[controller]")]
    public class DefaultDataController : Controller
    {
        private readonly IDefaultData _defaultDataService;

        public DefaultDataController(IDefaultData service)
        {
            _defaultDataService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetDefaultData/{formType}/")]
        public async Task<ActionResult> GetDefaultData(string formType)
        {
           
            string formDefaultData = await _defaultDataService.GetDefaulData(formType);
            //return Ok(formDefaultData);
            return Content(formDefaultData, "application/json");
        }

        [HttpPost("InsertDefaultData")]
        public async Task<IActionResult> InsertDefaultData([FromBody] object defaultData)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertDefalutDataId = await _defaultDataService.InsertDefaultData(defaultData);
            return Ok(insertDefalutDataId);

        }

        [HttpPost("UpdateDefaultData/{DefaultDataId}")]
        public async Task<IActionResult> UpdateDefaultData(int DefaultDataId, [FromBody] object defaultData)
        {
            var updateDefaultDataId =  await _defaultDataService.UpdateDefaultData(DefaultDataId, defaultData);
            return Ok(updateDefaultDataId);

        }
    }
}



//  string json = JsonConvert.DeserializeObject<string>(formDefaultData);

//var result = JsonSerializer.Deserialize<object>(formDefaultData);

// string jsonString = System.Text.Json.JsonSerializer.Serialize(formDefaultData);

//return Ok(result);

// return Ok(jsonString);


//var result = JsonConvert.DeserializeObject(formDefaultData);

//return Ok(result);

//return new JsonResult(formDefaultData);