using NeuralShaft.Service.ServiceInterfaces.SalesOrder;
using Dapper;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.SalesOrder
{
    public class SalesOrderService : ISalesOrder
    {
        private readonly IJsonRepository _SOrepoJSon;
        //private readonly object NULL;

        public SalesOrderService(IJsonRepository repoJson)
        {
            _SOrepoJSon = repoJson;
        }

        public async Task<string> GetSalesOrder(string fromDate, string toDate)
        {
            try
            {
                string SOHdr = await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_GetSOList",
                                   new { @FromDate = fromDate, @ToDate = toDate });
                return SOHdr;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetSOHdrById(int SOHdrId)                //, int SODtlId)
        {
            try
            {
                var getSOHdrById =  await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_GetSOHdr_ById",
                                    new { @SOHdrId = SOHdrId });    //  , @SODtlId = SODtlId });
                return getSOHdrById;
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetSODtlById(int soDtlId)
        {
            try
            {
                var getSODtlById = await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_GetSODtl_ById",
                                    new { @SODtlId = soDtlId }); 

                return getSODtlById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertSOHdr(object SoHdr)
        {
            try
            {
                //return await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_InsertSOHdr", new { @OrdApproveId = OrdApproveId });
                var InsSOHdrId = await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_InsertSOHdr", new { @SOHdr = SoHdr.ToString()});
                return InsSOHdrId;

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        //public async Task<string> InsertSOHdr(int OrdApproveId)
        //{
        //    try
        //    {
        //        return await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_InsertSOHdr", new { @OrdApproveId = OrdApproveId });
        //    }
        //    catch (Exception ex)
        //    {
        //        // log error
        //        Console.WriteLine(ex.Message);
        //        throw; // rethrow to controller
        //    }
        //}

        public async Task<string> UpdateSOHdr(int SOHdrId, object SOHdr)
        {
            try
            {
                return await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_UpdateSOHdr",
                                    new { @SOHdrId = SOHdrId, @SOHdr = SOHdr.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertSODtl(int SOHdrId, object SOdtl)
        {
            try
            {
                return await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_InsertSODtl",
                                new { @SOHdrId = SOHdrId, @SODtl = SOdtl.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateSODtl(int SODtlId, object SOdtl)
        {
            try
            {
                return await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_UpdateSODtl",
                                    new { @SODtlId = SODtlId, @SoDtl = SOdtl.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteSODtlById(int SODtlId)
        {
            try
            {
                return await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_DeleteSODtl", new { @SODtlId = SODtlId });

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetSODtlAmtById(int soDtlId)
        {
            try
            {
                var GetSODtlAmtById = await _SOrepoJSon.ExecuteJsonSPWithParameter("SP_GetSODtlAmt_ById",
                                    new { @SODtlId = soDtlId }); 

                return GetSODtlAmtById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateSODtlAmt(int soDtlId, object soDtl)
        {
            try
            {
                var updateSODtlAmtId = await _SOrepoJSon.ExecuteJsonSPWithParameter("Sp_UpdateSODtlAmount",
                                       new { @SODtlId = soDtlId, @SODtl = soDtl.ToString() });
                return updateSODtlAmtId;
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
