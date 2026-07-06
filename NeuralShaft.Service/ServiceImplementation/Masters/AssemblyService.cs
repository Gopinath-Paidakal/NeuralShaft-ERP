using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class AssemblyService : IAssembly
    {
        private readonly IJsonRepository _repoJSon;

        public AssemblyService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetAssemblyHdr()
        {
            string GetAssyHdr = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetAssyHdr");    //, new { @AssemblyHdrId = AssemblyHdrId });
            return GetAssyHdr;
        }

        public async Task<string> GetAssemblyById(int AssemblyHdrId)
        {
            string GetAssyHdr = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetAssyHdrById", new { @AssemblyHdrId = AssemblyHdrId });
            return GetAssyHdr;
        }

        public async Task<string> InsertAssembly(object Assy)
        {
            string insertAssy = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertAssy", new {@Assy = Assy.ToString() });
            return (insertAssy);
        }

        public async Task<string> DeleteAssyItem(int AssemblyItemId)
        {
            var DelAssyDtlItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteAssyDtlById", new { @AssemblyItemId = AssemblyItemId });
            return DelAssyDtlItem;

        }

        public async Task<string> InsertAssyItem(object assyItem)
        {
            string insertAssyItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertAssyItem", new { @AssyItem = assyItem.ToString() });
            return (insertAssyItem);
        }
    }
    
}
