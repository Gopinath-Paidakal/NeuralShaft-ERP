using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Masters
{
    public class CompanyController : Controller
    {

        private readonly ICompany _companyService;

        public CompanyController(ICompany service)
        {
            _companyService = service;
        }

        [HttpGet("GetCompany")]
        public async Task<ActionResult> GetCompany()
        {
            string getCompany = await _companyService.GetCompany();
            return Content(getCompany, "application/json");
            //return Ok(getCompany);
        }

        [HttpPost("UpdateCompany/{companyId}")]
        public async Task<IActionResult> UpdateCompany(int companyId, [FromBody] object company)
        {
            var updateCompany = await _companyService.UpdateCompany(companyId, company);
            return Ok(updateCompany);

        }
    }
}
