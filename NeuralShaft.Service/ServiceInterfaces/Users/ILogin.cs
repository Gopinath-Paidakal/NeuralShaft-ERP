using Microsoft.Extensions.Primitives;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Login
{
    public interface ILogin
    {
        Task<string> ValidateUser(string userName, string userPwd);
    }
}
