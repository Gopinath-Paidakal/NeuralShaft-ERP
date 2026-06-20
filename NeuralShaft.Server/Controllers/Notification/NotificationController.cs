using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Enquiry;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
    //private readonly NotificationService _notificationService;
    private readonly INotification _notificationService;

    public NotificationController(INotification notificationService)
    {
        _notificationService = notificationService;
    }

    /// <summary>
    /// Trigger notifications for a given userId.
    /// </summary>
    [HttpPost("send")]
    public async Task<IActionResult> Send(int userId)
    {
        //if (string.IsNullOrEmpty(userId))
        //    return BadRequest("UserId is required.");

        var enqFollowUp = await _notificationService.SendPendingNotificationsAsync(userId);

        //return Ok(new { Status = "Notifications sent", UserId = userId });

        return Ok(new { Status = "Notifications sent", UserId = userId, EnquiryFollowUp = enqFollowUp });
    }
}




//public async Task<IActionResult> Send([FromBody] string userId)













//using Microsoft.AspNetCore.Mvc;

//namespace NeuralShaft.Server.Controllers.Notification
//{
//    public class NotificationController : Controller
//    {
//        public IActionResult Index()
//        {
//            return View();
//        }
//    }
//}

//using Microsoft.AspNetCore.Mvc;
//using System.Threading.Tasks;

//[ApiController]
//[Route("api/[controller]")]
//public class AccountController : ControllerBase
//{
//    private readonly NotificationService _notificationService;

//    public AccountController(NotificationService notificationService)
//    {
//        _notificationService = notificationService;
//    }

//    [HttpPost("login")]
//    public async Task<IActionResult> Login(UserId)
//    {
//        // 1. Validate user credentials (pseudo-code)
//        //var isValidUser = ValidateUser(dto.UserId, dto.Password);
//        //if (!isValidUser)
//        //    return Unauthorized();

//        //// 2. Issue JWT token (pseudo-code)
//        //var token = GenerateJwt(dto.UserId);

//        // 3. Send pending notifications for this user
//        await _notificationService.SendPendingNotificationsAsync(UserId);

//        // 4. Return token to frontend
//        return Ok(new { Token = token });
//    }

//    private bool ValidateUser(string userId, string password)
//    {
//        // Replace with actual authentication logic
//        return true;
//    }

//    private string GenerateJwt(string userId)
//    {
//        // Replace with actual JWT generation logic
//        return "mock-jwt-token";
//    }
//}


//public async Task<IActionResult> Login([FromBody] LoginDto dto)