using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceInterfaces.Login;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Login
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : Controller
    {
        private readonly ILogin _LoginService;

        public UserController(ILogin service)
        {
            _LoginService = service;
        }

        [HttpGet("Login/{UserName}/{UserPwd}")]
        public async Task<ActionResult> ValidateUser(string UserName, string UserPwd)
        {

            var loginEmpId = await _LoginService.ValidateUser(UserName, UserPwd);
            //int len = json.ToString().Length;
            return Content(loginEmpId, "application/json");
            //return Ok(json);
        }
    }
}
