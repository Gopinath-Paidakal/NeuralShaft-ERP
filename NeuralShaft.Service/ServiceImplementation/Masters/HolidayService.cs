using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using System;
using System.Collections.Generic;
using System.Text;

namespace NeuralShaft.Service.ServiceImplementation.Masters
{
    public class HolidayService : IHoliday
    {

        private readonly IJsonRepository _repoJSon;

        public HolidayService(IJsonRepository repoJson)
        {
            _repoJSon = repoJson;
        }

        public async Task<string> GetHoliday()
        {
            try
            {
                string GetHoliday = await _repoJSon.ExecuteJsonSPWithoutParameter("SP_getHoliday");
                return GetHoliday;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> GetHolidayById(int holidayId)
        {
            try
            {
                string GetHolidayById = await _repoJSon.ExecuteJsonSPWithParameter("SP_GetHolidayById", new { @HolidayId = holidayId });
                return GetHolidayById;
            }
            catch (Exception ex)
            {
                // log error

                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }
        }

        public async Task<string> InsertHoliday(object holiday)
        {
            try
            {
                string insertHoliday = await _repoJSon.ExecuteJsonSPWithParameter("SP_InsertHoliday", new { @Holiday = holiday.ToString() });
                return (insertHoliday);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<string> UpdateHoliday(int holidayId, object holiday)
        {
            try
            {
                string updateHoliday = await _repoJSon.ExecuteJsonSPWithParameter("SP_UpdateHoliday", new { @HolidayId = holidayId, @Holiday = holiday.ToString() });
                return (updateHoliday);

            }
            catch (Exception ex)
            {
                // log error
                Console.WriteLine(ex.Message);
                throw; // rethrow to controller
            }

        }

        public async Task<string> DeleteHoliday(int HolidayId)
        {
            throw new NotImplementedException();
        }
    }
}
