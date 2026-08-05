using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Receipt;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Receipt
{
    public class ReceiptService : IReceipt
    {

        private readonly IJsonRepository _repoJSon;

        public ReceiptService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }
               

        public async Task<string> GetReceipt(string fromDate, string toDate)
        {
            string GetReceipt = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetReceipt",
                                    new { @FromDate = fromDate, @ToDate = toDate });
            return GetReceipt;
        }

        public async Task<string> GetReceiptById(int receiptId)
        {
            var getReceiptById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetReceiptById",
                                  new { @ReceiptId = receiptId });
            return getReceiptById;
        }

        public async Task<string> GetPaymentsByOrdClientId(int receiptId)
        {
            string GetPaymentsByOrdClientId = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetPaymentsByOrdClientId", new { @OrdClientHdrId = receiptId });
            return GetPaymentsByOrdClientId;
        }

        public async Task<string> InsertReceipt(object receipt)
        {
            string insertReceipt = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertReceipt", new { @Receipt = receipt.ToString() });
            return (insertReceipt);

        }

        public async Task<string> UpdateReceipt(int receiptId, object receipt)
        {
            throw new NotImplementedException();
        }

        //public async Task<string> DeleteReceipt(int receiptId)
        //{
        //    throw new NotImplementedException();
        //}

    }
}
