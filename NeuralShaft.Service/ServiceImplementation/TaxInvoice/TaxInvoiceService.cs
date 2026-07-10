using NeuralShaft.Service.ServiceInterfaces.TaxInvoice;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.TaxInvoice
{
    public class TaxInvoiceService : ITaxInv
    {
        public Task<string> DeleteTaxInv(int taxInvHdrId)
        {
            throw new NotImplementedException();
        }

        public Task<string> GetTaxInv()
        {
            throw new NotImplementedException();
        }

        public Task<string> GetTaxInvById(int taxInvHdrId)
        {
            throw new NotImplementedException();
        }

        public Task<string> InsertTaxInv(object taxInv)
        {
            throw new NotImplementedException();
        }

        public Task<string> UpdateTaxInv(int taxInvHdrId, object TaxInv)
        {
            throw new NotImplementedException();
        }
    }
}
