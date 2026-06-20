using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IContact
    {
        Task<string> GetContact();
        Task<string> GetContactById(int contactId);
        Task<string> InsertContact(object contact);
        Task<string> UpdateContact(int contactId, object contact);
        //Task<string> DeleteContact(int contactId);
    }
}
