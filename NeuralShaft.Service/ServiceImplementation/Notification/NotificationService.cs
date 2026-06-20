using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Enquiry;
using System.Linq;
using System.Threading.Tasks;
using NeuralShaft.Shared.Hubs;
using System.Text.Json;

public class NotificationService : INotification
{
    //private readonly YourDbContext _context;
    private readonly IJsonRepository _JSONcontext;

    private readonly IHubContext<NotificationHub> _hubContext;

    public NotificationService(IJsonRepository context, IHubContext<NotificationHub> hubContext)
    {
        _JSONcontext = context;
        _hubContext = hubContext;
    }

    /// <summary>
    /// Fetches all unread enquiry follow-ups for a user and sends them via SignalR.
    /// </summary>
    public async Task<string> SendPendingNotificationsAsync(int userId)
    {

        string enqFollowUp = await _JSONcontext.ExecuteJsonSPWithParameter("SP_GetEnqFollowUp_ByUserId",
                        new { @CreatedUserId = userId});

        await _hubContext.Clients.User(userId.ToString())
               .SendAsync("ReceiveNotification", enqFollowUp);

        return enqFollowUp;
    }
}



//var pending = await _context.EnquiryFollowups
//    .Where(e => e.UserId == userId && !e.IsRead)
//    .ToListAsync();

//using System;
//using System.Collections.Generic;
//using System.Text;

//namespace NeuralShaft.Service.ServiceImplementation.Notification
//{
//    internal class NotificationService
//    {
//    }
//}

//var followUps = System.Text.Json.JsonSerializer.Deserialize<JsonElement>(enqFollowUp.ToString());

//foreach (var item in followUps.EnumerateArray())
//{
//    //var jsonMessage = System.Text.Json.JsonSerializer.Serialize(new
//    //{
//    //    CreatedUserId = item.GetProperty("CreatedUserId").GetString(),
//    //    EnqLastDiscussion = item.GetProperty("EnqLastDiscussion").GetString(),
//    //    CreatedDate = item.GetProperty("CreatedDate").GetDateTime()
//    //});

//    await _hubContext.Clients.User(userId)
//        .SendAsync("ReceiveNotification", jsonMessage);
//}

//return enqFollowUp;

//foreach (var item in enqFollowUp)
//{
//   // Send notification as raw JSON string
//   var jsonMessage = System.Text.Json.JsonSerializer.Serialize(new
//   {
//       //item.Id,
//       item.CreatedUserId,
//       item.EnqLastDiscussion,
//       item.CreatedDate
//   });

//    await _hubContext.Clients.User(userId)
//        .SendAsync("ReceiveNotification", jsonMessage);
//}

// Mark them as read via stored procedure
//await _context.Database.ExecuteSqlRawAsync("EXEC MarkFollowupsAsRead @UserId = {0}", userId);

//foreach (var item in pending)
//{
//    await _hubContext.Clients.User(userId)
//        .SendAsync("ReceiveNotification", item.Message);

//    item.IsRead = true; // mark as read once sent
//}

//await _hubContext.SaveChangesAsync();