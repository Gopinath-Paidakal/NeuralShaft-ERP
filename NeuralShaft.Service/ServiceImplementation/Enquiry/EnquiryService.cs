using Dapper;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;
//using NeuralShaft.Model;
//sing NeuralShaft.Model.Enquiry;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation
{
    public class EnquiryService :  IEnquiry
    {
        
        private readonly IJsonRepository _repoJSon;
        private readonly IWebHostEnvironment _env;
        //private readonly object NULL;

        public EnquiryService(IJsonRepository repoJson, IWebHostEnvironment env)
        {
            _repoJSon = repoJson;
            _env = env;
        }
        
        public async Task<string> GetEnquiry(string fromDate, string toDate)
        {
            try
            {
                string enqData = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnqHdr",
                                    new { @FromDate = fromDate, @ToDate = toDate });
                return enqData;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetEnquiryHdrById(int enqHdrId)
        {
            try
            {
                var enqGetHdrById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnquiryHdr_ById",
                                    new { @EnqHdrId = enqHdrId }); //@EnqDtlId = enqDtlId
                return enqGetHdrById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetEnquiryDtlById(int enqDtlId)
        {
            try
            {
                var enqGetDtlById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnquiryDtl_ById",
                                    new { @EnqDtlId = enqDtlId }); //@EnqDtlId = enqDtlId

                return enqGetDtlById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertEnqHdrDtl(object enqHdrDtl)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqHdr", new { @EnqHdr = enqHdrDtl.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertEnqDtl(int enqHdrId, object enqdtl)
        {
            try
            {   
                return await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqDtl", 
                                new { @EnqHdrId = enqHdrId, @EnqDtl = enqdtl.ToString()});
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateEnqHdr(int enqHdrId, object enqHdr)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("Sp_UpdateEnqHdr", 
                                    new {@EnqHdrId = enqHdrId,  @EnqHdr = enqHdr.ToString() });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateEnqDtl(int enqDtlId, object enqDtl)
        {
            try
            {
                var updateEnqDtlId = await _repoJSon.ExecuteJsonSPWithParameter("Sp_UpdateEnqDtl",
                                       new { @EnqDtlId = enqDtlId, @EnqDtl = enqDtl.ToString() });
                return updateEnqDtlId;
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> DeleteEnqDtlById(int enqDtlId)
        {
            try
            {
                return await _repoJSon.ExecuteJsonSPWithParameter("Sp_DeleteEnqDtl", new { @EnqDtlId = enqDtlId });
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetEnqDtlAmtById(int enqDtlId)
        {
            try
            {
                var enqGetDtlAmtById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnquiryDtlAmt_ById",
                                    new { @EnqDtlId = enqDtlId }); //@EnqDtlId = enqDtlId

                return enqGetDtlAmtById;


            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> UpdateEnqDtlAmt(int enqDtlId, object enqDtl)
        {
            try
            {
                var updateEnqDtlAmtId = await _repoJSon.ExecuteJsonSPWithParameter("Sp_UpdateEnqDtlAmount",
                                       new { @EnqDtlId = enqDtlId, @EnqDtl = enqDtl.ToString() });
                return updateEnqDtlAmtId;
            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetEnqSourceBy(string enqSource)
        {
            try
            {
                var enqGetEnqSourceBy = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnqSourceBy",
                                    new { @EnqSource = enqSource }); //@EnqDtlId = enqDtlId
                return enqGetEnqSourceBy;


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


//public async Task<List<string>> UploadImagesAsync(List<IFormFile> files, int enqHdrId)
//{
//    var uploadedFiles = new List<string>();

//    if (files == null || files.Count == 0)
//        return uploadedFiles;

//    /// --------- Local path
//    string uploadPath = Path.Combine(_env.ContentRootPath, "UploadNew\\Images\\Enquiry");

//    // --------- Cloud Path
//    //string uploadPath = Path.Combine("/var/www/uploads/enquiry/");    //, trustedFileName);

//    if (!Directory.Exists(uploadPath))
//        Directory.CreateDirectory(uploadPath);

//    foreach (var file in files)
//    {
//        if (file.Length > 0)
//        {
//            var fileName = enqHdrId + "_" + file.FileName;

//            var filePath = Path.Combine(uploadPath, fileName);

//            using (var stream = new FileStream(filePath, FileMode.Create))
//            {
//                await file.CopyToAsync(stream);
//            }
//            uploadedFiles.Add(fileName);
//        }
//    }
//    return uploadedFiles;
//}

//public async Task<string> GetEnquiryHdrById(int enqHdrId)
//{
//    try
//    {
//        var enqGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnquiryHdr_ById",
//                            new { @EnqHdrId = enqHdrId }); //@EnqDtlId = enqDtlId
//        return enqGetById;


//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}

//public async Task<string> GetEnquiryDtlById(int enqDtlId)
//{
//    try
//    {
//        var enqGetById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnquiryHdr_ById",
//                            new { @EnqHdrId = enqHdrId }); //@EnqDtlId = enqDtlId
//        return enqGetById;


//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}
//var fileName = "108_" + Path.GetExtension(file.FileName);
//var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);

//string uploadPath = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");
//string uploadPath = Path.Combine(_env.WebRootPath, "UploadNew", "Images", "Enquiry");
//string uploadPath = Path.Combine(_env.ContentRootPath, "UploadNew", "Images", "Enquiry");

//string webRootPath = (_env.WebRootPath.ToString());

//Console.WriteLine(_env.ContentRootPath.ToString());


///// =============================================================
///  // Getting Images from the Server
//string folder = "/var/www/images/enquiry";

//var files = Directory.GetFiles(folder, $"{enqHdrId}_*")
//                     .Select(f => Path.GetFileName(f))
//                     .ToList();

//var baseUrl = $"{Request.Scheme}://{Request.Host}/enquiry-images/";

//var imageUrls = files.Select(f => baseUrl + f);

//// 🔹 3. Combine
//return Ok(new
//{
//    Data = jsonData,
//    Images = imageUrls
//});

















//public async Task<string> GetEnquiryFollowUp()
//{
//    try
//    {
//        string enqFollowUp = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetEnqFollowUp");
//        return enqFollowUp;
//    }
//    catch (Exception ex)
//    {
//        // log error

//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}
//public async Task<string> InsertEnqFollowUp(object enqFollowUp)
//{
//    try
//    {
//        return await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqFollowUp", new { @EnqFollowUp = enqFollowUp.ToString() });
//        //string enqFollowUpResp =  await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqFollowUp", new { @EnqFollowUp = enqFollowUp.ToString() });
//        //return "enqFollowUpResp";
//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}

//public async Task<string> UpdateEnqFollowUp(int EnqFollowUpIdUpdate, object enqFollowUp)
//{
//    try
//    {
//        return await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateEnqFollowUp", new { @EnqFollowUpIdUpdate = EnqFollowUpIdUpdate, @EnqFollowUp = enqFollowUp.ToString() });
//        //string enqFollowUpResp =  await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertEnqFollowUp", new { @EnqFollowUp = enqFollowUp.ToString() });
//        //return "enqFollowUpResp";
//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}

//public async Task<string> GetEnquiryFollowUpById(int enqHdrId)
//{
//    try
//    {
//        return await _repoJSon.ExecuteJsonSPWithParameter("SP_GetEnqFollowUp_ById", new { @EnqHdrId = enqHdrId });
//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}
// ==============================================

//public async Task<string> UpdateEnquiry(object enqdata)  //, int enquiryId)
//{
//    try
//    {
//        return await _repoJSon.ExecuteJsonSPWithParameter("Sp_UpdateEnquiry", new { @Enquiry = enqdata.ToString() });
//    }
//    catch (Exception ex)
//    {
//        // log error
//        Console.WriteLine(ex.Message);
//        throw; // rethrow to controller
//    }
//}     
//private readonly IEnquiryRepository _repository;

//public async Task<string> Delete(int enquiryId)
//{
//    return await _repository.ExecuteJsonSP(
//        "sp_DeleteEnquiry",
//        new { EnquiryId = enquiryId }
//    );
//}


//public EnquiryService(IEnquiryRepository repo, IJsonRepository repoJson)
//{
//    _repository = repo;
//    _repoJSon = repoJson;
//}


//public async Task<short> DeleteDepartment(int id)
//{
//    await _repository.DeleteDepartment(id);
//    return 1;
//}

//public Task<short> GetDepartmentById(int id)
//{
//    throw new NotImplementedException();
//}

//public DepartmentService(IJsonRepository repo)
//{
//    _repo = repo;
//}

//public async Task<string> GetJSonDepartments()
//{
//    return await _repo.ExecuteJsonSP("P_DEPARTMENT", "");
//}

//var enquiry = await _repository.GetEnquiry();

//return await _repository.GetEnquiry();

//return await _repoJSon.GetEnquiry();


//if (string.IsNullOrEmpty(departments))
//    return "No departments found";

//return departments;

//await _repository.UpdateEnquiry(enqdata);
//return 1;

//var json = JsonSerializer.Serialize(enquiry);

//var enquiry = await _repository.GetEnquiryById(enquiryId);

//return await _repository.GetEnquiryById(enquiryId);

//var parameters = new DynamicParameters();

//parameters.Add("@Enquiry", enquiryId);
////parameters.Add("@BranchId", 2);
////parameters.Add("@EnqNo", "ENQ001");
////parameters.Add("@CreatedBy", "Admin");
///
//var enquiry = await _repository.GetEnquiryFollowUp();

//return await _repository.GetEnquiryFollowUp();

//if (string.IsNullOrEmpty(departments))
//    return "No departments found";

//return departments;


//var result = await _repository.InsertEnquiry(enqdata);
//return result.ToString();

//var json = JsonSerializer.Serialize(enquiry);

//string uploadPath = Path.Combine(_env.ContentRootPath, "images\\enquiry");
//string uploadPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "enquiry");
