using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IOrdClient
    {
        Task<string> GetOrdClient();
        Task<string> GetOrdClientById(int enquiryId);

        Task<string> InsertOrdClientHdrDtl(object ordClient, int EnqDtlId);
        Task<string> UpdateOrdClientHdr(int OrdClientHdrId, object ordClientHdr);

        Task<string> InsertOrdClientAddr(int OrdClientHdrId, object ordClientAddr);
        Task<string> UpdateOrdClientAddr(int OrdClientAddrId, object ordClientAddr);
        Task<string> DeleteOrdClientAddr(int OrdClientAddrId);

    }
}
