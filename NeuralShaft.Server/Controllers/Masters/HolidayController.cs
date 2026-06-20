using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Masters
{
    public class HolidayController : Controller
    {
        private readonly IHoliday _holidayService;

        public HolidayController(IHoliday service)
        {
            _holidayService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetHoliday")]
        public async Task<ActionResult> GetHoliday()
        {
            string getHoliday = await _holidayService.GetHoliday();
            return Content(getHoliday, "application/json");
            //return Ok(getHoliday);
        }

        [HttpGet("GetHolidayById/{holidayId}")]
        public async Task<ActionResult> GetHolidayById(int holidayId)
        {

            var getHolidayById = await _holidayService.GetHolidayById(holidayId);
            //int len = json.ToString().Length;
            return Content(getHolidayById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertHoliday")]
        public async Task<IActionResult> InsertHoliday([FromBody] object holiday)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertHoliday = await _holidayService.InsertHoliday(holiday);
            return Ok(insertHoliday);

        }

        [HttpPost("UpdateHoliday/{holidayId}")]
        public async Task<IActionResult> UpdateHoliday(int holidayId, [FromBody] object holiday)
        {
            var updateHoliday = await _holidayService.UpdateHoliday(holidayId, holiday);
            return Ok(updateHoliday);

        }
    }
}
