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

        public async Task<string> GetReceiptById(int receiptHdrId)
        {
            var getReceiptById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetReceiptById",
                                  new { @ReceiptHdrId = receiptHdrId });
            return getReceiptById;
        }

        public async Task<string> GetSOByOrdClientId(int ordClientHdrId)
        {
            string GetPaymentsByOrdClientId = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetSOByOrdClientId", new { @OrdClientHdrId = ordClientHdrId });
            return GetPaymentsByOrdClientId;
        }

        public async Task<string> InsertReceipt(object receipt)
        {
            string insertReceipt = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertReceipt", new { @Receipt = receipt.ToString() });
            return (insertReceipt);

        }

        public async Task<string> UpdateReceipt(int receiptHdrId, object receipt)
        {
            string updateReceipt = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateReceipt", new { @ReceiptHdrId = receiptHdrId, @Receipt = receipt.ToString() });
            return (updateReceipt);

        }

        //public async Task<string> DeleteReceipt(int receiptId)
        //{
        //    throw new NotImplementedException();
        //}

    }
}
