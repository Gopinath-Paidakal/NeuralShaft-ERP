using Dapper;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Enquiry;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Enquiry
{
    public class EnqFollowUpService : IEnqFollowUp
    {
        private readonly IJsonRepository _repoJSon;
        //private readonly object NULL;

        public EnqFollowUpService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetEnquiryFollowUp(string fromDate, string toDate)
        {
            try
            {
                string enqFollowUp = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnqFollowUp",
                                   new { @FromDate = fromDate, @ToDate = toDate });
                return enqFollowUp;

            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetEnquiryFollowUpById(int enqHdrId)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnqFollowUp_ById", new { @EnqHdrId = enqHdrId });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertEnqFollowUp(object enqFollowUp)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqFollowUp", new { @EnqFollowUp = enqFollowUp.ToString() });
                //string enqFollowUpResp =  await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqFollowUp", new { @EnqFollowUp = enqFollowUp.ToString() });
                //return "enqFollowUpResp";
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateEnqFollowUp(int EnqFollowUpIdUpdate, object enqFollowUp)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateEnqFollowUp", new { @EnqFollowUpId = EnqFollowUpIdUpdate, @EnqFollowUp = enqFollowUp.ToString() });
                //string enqFollowUpResp =  await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqFollowUp", new { @EnqFollowUp = enqFollowUp.ToString() });
                //return "enqFollowUpResp";
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }
    }
}
