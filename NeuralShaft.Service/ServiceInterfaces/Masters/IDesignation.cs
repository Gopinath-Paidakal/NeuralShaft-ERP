using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IDesignation
    {
        Task<string> GetDesignation();
        Task<string> GetDesignationById(int desigId);
        Task<string> InsertDesignation(object desig);
        Task<string> UpdateDesignation(int desigId, object desig);
        Task<string> DeleteDesignation(int desigId);
    }
}
