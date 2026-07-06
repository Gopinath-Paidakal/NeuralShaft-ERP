using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IItem
    {
        Task<string> GetItem(string itemType);

        Task<string> GetItemById(int itemId);

        Task<string> InsertItem(string itemType, string item);

        Task<string> UpdateItem(int itemId, object item);


        Task<string> GetRawMatlForAssyByItemId(string itemType, int itemId);
    }
}
