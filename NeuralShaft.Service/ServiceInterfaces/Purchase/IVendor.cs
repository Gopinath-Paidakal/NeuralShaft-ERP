using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Vendor
{
    public interface IVendor
    {
        Task<string> GetVendor();
        Task<string> GetVendorById(int VendorHdrId);

        Task<string> InsertVendorHdrDtl(object vendor);
        Task<string> UpdateVendorHdr(int vendorHdrId, object vendorHdr);

        Task<string> InsertVendorDtl(int VendorHdrId, object VendorDtl);
        Task<string> UpdateVendorDtl(int VendorDtlId, object VendorDtl);
        Task<string> DeleteVendorDtl(int VendorAddrId);
    }
}
