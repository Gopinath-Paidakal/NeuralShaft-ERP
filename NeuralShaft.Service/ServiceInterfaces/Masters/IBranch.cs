using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IBranch
    {
        Task<string> GetBranch();
        Task<string> GetBranchById(int branchId);
        Task<string> InsertBranch(object branch);
        Task<string> UpdateBranch(int branchId, object branch);
        Task<string> DeleteBranch(int branchId);

    }
}
