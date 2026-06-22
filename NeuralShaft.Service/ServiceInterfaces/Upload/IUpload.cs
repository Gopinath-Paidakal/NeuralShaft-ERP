using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Upload
{
    public interface IUpload
    {
        Task<List<string>> UploadFilesAsync(List<IFormFile> attachments, string uploadPath, int Id);

        //Task<List<string>> UploadFilesAsync(List<IFormFile> attachments, string uploadPath);

        Task<List<string>> DownloadFilesAsync(string path, int Id);

        Task<List<string>> DownloadFilesAsync(string path);

        Task<bool> DeleteFileAsync(string path, string fileName);

        

    }
}


//Task<List<string>> UploadFilesAsync(IFormFile[] files, string uploadPath, int Id);

//Task<List<string>> UploadFilesAsyncWithIds(List<IFormFile> attachments, string path, string ids);
