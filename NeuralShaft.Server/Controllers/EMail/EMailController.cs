using Microsoft.AspNetCore.Mvc;
using NeuralShaft.Server.Controllers.EMail;
//using NeuralShaft.Shared;
//using NeuralShaft.Shared.EMail;
using NeuralShaft.Service;
using NeuralShaft.Service.EMail;



namespace NeuralShaft.Server.Controllers.EMail
{
    [ApiController]
    [Route("api/[controller]")]
    public class EMailController : Controller
    {
        private readonly EMailService _emailService;

        public EMailController(EMailService emailService)
        {
            _emailService = emailService;
        }

        //[HttpPost("{ToEmail}/{Subject}/{EnqHdrId}")]
        [HttpPost("send")]
        //public async Task<IActionResult> SendMail([FromBody] MailRequest request, [FromForm] List<IFormFile> Attachments, int enqHdrId)
        public async Task<IActionResult> SendMail([FromForm] MailRequest request)
        {
             
             await _emailService.SendEmailAsync( 
                    request.ToEmail,
                    request.Subject,
                    request.Body,         // <-- pass HTML body directly
                    request.Cc,
                    request.CompProfile1,
                    request.CompProfile2,                   
                    request.Attachments
                    
            //request.EnqHdrId
            );

            return Ok(new { Message = "Email sent successfully" });
        }
       
    }

    public class MailRequest
    {
        public string ToEmail { get; set; } = string.Empty;
        public string Subject { get; set; } = string.Empty;
        public string Body { get; set; } = string.Empty;
        public string Cc { get; set; } = string.Empty;
        public bool CompProfile1 { get; set; } = false;
        public bool CompProfile2 { get; set; } = false;
        
        public List<IFormFile> Attachments { get; set; } = new();

        //public int EnqHdrId { get; set; }
    }
}





