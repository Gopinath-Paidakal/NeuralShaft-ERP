using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Receipt
{
    public interface IReceipt
    {
        Task<string> GetReceipt(string fromDate, string toDate);
        Task<string> GetReceiptById(int receiptHdrId);
        Task<string> GetSOByOrdClientId(int ordClientHdrId);

        Task<string> InsertReceipt(object receipt);
        Task<string> UpdateReceipt(int receiptHdrId, object receipt);
        //Task<string> DeleteReceipt(int receiptId);
    }
}
