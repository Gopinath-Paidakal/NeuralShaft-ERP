using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.Vendor;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Vendor
{
    public class VendorService : IVendor
    {
        private readonly IJsonRepository _venodrJSon;

        public VendorService(IJsonRepository repoJson)
        {
            _venodrJSon = repoJson;
        }

        public async Task<string> GetVendor()
        {
            string getVendor = await _venodrJSon.ExecuteJsonSPWithoutParameter("SP_GetVendor");
            return getVendor;
        }

        public async Task<string> GetVendorById(int vendorHdrId)
        {
            return await _venodrJSon.ExecuteJsonSPWithParameter("SP_GetVendorById",
                                                        new { @VendorHdrId = vendorHdrId });
        }

        public async Task<string> InsertVendorDtl(int vendorHdrId, object vendorDtl)
        {
            return await _venodrJSon.ExecuteJsonSPWithParameter("SP_InsertVendorDtl",
                                                    new { @VendorHdrId = vendorHdrId, @VendorDtl = vendorDtl.ToString() });
        }

        public async Task<string> InsertVendorHdrDtl(object vendor)
        {
            return await _venodrJSon.ExecuteJsonSPWithParameter("SP_InsertVendorHdr",
                                                    new { @VendorHdr = vendor.ToString() });
        }

        public async Task<string> UpdateVendorDtl(int vendorDtlId, object vendorDtl)
        {
            return await _venodrJSon.ExecuteJsonSPWithParameter("SP_UpdateVendorDtl",
                                                   new { @VendorDtlId = vendorDtlId, @VendorDtl = vendorDtl.ToString() });
        }

        public async Task<string> UpdateVendorHdr(int vendorHdrId, object vendorHdr)
        {
            return await _venodrJSon.ExecuteJsonSPWithParameter("SP_UpdateVendorHdr",
                                        new { @VendorHdrId = vendorHdrId, @VendorHdrUpdate = vendorHdr.ToString() });
        }

        public Task<string> DeleteVendorDtl(int VendorDtlId)
        {
            throw new NotImplementedException();
        }
    }
}
