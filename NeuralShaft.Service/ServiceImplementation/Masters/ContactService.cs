using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class ContactService : IContact
    {

        private readonly IJsonRepository _repoJSon;

        public ContactService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetContact()
        {
            try
            {
                string GetContact = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getContact");
                return GetContact;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetContactById(int contactId)
        {
            try
            {
                string GetContactById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetContactById", new { @ContactId = contactId });
                return GetContactById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertContact(object contact)
        {
            try
            {
                string insertContact = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertContact", new { @Contact = contact.ToString() });
                return (insertContact);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateContact(int contactId, object contact)
        {
            try
            {
                string updateContact = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateContact", new { @ContactId = contactId, @Contact = contact.ToString() });
                return (updateContact);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }


        //public async Task<string> DeleteContact(int contactId)
        //{
        //    try
        //    {
        //        string DelContactId = await _repoJSon.ExecuteJsonSPWithParameter("SP_DeleteContact", new { @ContactId = contactId });
        //        return DelContactId;
        //    }
        //    catch (Exception ex)
        //    {
        //        // log error

        //        Console.WriteLine(ex.Message);
        //        throw; // rethrow to controller
        //    }
        //}

    }
}
