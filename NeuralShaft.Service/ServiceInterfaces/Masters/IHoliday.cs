using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceInterfaces.Masters
{
    public interface IHoliday
    {
        Task<string> GetHoliday();
        Task<string> GetHolidayById(int holidayId);
        Task<string> InsertHoliday(object holiday);
        Task<string> UpdateHoliday(int holidayId, object holiday);
        Task<string> DeleteHoliday(int holidayId);
    }
}
