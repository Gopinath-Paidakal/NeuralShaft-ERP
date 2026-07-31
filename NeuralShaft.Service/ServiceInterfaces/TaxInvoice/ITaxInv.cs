using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.TaxInvoice
{
    public interface ITaxInv
    {
        Task<string> GetTaxInv(string fromDate, string toDate);
        Task<string> GetTaxInvById(int taxInvHdrId);
        Task<string> InsertTaxInv(object taxInv);
        Task<string> UpdateTaxInvHdr(int taxInvHdrId, object taxInv);
        

        //----- TaxInvDtl Dtl
        Task<string> InsertTaxInvDtl(object taxInvDtl);

        Task<string> UpdateTaxInvDtl(int taxInvDtlId, object taxInvDtl);

        Task<string> DeleteTaxInvDtl(int taxInvDtlId);
    }
}


//Task<string> GetOrdClientByIdTaxInv(int ordClientHdrId);
//Task<string> DeleteTaxInv(int taxInvHdrId);