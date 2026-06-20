//using NeuralShaft.Model;

using Microsoft.AspNetCore.Http;

namespace NeuralShaft.Service.ServiceInterfaces
{
    public interface IEnquiry
    {
        Task<string> GetEnquiry(string fromDate, string toDate);
        Task<string> GetEnquiryHdrById(int enqHdrId);    //, int enqDtlId);

        Task<string> GetEnquiryDtlById(int enqDtlId);    //, int enqDtlId);

        Task<string> InsertEnqHdrDtl(object enqHdrDtl);
        Task<string> UpdateEnqHdr(int enqHdrId, object enqHdr);

        Task<string> InsertEnqDtl(int enqHdrId, object enqdtl);
        Task<string> UpdateEnqDtl(int enqDtlId, object enqdtl);
        Task<string> DeleteEnqDtlById(int enqDtlId);

        Task<string> GetEnqDtlAmtById(int enqDtlId);
        Task<string> UpdateEnqDtlAmt(int enqDtlId, object enqDtl);

        Task<string> GetEnqSourceBy(string enqSource);

    }
}




//Task<List<string>> UploadImagesAsync(List<IFormFile> files, int enqHdrId);


//Task<string> GetEnquiryFollowUp();
//Task<string> GetEnquiryFollowUpById(int enqHdrId);
//Task<string> InsertEnqFollowUp(object enqFollowUp);
//Task<string> UpdateEnqFollowUp(int EnqFollowUpIdUpdate, object enqFollowUp);


//Task<IEnumerable<Department>> GetAllDepartments();
////Task<Department> GetProduct(int id);
//Task<Department> CreateProduct(Department department);
//Task<Department> UpdateProduct(Department department);
////Task DeleteProduct(int id);