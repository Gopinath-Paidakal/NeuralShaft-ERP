using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using MimeKit;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;
using System.Text;
using SmtpClient = MailKit.Net.Smtp.SmtpClient;
using Microsoft.AspNetCore.Hosting;


namespace NeuralShaft.Shared.EMail
{
    public class EMailService
    {
        private readonly SmtpSettings _settings;
        //private readonly IWebHostEnvironment _env;


        public EMailService(IOptions<SmtpSettings> settings)
        {
            _settings = settings.Value;
            //_env = env;
        }
        

        public async Task SendEmailAsync(string toEmail, string subject, string htmlBody, List<string> attachments)
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(_settings.SenderName, _settings.SenderEmail));
            message.To.Add(MailboxAddress.Parse(toEmail));
            message.Subject = subject;

            var builder = new BodyBuilder
            {
                HtmlBody = htmlBody,   // <-- HTML string from React
                TextBody = "Please view this email in an HTML-compatible client."
            };

            // Attachments (PDF, Word, etc.)
            if (attachments != null)
            {
                foreach (var filePath in attachments)
                {
                    builder.Attachments.Add(filePath);
                }
            }

            // Example: Inline image referenced in HTML with <img src="cid:companyLogo">
            //var logo = builder.LinkedResources.Add("C:\\images\\logo.png");
            //var logo = builder.LinkedResources.Add("D:\\images\\52_Lift1.jpeg");
            //logo.ContentId = "companyLogo";

            message.Body = builder.ToMessageBody();

            using var client = new SmtpClient();
            await client.ConnectAsync(_settings.Server, _settings.Port, SecureSocketOptions.StartTls);
            await client.AuthenticateAsync(_settings.Username, _settings.Password);
            await client.SendAsync(message);
            await client.DisconnectAsync(true);
        }

        //public async Task SendEmailAsync(string toEmail, string subject, string body)
        //{
        //    var message = new MimeMessage();
        //    message.From.Add(new MailboxAddress(_settings.SenderName, _settings.SenderEmail));
        //    message.To.Add(MailboxAddress.Parse(toEmail));
        //    message.Subject = subject;

        //    string htmlBody = body;

        //    var builder = new BodyBuilder { HtmlBody = htmlBody };
        //    message.Body = builder.ToMessageBody();
             

        //    //mailMessage.IsBodyHtml = true;

        //    //var builder = new BodyBuilder
        //    //{
        //    //    HtmlBody = htmlBody,
        //    //    //TextBody = "Please view this email in an HTML-compatible client."
        //    //};



        //    // Add attachments (PDF, Word, etc.)
        //    //if (attachments != null)
        //    //{
        //    //    foreach (var filePath in attachments)
        //    //    {
        //    //        builder.Attachments.Add(filePath);
        //    //    }
        //    //}

        //    // Example: Inline image
        //    //var image = builder.LinkedResources.Add("C:\\images\\logo.png");
        //    //image.ContentId = "companyLogo";

        //    //message.Body = builder.ToMessageBody();


        //    //message.Body = new MultipartAlternative
        //    //{
        //    //    new TextPart("plain") { Text = "Fallback plain text" },
        //    //    new TextPart("html") { Text = body }
        //    //};


        //    //message.Body = new TextPart("html")
        //    //{
        //    //    Text = body
        //    //};

        //    using var client = new SmtpClient();
        //    await client.ConnectAsync(_settings.Server, _settings.Port, SecureSocketOptions.StartTls);
        //    await client.AuthenticateAsync(_settings.Username, _settings.Password);
        //    await client.SendAsync(message);
        //    await client.DisconnectAsync(true);
        //}

        // Others - copilot
        //public async Task SendEmailAsync(string toEmail, string subject, string body)
        //{
        //    using var client = new SmtpClient(_settings.Server, _settings.Port)
        //    {
        //        Credentials = new NetworkCredential(_settings.Username, _settings.Password),
        //        EnableSsl = _settings.EnableSsl
        //    };

        //    var mailMessage = new MailMessage
        //    {
        //        From = new MailAddress(_settings.SenderEmail, _settings.SenderName),
        //        Subject = subject,
        //        Body = body,
        //        IsBodyHtml = true
        //    };

        //    mailMessage.To.Add(toEmail);

        //    await client.SendMailAsync(mailMessage);
        //}

        //public class SmtpSettings
        //{
        //    public string Server { get; set; }
        //    public int Port { get; set; }
        //    public string SenderName { get; set; }
        //    public string SenderEmail { get; set; }
        //    public string Username { get; set; }
        //    public string Password { get; set; }
        //    public bool EnableSsl { get; set; }
        //}
    }
}


//public class SmtpSettings
//{
//    public string Server { get; set; }
//    public int Port { get; set; }
//    public string SenderName { get; set; }
//    public string SenderEmail { get; set; }
//    public string Username { get; set; }
//    public string Password { get; set; }
//    public bool EnableSsl { get; set; }
//}


///// --- Saving the Attached File
//var uploadedFiles = new List<string>();

////if (files == null || files.Count == 0)
////    return uploadedFiles;

//string uploadPath = Path.Combine(_env.ContentRootPath, "Upload");
////string webRootPath = (_env.WebRootPath.ToString());

//Console.WriteLine(_env.ContentRootPath.ToString());

//if (!Directory.Exists(uploadPath))
//    Directory.CreateDirectory(uploadPath);

//foreach (var file in files)
//{
//    if (file.Length > 0)
//    {
//        var fileName = enqHdrId + "_" + file.FileName;
//        //var fileName = "108_" + Path.GetExtension(file.FileName);
//        //var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
//        var filePath = Path.Combine(uploadPath, fileName);

//        using (var stream = new FileStream(filePath, FileMode.Create))
//        {
//            await file.CopyToAsync(stream);
//        }
//        uploadedFiles.Add(fileName);
//    }
//}