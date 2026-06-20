using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Service.ServiceInterfaces.Masters;

namespace NeuralShaft.Server.Controllers.Masters
{
    public class ContactController : Controller
    {
        private readonly IContact _contactService;

        public ContactController(IContact service)
        {
            _contactService = service;
        }

        [HttpGet("GetContact")]
        public async Task<ActionResult> GetContact()
        {
            string getContact = await _contactService.GetContact();
            return Content(getContact, "application/json");
            //return Ok(getContact);
        }

        [HttpGet("GetContactById/{ContactId}")]
        public async Task<ActionResult> GetContactById(int contactId)
        {

            var getContactById = await _contactService.GetContactById(contactId);
            //int len = json.ToString().Length;
            return Content(getContactById, "application/json");
            //return Ok(json);
        }

        [HttpPost("InsertContact")]
        public async Task<IActionResult> InsertContact([FromBody] object contact)
        {
            //await _service.InsertEnquiry(data);
            //return Ok();
            var insertContact = await _contactService.InsertContact(contact);
            return Ok(insertContact);

        }

        [HttpPost("UpdateContact/{ContactId}")]
        public async Task<IActionResult> UpdateContact(int ContactId, [FromBody] object contact)
        {
            var updateContact = await _contactService.UpdateContact(ContactId, contact);
            return Ok(updateContact);

        }
    }
}
