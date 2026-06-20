using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class BranchService : IBranch
    {
        private readonly IJsonRepository _repoJSon;

        public BranchService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }
       
        public async Task<string> GetBranch()
        {
            try
            {
                string GetBranch = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getBranch");
                return GetBranch;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetBranchById(int branchId)
        {
            try
            {
                string GetBranchById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetBranchById", new { @BranchId = branchId });
                return GetBranchById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertBranch(object branch)
        {
            try
            {
                string insertBranch = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertBranch", new { @Branch = branch.ToString() });
                return (insertBranch);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateBranch(int branchId, object branch)
        {
            try
            {
                string updateBranch = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateBranch", new { @BranchId = branchId, @Branch = branch.ToString() });
                return (updateBranch);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public Task<string> DeleteBranch(int branchId)
        {
            throw new NotImplementedException();
        }

    }
}
