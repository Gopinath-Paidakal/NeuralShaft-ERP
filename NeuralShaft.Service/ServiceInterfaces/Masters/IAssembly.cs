using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IAssembly
    {
        Task<string> GetAssemblyHdr();
        Task<string> GetAssemblyById(int AssemblyHdrId);
        Task<string> InsertAssembly(object Assy);

        Task<string> InsertAssyItem(object AssyItem);
        Task<string> DeleteAssyItem(int assemblyItemId);
    }
}
