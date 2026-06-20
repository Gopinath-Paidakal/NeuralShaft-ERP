using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class OrdClientService : IOrdClient
    {
        private readonly IJsonRepository _OrdClientrepoJSon;

        public OrdClientService(IJsonRepository repoJson)
        {
            _OrdClientrepoJSon = repoJson;
        }

        //-------------  Ord Client 
        public async Task<string> GetOrdClient()
        {
            try
            {
                string ordClientData = await _OrdClientrepoJSon.ExecuteJsonSPWithoutParameter("SP_GetOrdClient");
                return ordClientData;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetOrdClientById(int OrdClientHdrId)
        {
            try
            {
                return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_GetOrdClientById",
                                                        new { @OrdClientHdrId = OrdClientHdrId });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertOrdClientHdrDtl(object ordClient, int enqDtlId)
        {
            try
            {
                return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_InsertOrdClientHdr",
                                                    new { @OrdClientHdr = ordClient.ToString(), @EnqDtlId = enqDtlId });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateOrdClientHdr(int OrdClientHdrId, object ordClient)
        {
            try
            {
                return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_UpdateOrdClientHdr",
                                        new { @OrdClientHdrId = OrdClientHdrId, @ordClient = ordClient.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }


        //-------------  Ord Client Address

        public async Task<string> InsertOrdClientAddr(int OrdClientHdrId, object ordClientAddr)
        {
            try
            {
                return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_InsertOrdClientAddr",
                                                    new { @OrdClientHdrId = OrdClientHdrId, @ordClientAddr = ordClientAddr.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateOrdClientAddr(int OrdClientAddrId, object ordClientAddr)
        {
            try
            {
                return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_UpdateOrdClientAddr",
                                                    new { @OrdClientAddrId = OrdClientAddrId, @ordClientAddr = ordClientAddr.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteOrdClientAddr(int OrdClientAddrId)
        {
            try
            {
                return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_DeleteOrdClientAddr", new { @OrdClientAddrId = OrdClientAddrId });
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


//public async Task<string> InsertOrdClientHdr(object ordClientHdr)
//{
//    try
//    {
//        return await _OrdClientrepoJSon.ExecuteJsonSPWithParameter("SP_InsertOrdClientHdr",
//                                            new { @OrdClientHdr = ordClientHdr.ToString() });
//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}