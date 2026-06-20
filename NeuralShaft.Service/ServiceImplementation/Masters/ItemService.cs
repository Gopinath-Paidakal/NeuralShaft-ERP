using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Repository.RepoInterfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class ItemService : IItem
    {
        private readonly IJsonRepository _repoJSon;

        public ItemService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetItem(string itemType)
        {
            try
            {
                string getItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetItem", new { @ItemType = itemType });
                return getItem;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> GetRawMatlForAssyByItemId(string itemType, int itemId)
        {
            try
            {
                string getRawMatl = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetRawMatl", new { @ItemType = itemType,  @ItemId = itemId });
                return getRawMatl;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> InsertItem(string itemType,object item)
        {
            try
            {
                string insertItem = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertItem", new { @ItemType = itemType, @Item = item.ToString() });
                return (insertItem);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }
    }
}