//await _emailService.SendEmailAsync(request.ToEmail, request.Subject, request.Body);
//request.ToEmail = "paidakal@gmail.com";
//request.ToEmail = "neuralshaft@gmail.com";
//request.ToEmail = "aruvajeevitha@gmail.com"; 
//request.Subject = "Testing";
//request.Body = "<div style=\"font-family:Arial,sans-serif;font-size:13px;line-height:1.75;color:#222;max-width:700px;\"> <p>Dear <b>Brisk</b> ,</p> <p>&nbsp;</p> <p>Ref. - Conversation with <b>Pavan Nagaraj.</b></p> <p>&nbsp;</p> <p>We would like to Introduce ourselves that we Brisk Elevators &amp; Escalators Pvt Ltd are leading Manufacturer and supplier of a wide range of Excellence-driven Home Lift, MRL Lift, MR Lift, Goods Lift, Hospital Lift, Glass Capsule Lift.</p> <p>&nbsp;</p> <p>We are one of the trusted <b>Home Elevators</b> in the industry with <b>CE Certified, EN 81 Standards</b> with <b>150+ Safety Parameters</b> and also have Collaboration with <b>GMV MARTINI S.p.A.,</b> Italy Italian multinational leader in the lift industry, with a company history of more than <b>50 years</b>. More than <b>815,000</b> lift systems all over the world (spread over 5 continents) use made-in-Italy GMV Products.</p> <p>&nbsp;</p> <p>With over 12 years of extensive experience in the vertical transport system sector, we have cultivated a satisfied clientele across diverse market segments. Our range of elevators is installed in Homes, Offices, Commercial Spaces, Industries, Educational Institutes, Healthcare Services, and the Hospitality Sector, supported by a team of dedicated experts and professionals.</p> <p>&nbsp;</p> <p>We appreciate the opportunity to speak with you and in our conversation, we discussed your mobility needs and how Brisk Elevators &amp; Escalators Pvt Ltd can help with the Elevator solution.</p> <p>&nbsp;</p> <p>We trust that the attached product details aligns with your specifications and requirements. Kindly inform us of your preferred method for proceeding with this business transaction. Alternatively, should revisions be necessary, please advise us on the requisite changes, and we will promptly share the cost quotation to meet your needs.</p> <p>&nbsp;</p> <p>Please do visit our official website for more details.</p> <p><a href=\"https://www.briskelevators.in\" style=\"color:#16a34a;text-decoration:none;\">www.briskelevators.in</a></p> <p>&nbsp;</p> <p>We look forward to your response and the prospect of establishing a valuable business relationship. We look forward to hearing from you in understanding better and valued business and connections.</p> <p>&nbsp;</p> <p style=\"color:#16a34a;\">We once again thank you for considering us for your requirement and look forward to receiving your order</p> <p>&nbsp;</p> <p>Yours sincerely</p> <p>&nbsp;</p> <p><b>Pavan Nagaraj</b><br> Sales Coordinator<br> +919611133977</p> <p>&nbsp;</p> <img src=\"https://neuralshaft.com/assets/mail_template_footer-CRdZ_7Zu.png\" alt=\"Brisk Elevators Footer\" style=\"max-width:100%;height:auto;display:block;\"> <p>&nbsp;</p> <p><b>Brisk Elevators &amp; Escalators Pvt Ltd</b></p> <p>No. 456, 10th Main Road, 3rd Stage, Basaveshwaranagar Main Road, Bengaluru - 560079</p> <p><b>Office No</b> | +91 80 23238661 | <b>Tollfree</b> - 1800 313 628 | <b>Mobile</b> - +91 91483 78672.</p> <p>Email : <a href=\"mailto:lift@briskelevators.in\" style=\"color:#1d4ed8;\">lift@briskelevators.in</a> | Web : <a href=\"https://www.briskelevators.in\" style=\"color:#1d4ed8;\">www.briskelevators.in</a>.</p> <p>&nbsp;</p> <p style=\"font-size:11px;color:#444;line-height:1.6;\"> The contents of this document are for informational purposes only and are subject to change without notice. Brisk Elevators &amp; Escalators Pvt Ltd makes no guarantee, representations or warranties with regard to the enclosed information and specifically disclaims, to the full extent of the law, any applicable implied warranties, such as fitness for a particular purpose, merchantability, satisfactory quality or reasonable skill and care. The usage of any Brisk Elevators &amp; Escalators Pvt Ltd shall be pursuant to the applicable end user agreement. Copyright 2026 Brisk Elevators &amp; Escalators Pvt Ltd. All rights reserved. </p> </div>";
//request.Body = "<div style=\"font-family:Arial,sans-serif;font-size:13px;line-height:1.75;color:#222;max-width:700px;\"> <p>Dear <b>Brisk</b> ,</p> <p>Ref. - Conversation with <b>Pavan Nagaraj.</b></p> <p>&nbsp;</p> <p>We would like to Introduce ourselves that we Brisk Elevators &amp; Escalators Pvt Ltd are leading Manufacturer and supplier of a wide range of Excellence-driven Home Lift, MRL Lift, MR Lift, Goods Lift, Hospital Lift, Glass Capsule Lift.</p> <p>&nbsp;</p> <p>We are one of the trusted <b>Home Elevators</b> in the industry with <b>CE Certified, EN 81 Standards</b> with <b>150+ Safety Parameters</b> and also have Collaboration with <b>GMV MARTINI S.p.A.,</b> Italy Italian multinational leader in the lift industry, with a company history of more than <b>50 years</b>. More than <b>815,000</b> lift systems all over the world (spread over 5 continents) use made-in-Italy GMV Products.</p> <p>&nbsp;</p> <p>With over 12 years of extensive experience in the vertical transport system sector, we have cultivated a satisfied clientele across diverse market segments. Our range of elevators is installed in Homes, Offices, Commercial Spaces, Industries, Educational Institutes, Healthcare Services, and the Hospitality Sector, supported by a team of dedicated experts and professionals.</p> <p>&nbsp;</p> <p>We appreciate the opportunity to speak with you and in our conversation, we discussed your mobility needs and how Brisk Elevators &amp; Escalators Pvt Ltd can help with the Elevator solution.</p> <p>&nbsp;</p> <p>We trust that the attached product details aligns with your specifications and requirements. Kindly inform us of your preferred method for proceeding with this business transaction. Alternatively, should revisions be necessary, please advise us on the requisite changes, and we will promptly share the cost quotation to meet your needs.</p> <p>&nbsp;</p> <p>Please do visit our official website for more details.</p> <p><a href=\"https://www.briskelevators.in\" style=\"color:#16a34a;text-decoration:none;\">www.briskelevators.in</a></p> <p>&nbsp;</p> <p>We look forward to your response and the prospect of establishing a valuable business relationship. We look forward to hearing from you in understanding better and valued business and connections.</p> <p>&nbsp;</p> <p style=\"color:#16a34a;\">We once again thank you for considering us for your requirement and look forward to receiving your order</p> <p>&nbsp;</p> <p>Yours sincerely</p> <p>&nbsp;</p> <p><b>Pavan Nagaraj</b><br> Sales Coordinator<br> +919611133977</p> <p>&nbsp;</p> <img src=\"https://neuralshaft.com/src/assets/mail_template_footer.png\" alt=\"Brisk Elevators Footer\" style=\"max-width:100%;height:auto;display:block;\"> <p>&nbsp;</p> <p><b>Brisk Elevators &amp; Escalators Pvt Ltd</b></p> <p>No. 456, 10th Main Road, 3rd Stage, Basaveshwaranagar Main Road, Bengaluru - 560079</p> <p><b>Office No</b> | +91 80 23238661 | <b>Tollfree</b> - 1800 313 628 | <b>Mobile</b> - +91 91483 78672.</p> <p>Email : <a href=\"mailto:lift@briskelevators.in\" style=\"color:#1d4ed8;\">lift@briskelevators.in</a> | Web : <a href=\"https://www.briskelevators.in\" style=\"color:#1d4ed8;\">www.briskelevators.in</a>.</p> <p>&nbsp;</p> <p style=\"font-size:11px;color:#444;line-height:1.6;\"> The contents of this document are for informational purposes only and are subject to change without notice. Brisk Elevators &amp; Escalators Pvt Ltd makes no guarantee, representations or warranties with regard to the enclosed information and specifically disclaims, to the full extent of the law, any applicable implied warranties, such as fitness for a particular purpose, merchantability, satisfactory quality or reasonable skill and care. The usage of any Brisk Elevators &amp; Escalators Pvt Ltd shall be pursuant to the applicable end user agreement. Copyright 2026 Brisk Elevators &amp; Escalators Pvt Ltd. All rights reserved. </p> </div>";

