using NeuralShaft.Service.ServiceInterfaces.OrderApprove;
using Dapper;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.OrderApprove
{
    public class OrdApproveService : IOrdApprove
    {
        private readonly IJsonRepository _OrdrepoJSon;
        //private readonly object NULL;

        public OrdApproveService(IJsonRepository repoJson)
        {
            _OrdrepoJSon = repoJson;
        }

        public async Task<string> GetOrdApprove()
        {

            try
            {

                string OrdApproveList = await _OrdrepoJSon.ExecuteJsonSPWithoutParameter("SP_GetOrdAppList");
                                   //new { @FromDate = fromDate, @ToDate = toDate });

                return OrdApproveList;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }

        }

        public async Task<string> GetOrdReject(string fromDate, string toDate)
        {
            try
            {

                string OrdRejectList = await _OrdrepoJSon.ExecuteJsonSPWithParameter("SP_GetOrdRejList",
                                   new { @FromDate = fromDate, @ToDate = toDate });

                return OrdRejectList;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertOrdApprove(object OrdApprove)
        {
            try
            {
                return await _OrdrepoJSon.ExecuteJsonSPWithParameter("SP_InsertOrdApp", new
                {
                    @OrdApprove = OrdApprove.ToString()
                });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateOrdRej(int enqDtlId, string ordApproved)
        {
            try
            {
                return await _OrdrepoJSon.ExecuteJsonSPWithParameter("SP_UpdateOrdRej", new
                {
                    //@OrdApproveId = ordApproveId,
                    @EnqDtlId = enqDtlId , @OrdApproved = ordApproved.ToString()
                });
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
