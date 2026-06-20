using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface ICompany
    {
        Task<string> GetCompany();
        Task<string> UpdateCompany(int companyId, object company);

        //Task<string> GetCompanyById(int compId);
        //Task<string> InsertCompany(object comp);
        //Task<string> DeleteCompany(int compId);
    }
}
