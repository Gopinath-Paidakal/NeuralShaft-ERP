using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.TaxInvoice
{
    public interface ITaxInv
    {
        Task<string> GetTaxInv(string fromDate, string toDate);
        Task<string> GetOrdClientByIdTaxInv(int ordClientHdrId);
        Task<string> GetTaxInvById(int taxInvHdrId);
        Task<string> InsertTaxInv(object taxInv);
        Task<string> UpdateTaxInv(int taxInvHdrId, object TaxInv);
        Task<string> DeleteTaxInv(int taxInvHdrId);
    }
}
