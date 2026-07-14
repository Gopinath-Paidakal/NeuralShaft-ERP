using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Vendor;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Vendor
{
    public class VendorService : IVendor
    {
        private readonly IJsonRepository _repoJSon;

        public VendorService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetVendor()
        {
            string GetVendor = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_GetVendor");
            return GetVendor;
        }

        public async Task<string> GetVendorById(int vendorHdrId)
        {
            string GetVendorById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetVendorById", new { @vendorHdrId = vendorHdrId });
            return GetVendorById;
        }

        public async Task<string> InsertVendor(object vendor)
        {
            string insertVendor = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertVendor", new { @Vendor = vendor.ToString() });
            return (insertVendor);
        }

        public async Task<string> UpdateVendor(int vendorHdrId, object vendor)
        {
            string updateVendor = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateVendor", new { @VendorHdrId = vendorHdrId, @Vendor = vendor.ToString() });
            return (updateVendor);
        }

        public Task<string> DeleteVendor(int vendorHdrId)
        {
            throw new NotImplementedException();
        }
    }
}
