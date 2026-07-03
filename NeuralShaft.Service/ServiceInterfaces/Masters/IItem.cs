using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IItem
    {
        Task<string> GetItem(string itemType);

        Task<string> InsertItem(string itemType, string item);

        //Task<string> InsertAssembly(string itemType, object item);

        Task<string> GetRawMatlForAssyByItemId(string itemType, int itemId);
    }
}
