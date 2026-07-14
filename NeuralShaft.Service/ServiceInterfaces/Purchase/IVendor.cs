using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Vendor
{
    public interface IVendor
    {
        Task<string> GetVendor();
        Task<string> GetVendorById(int vendorHdrId);
        Task<string> InsertVendor(object vendor);
        Task<string> UpdateVendor(int vendorHdrId, object vendor);
        Task<string> DeleteVendor(int vendorHdrId);
    }
}
