using Microsoft.AspNetCore.Mvc;
//using NeuralShaft.Model;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace NeuralShaft.Server.Controllers
{
    //[EnableCors("corspolicy")]
    //[EnableRateLimiting("fixedWindow")]

    [ApiController]
    [Route("[controller]")]
    public class EnqClientController : Controller
    {
        private readonly IEnqClient _service;

        public EnqClientController(IEnqClient service)
        {
            _service = service;
        }

        [HttpGet("GetClient")]
        public async Task<ActionResult> GetClient()
        {
            //var data = await _service.GetDepartments();
            //return Ok(data);
            string clientData = await _service.GetClient();
            return Content(clientData, "application/json");
            //return Ok(clientData);
        }
    }
}


//[HttpGet("GetEnquiry")]
//public async Task<ActionResult> GetEnquiry()
//{
//    //var data = await _service.GetDepartments();
//    //return Ok(data);
//    var json = await _service.GetEnquiry();
//    return Content(json, "application/json");
//}