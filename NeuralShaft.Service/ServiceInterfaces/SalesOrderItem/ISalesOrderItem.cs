using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.SalesOrderItem
{
    public interface ISalesOrderItem
    {
        //----- SalesOrderItem Hdr
        Task<string> GetSalesOrderItem(string fromDate, string toDate, string status);

        Task<string> GetSalesOrderItemHdrById(int salesOrderItemHdrId);

        Task<string> InsertSalesOrderItemHdrDtl(object salesOrderHdrItem);  // Inserts both Header and Detail

        Task<string> UpdateSalesOrderItemHdr(int salesOrderItemHdrId, object SalesOrderHdrItem);


        //----- SalesOrderItem Dtl
        Task<string> InsertSalesOrderItemDtl(object salesOrderItemDtl);

        Task<string> UpdateSalesOrderItemDtl(int salesOrderItemDtlId, object salesOrderItemDtl);

        Task<string> DeleteSalesOrderItemDtl(int salesOrderItemDtlId);
    }
}
