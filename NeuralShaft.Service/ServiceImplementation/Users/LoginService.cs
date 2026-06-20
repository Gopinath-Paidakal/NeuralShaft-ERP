using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Login;
using Org.BouncyCastle.Ocsp;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Login
{
    public class LoginService : ILogin
    {
        private readonly IJsonRepository _LoginJSon;

        public LoginService(IJsonRepository repoJson)
        {
            _LoginJSon = repoJson;
        }

        public async Task<string> ValidateUser(string userName, string userPwd)
        {
            try
            {
                //string LoginEmpId;

                //LoginEmpId =  await _LoginJSon.ExecuteJsonSPWithParameter("SP_ValidateUser", 
                //            new { @LoginName = loginName, @LoginPwd = loginPwd });

                return await _LoginJSon.ExecuteJsonSPWithParameter("SP_ValidateUser",
                            new { @UserName = userName, @UserPwd = userPwd });

                //return Convert.ToInt32(LoginEmpId.ToString());

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // 
            }


        }
    }
}
