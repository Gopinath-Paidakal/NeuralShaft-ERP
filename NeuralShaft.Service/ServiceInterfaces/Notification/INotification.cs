using System.Threading.Tasks;

public interface INotification
{
    /// <summary>
    /// Fetch unread enquiry follow-ups for a user and push them via SignalR.
    /// </summary>
    Task<string> SendPendingNotificationsAsync(int userId);
}




//using System;
//using System.Collections.Generic;
//using System.Text;

//namespace NeuralShaft.Service.ServiceInterfaces.Notification
//{
//    internal interface INotification
//    {
//    }
//}
