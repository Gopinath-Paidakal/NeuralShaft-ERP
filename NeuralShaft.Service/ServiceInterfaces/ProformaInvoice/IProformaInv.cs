using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.ProformaInvoice
{
    public interface IProformaInv
    {
        Task<string> GetProformaInv(string fromDate, string toDate);
        Task<string> GetOrdClientByIdProInv(int ordClientHdrId);   //, string proformaType);

        Task<string> GetOrdClientByProformaType(int ordClientHdrId, string proformaType);

        Task<string> GetOrdClientByIdSODtl(int SOHdrId);
        Task<string> GetOrdClientQuoteItem(int itemQuoteHdrId);       
        
        Task<string> GetProformaInvById(int proformaInvHdrId);
        Task<string> InsertProformaInv(object proformaInv);
        Task<string> UpdateProformaInv(int proformaInvHdrId, object proformaInv);
        Task<string> DeleteProformaInv(int proformaInvHdrId);
    }
}
