using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IFile
    {
        Task<string> GetFile();
        Task<string> GetFileById(int docFileId);
        Task<string> InsertFile(object file);
    }
}
