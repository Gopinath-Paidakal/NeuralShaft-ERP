using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Masters
{
    public class BranchController : Controller
    {
        private readonly IBranch _branchService;

        public BranchController(IBranch service)
        {
            _branchService = service;
        }

        //[Authorize(Roles = "admin")]
        [HttpGet("GetBranch")]
        public async Task<ActionResult> GetBranch()
        {
            string getBranch = await _branchService.GetBranch();
            return Content(getBranch, "application/json");
            //return Ok(getBranch);
        }

        [HttpGet("GetBranchdById/{branchId}")]
        public async Task<ActionResult> GetBranchEmpById(int branchId)
        {

            var getBranchById = await _branchService.GetBranchById(branchId);
            //int len = json.ToString().Length;
            return Content(getBranchById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertBranch")]
        public async Task<IActionResult> InsertBranch([FromBody] object branch)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertBranch = await _branchService.InsertBranch(branch);
            return Ok(insertBranch);
        }

        [HttpPost("UpdateBranch/{BranchId}")]
        public async Task<IActionResult> UpdateBranch(int BranchId, [FromBody] object branch)
        {
            var updateBranch = await _branchService.UpdateBranch(BranchId, branch);
            return Ok(updateBranch);

        }
    }
}