//List<IFormFile> attach = new List<IFormFile>();

//attach.Add("D:\\images\\56_lift 2.jpeg");gt
//attach.Add("D:\\images\\OrderForm.pdf");

//request.Attachments = attach;

/// ==================================================
//await _emailService.SendEmailAsync(
//        toMail,
//        subject,
//        request.body,         // <-- pass HTML body directly
//        Files
//);
/// 

//public async Task<IActionResult> SendMail(string toMail, string subject, string body, [FromBody] MailRequest request, [FromForm] List<IFormFile> Files, int enqHdrId)


//public async Task<IActionResult> SendMail([FromBody] MailRequest request, [FromForm] List<IFormFile> Files)

//public class MailRequest
//{
//    public string ToEmail { get; set; }
//    public string Subject { get; set; }
//    public string Body { get; set; }
//}


//public async Task<IActionResult> SendMail([FromBody] MailRequest request)
//{
//    //await _emailService.SendEmailAsync(request.ToEmail, request.Subject, request.Body);
//    request.ToEmail = "paidakal@gmail.com";
//    request.Subject = "Testing";
//    //request.Body = "<div style=\"font-family:Arial,sans-serif;font-size:13px;line-height:1.75;color:#222;max-width:700px;\"> <p>Dear <b>Brisk</b> ,</p> <p>&nbsp;</p> <p>Ref. - Conversation with <b>Pavan Nagaraj.</b></p> <p>&nbsp;</p> <p>We would like to Introduce ourselves that we Brisk Elevators &amp; Escalators Pvt Ltd are leading Manufacturer and supplier of a wide range of Excellence-driven Home Lift, MRL Lift, MR Lift, Goods Lift, Hospital Lift, Glass Capsule Lift.</p> <p>&nbsp;</p> <p>We are one of the trusted <b>Home Elevators</b> in the industry with <b>CE Certified, EN 81 Standards</b> with <b>150+ Safety Parameters</b> and also have Collaboration with <b>GMV MARTINI S.p.A.,</b> Italy Italian multinational leader in the lift industry, with a company history of more than <b>50 years</b>. More than <b>815,000</b> lift systems all over the world (spread over 5 continents) use made-in-Italy GMV Products.</p> <p>&nbsp;</p> <p>With over 12 years of extensive experience in the vertical transport system sector, we have cultivated a satisfied clientele across diverse market segments. Our range of elevators is installed in Homes, Offices, Commercial Spaces, Industries, Educational Institutes, Healthcare Services, and the Hospitality Sector, supported by a team of dedicated experts and professionals.</p> <p>&nbsp;</p> <p>We appreciate the opportunity to speak with you and in our conversation, we discussed your mobility needs and how Brisk Elevators &amp; Escalators Pvt Ltd can help with the Elevator solution.</p> <p>&nbsp;</p> <p>We trust that the attached product details aligns with your specifications and requirements. Kindly inform us of your preferred method for proceeding with this business transaction. Alternatively, should revisions be necessary, please advise us on the requisite changes, and we will promptly share the cost quotation to meet your needs.</p> <p>&nbsp;</p> <p>Please do visit our official website for more details.</p> <p><a href=\"https://www.briskelevators.in\" style=\"color:#16a34a;text-decoration:none;\">www.briskelevators.in</a></p> <p>&nbsp;</p> <p>We look forward to your response and the prospect of establishing a valuable business relationship. We look forward to hearing from you in understanding better and valued business and connections.</p> <p>&nbsp;</p> <p style=\"color:#16a34a;\">We once again thank you for considering us for your requirement and look forward to receiving your order</p> <p>&nbsp;</p> <p>Yours sincerely</p> <p>&nbsp;</p> <p><b>Pavan Nagaraj</b><br> Sales Coordinator<br> +919611133977</p> <p>&nbsp;</p> <img src=\"https://neuralshaft.com/assets/mail_template_footer-CRdZ_7Zu.png\" alt=\"Brisk Elevators Footer\" style=\"max-width:100%;height:auto;display:block;\"> <p>&nbsp;</p> <p><b>Brisk Elevators &amp; Escalators Pvt Ltd</b></p> <p>No. 456, 10th Main Road, 3rd Stage, Basaveshwaranagar Main Road, Bengaluru - 560079</p> <p><b>Office No</b> | +91 80 23238661 | <b>Tollfree</b> - 1800 313 628 | <b>Mobile</b> - +91 91483 78672.</p> <p>Email : <a href=\"mailto:lift@briskelevators.in\" style=\"color:#1d4ed8;\">lift@briskelevators.in</a> | Web : <a href=\"https://www.briskelevators.in\" style=\"color:#1d4ed8;\">www.briskelevators.in</a>.</p> <p>&nbsp;</p> <p style=\"font-size:11px;color:#444;line-height:1.6;\"> The contents of this document are for informational purposes only and are subject to change without notice. Brisk Elevators &amp; Escalators Pvt Ltd makes no guarantee, representations or warranties with regard to the enclosed information and specifically disclaims, to the full extent of the law, any applicable implied warranties, such as fitness for a particular purpose, merchantability, satisfactory quality or reasonable skill and care. The usage of any Brisk Elevators &amp; Escalators Pvt Ltd shall be pursuant to the applicable end user agreement. Copyright 2026 Brisk Elevators &amp; Escalators Pvt Ltd. All rights reserved. </p> </div>";
//    request.Body = "<div style=\"font-family:Arial,sans-serif;font-size:13px;line-height:1.75;color:#222;max-width:700px;\"> <p>Dear <b>Brisk</b> ,</p> <p>Ref. - Conversation with <b>Pavan Nagaraj.</b></p> <p>&nbsp;</p> <p>We would like to Introduce ourselves that we Brisk Elevators &amp; Escalators Pvt Ltd are leading Manufacturer and supplier of a wide range of Excellence-driven Home Lift, MRL Lift, MR Lift, Goods Lift, Hospital Lift, Glass Capsule Lift.</p> <p>&nbsp;</p> <p>We are one of the trusted <b>Home Elevators</b> in the industry with <b>CE Certified, EN 81 Standards</b> with <b>150+ Safety Parameters</b> and also have Collaboration with <b>GMV MARTINI S.p.A.,</b> Italy Italian multinational leader in the lift industry, with a company history of more than <b>50 years</b>. More than <b>815,000</b> lift systems all over the world (spread over 5 continents) use made-in-Italy GMV Products.</p> <p>&nbsp;</p> <p>With over 12 years of extensive experience in the vertical transport system sector, we have cultivated a satisfied clientele across diverse market segments. Our range of elevators is installed in Homes, Offices, Commercial Spaces, Industries, Educational Institutes, Healthcare Services, and the Hospitality Sector, supported by a team of dedicated experts and professionals.</p> <p>&nbsp;</p> <p>We appreciate the opportunity to speak with you and in our conversation, we discussed your mobility needs and how Brisk Elevators &amp; Escalators Pvt Ltd can help with the Elevator solution.</p> <p>&nbsp;</p> <p>We trust that the attached product details aligns with your specifications and requirements. Kindly inform us of your preferred method for proceeding with this business transaction. Alternatively, should revisions be necessary, please advise us on the requisite changes, and we will promptly share the cost quotation to meet your needs.</p> <p>&nbsp;</p> <p>Please do visit our official website for more details.</p> <p><a href=\"https://www.briskelevators.in\" style=\"color:#16a34a;text-decoration:none;\">www.briskelevators.in</a></p> <p>&nbsp;</p> <p>We look forward to your response and the prospect of establishing a valuable business relationship. We look forward to hearing from you in understanding better and valued business and connections.</p> <p>&nbsp;</p> <p style=\"color:#16a34a;\">We once again thank you for considering us for your requirement and look forward to receiving your order</p> <p>&nbsp;</p> <p>Yours sincerely</p> <p>&nbsp;</p> <p><b>Pavan Nagaraj</b><br> Sales Coordinator<br> +919611133977</p> <p>&nbsp;</p> <img src=\"https://neuralshaft.com/src/assets/mail_template_footer.png\" alt=\"Brisk Elevators Footer\" style=\"max-width:100%;height:auto;display:block;\"> <p>&nbsp;</p> <p><b>Brisk Elevators &amp; Escalators Pvt Ltd</b></p> <p>No. 456, 10th Main Road, 3rd Stage, Basaveshwaranagar Main Road, Bengaluru - 560079</p> <p><b>Office No</b> | +91 80 23238661 | <b>Tollfree</b> - 1800 313 628 | <b>Mobile</b> - +91 91483 78672.</p> <p>Email : <a href=\"mailto:lift@briskelevators.in\" style=\"color:#1d4ed8;\">lift@briskelevators.in</a> | Web : <a href=\"https://www.briskelevators.in\" style=\"color:#1d4ed8;\">www.briskelevators.in</a>.</p> <p>&nbsp;</p> <p style=\"font-size:11px;color:#444;line-height:1.6;\"> The contents of this document are for informational purposes only and are subject to change without notice. Brisk Elevators &amp; Escalators Pvt Ltd makes no guarantee, representations or warranties with regard to the enclosed information and specifically disclaims, to the full extent of the law, any applicable implied warranties, such as fitness for a particular purpose, merchantability, satisfactory quality or reasonable skill and care. The usage of any Brisk Elevators &amp; Escalators Pvt Ltd shall be pursuant to the applicable end user agreement. Copyright 2026 Brisk Elevators &amp; Escalators Pvt Ltd. All rights reserved. </p> </div>";

//    List<string> attach = new List<string>();

//    attach.Add("D:\\images\\52_Lift1.jpeg");
//    attach.Add("D:\\images\\OrderForm.pdf");

//    request.Attachments = attach;

//    await _emailService.SendEmailAsync(
//            request.ToEmail,
//            request.Subject,
//            request.Body,         // <-- pass HTML body directly
//            request.Attachments
//    );
//    return Ok(new { Message = "Email sent successfully" });

//    //return Ok(new { Message = "Email sent successfully" });
//}