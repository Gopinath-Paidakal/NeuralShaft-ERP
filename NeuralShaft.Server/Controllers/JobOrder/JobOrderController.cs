using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceImplementation.Quotation;
using NeuralShaft.Service.ServiceInterfaces.JobOrder;
using NeuralShaft.Service.ServiceInterfaces.Quotation;

namespace NeuralShaft.Server.Controllers.JobOrder
{
    [ApiController]
    [Route("[controller]")]
    public class JobOrderController : Controller
    {
        private readonly IJobOrder _JobOrderService;

        public JobOrderController(IJobOrder jobOrderService)
        {
            _JobOrderService = jobOrderService;
        }

        [HttpGet("GetJobOrder/{fromDate}/{toDate}")]
        public async Task<ActionResult> GetJobOrder(string fromDate, string toDate)
        {
            string jobOrderList = await _JobOrderService.GetJobOrder(fromDate, toDate);
            return Content(jobOrderList, "application/json");
        }
    }
}
