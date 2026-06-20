using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Upload
{
    public class FileService : IFile
    {
        private readonly IJsonRepository _repoJSon;

        public FileService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }


        public Task<string> GetFile()
        {
            throw new NotImplementedException();
        }

        public async Task<string> GetFileById(int docFileId)
        {
            try
            {
                string GetFilesById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetFiles", new { @DocFileId = docFileId});
                return GetFilesById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertFile(object file)
        {
            try
            {
                string insertFile = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertFiles", new { @Files = file.ToString() });
                return (insertFile);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
