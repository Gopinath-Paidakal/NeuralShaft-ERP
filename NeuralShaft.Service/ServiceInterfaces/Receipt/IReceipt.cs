using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Receipt
{
    public interface IReceipt
    {
        Task<string> GetReceipt(string fromDate, string toDate);
        Task<string> GetReceiptById(int receiptId);
        Task<string> GetPaymentsByOrdClientId(int receiptId);

        Task<string> InsertReceipt(object receipt);
        Task<string> UpdateReceipt(int receiptId, object receipt);
        //Task<string> DeleteReceipt(int receiptId);
    }
}
