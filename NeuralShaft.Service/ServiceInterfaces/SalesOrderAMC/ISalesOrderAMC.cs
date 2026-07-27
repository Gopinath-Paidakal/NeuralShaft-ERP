using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.SalesOrderAMC
{
    public interface ISalesOrderAMC
    {
        //----- SalesOrderAMC Hdr
        Task<string> GetSalesOrderAMC(string fromDate, string toDate, string status);

        Task<string> GetSalesOrderAMCHdrById(int salesOrderAMCHdrId);

        Task<string> InsertSalesOrderAMCHdrDtl(object salesOrderAMCHdrDtl);  // Inserts both Header and Detail

        Task<string> UpdateSalesOrderAMCHdr(int salesOrderAMCHdrId, object salesOrderAMCHdr);


        //----- SalesOrderAMC Dtl
        Task<string> InsertSalesOrderAMCDtl(object salesOrderAMCDtl);

        Task<string> UpdateSalesOrderAMCDtl(int salesOrderAMCDtlId, object salesOrderAMCDtl);

        Task<string> DeleteSalesOrderAMCDtl(int salesOrderAMCDtlId);
    }
}
