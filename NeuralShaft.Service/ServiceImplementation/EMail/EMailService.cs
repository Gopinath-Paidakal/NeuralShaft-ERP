using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using MimeKit;
using NeuralShaft.Service.ServiceInterfaces.Upload;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;
using System.Text;
using static System.Net.WebRequestMethods;
using SmtpClient = MailKit.Net.Smtp.SmtpClient;


namespace NeuralShaft.Service.EMail
{
    public class EMailService
    {
        private readonly SmtpSettings _settings;
        private readonly IWebHostEnvironment _env;
        private readonly IUpload _uploadService;
        private readonly IConfiguration _configuration;


        string savePath = "/uploads/company_profile/";

        public EMailService(IOptions<SmtpSettings> settings, IWebHostEnvironment env, IUpload upload)
        {
            _settings = settings.Value;
            _env = env;
            _uploadService = upload;
        }

        public async Task SendEmailAsync(string toEmail, string subject, string htmlBody, string Cc, bool compProfile1, bool compProfile2, List<IFormFile> attachments)
        {
                var message = new MimeMessage();
                //message.From.Add(MailboxAddress.Parse("test@gmail.com"));
                message.From.Add(new MailboxAddress(_settings.SenderName, _settings.SenderEmail));
                message.To.Add(MailboxAddress.Parse(toEmail));

                //if (Cc != null)
                if (!string.IsNullOrWhiteSpace(Cc))
                {
                    message.Cc.Add(MailboxAddress.Parse(Cc));
                }
                //else
                //{
                //    message.Cc.Add(MailboxAddress.Parse(string.Empty));
                //}

                message.Subject = subject;

                //-------- Download company profile from the server
                //var downloadFiles = await _uploadService.DownloadFilesAsync(savePath);
                //var downloadFiles = await _uploadService.DownloadFilesAsync("D:\\uploads\\company_profile\\");   

                var builder = new BodyBuilder();

                builder.HtmlBody = htmlBody;

                if (attachments != null)
                {
                    foreach (var file in attachments)
                    {
                        if (file.Length > 0)
                        {
                            var ms = new MemoryStream();
                            await file.CopyToAsync(ms);
                            ms.Position = 0;
                            builder.Attachments.Add(file.FileName, ms, ContentType.Parse(file.ContentType));
                        }
                    }
                }


            // 1. Sanitize the incoming file name to prevent directory traversal attacks
            string safeFileName = Path.GetFileName("Brisk_Profile.pdf");

            // 2. Resolve the path relative to where your API binary is running
            string appRoot = AppContext.BaseDirectory;
            //string relativeUploadPath = _config["FileStorageSettings:UploadsBasePath"];
            string relativeUploadPath = _configuration["FileSettings:UploadPath"];

            // This combines your app's directory with the relative path to company_profile
            string filePath = Path.GetFullPath(Path.Combine(appRoot, relativeUploadPath, safeFileName));


            //string filePath = Path.Combine(_env.WebRootPath, "vouchers", fileName);
            //string filePath = Path.Combine(_env.WebRootPath, "/uploads/company_profile/", "Brisk_Profile.pdf");
            //string filePath = Path.Combine(_env.ContentRootPath, "/backend/", "Brisk_Profile.pdf");
            //if (!System.IO.File.Exists(filePath))
            //{
            //    throw new FileNotFoundException($"The file {"Brisk_Profile.pdf"} was not found on the server.");
            //}
            //builder.Attachments.Add(filePath);



            //List<string> fileUrls = new List<string>
            //{    

            //        "https://neuralshaft.com/upload/company_profile/Brisk_Profile.pdf",    // Not Working
            //        "https://neuralshaft.com/upload/company_profile/GLT_Omega.pdf"
            //        //"https://abc.com/upload/profile/c.pdf"

            //        //"https://var/www/backend/Brisk_Profile.pdf"   // error - no such host 
            //        //"D:\\NEURALSHAFT\\BackEnd\\NEURAL-SHAFT-ERP\\NeuralShaft.RunTime\\Debug\\net10.0\\linux-x64\\Brisk_Profile.pdf"  // 500 file scheme is not supported
            //};

            //using HttpClient httpClient = new HttpClient();

            //foreach (string fileUrl in fileUrls)
            //{
            //    byte[] fileBytes = await httpClient.GetByteArrayAsync(fileUrl);

            //    string fileName = Path.GetFileName(new Uri(fileUrl).LocalPath);

            //    builder.Attachments.Add(fileName, fileBytes);
            //}

            message.Body = builder.ToMessageBody();

                using var smtp = new SmtpClient();

                //await smtp.ConnectAsync("smtp.gmail.com", 587, false);
                await smtp.ConnectAsync(_settings.Server, _settings.Port, SecureSocketOptions.StartTls);
                        
                //await smtp.AuthenticateAsync(
                //    "test@gmail.com",
                //    "password");

                // Pass the values SenderName, Password google SMTP
                //await smtp.AuthenticateAsync("neuralshaft@gmail.com","axhhcsaoicmyudgg");

                await smtp.AuthenticateAsync(_settings.Username, _settings.Password);

                await smtp.SendAsync(message);
            
                await smtp.DisconnectAsync(true);
            }
    
    }
}


//if (!string.IsNullOrWhiteSpace(Cc))
//{
//    foreach (var cc in Cc.Split(','))
//    {
//        if (!string.IsNullOrWhiteSpace(cc))
//        {
//            message.Cc.Add(MailboxAddress.Parse(cc.Trim()));
//        }
//    }
//}

//public async Task SendEmailAsync(string toEmail, string subject, string htmlBody, List<IFormFile> attachments)  25-05-2026
//    {   
//        //using MemoryStream ms = new MemoryStream();
//        var message = new MimeMessage();
//        message.From.Add(new MailboxAddress(_settings.SenderName, _settings.SenderEmail));
//        message.To.Add(MailboxAddress.Parse(toEmail));
//        message.Subject = subject;


//        var builder = new BodyBuilder
//        {
//            HtmlBody = htmlBody,   // <-- HTML string from React
//            TextBody = "Please view this email in an HTML-compatible client."
//        };

//        // ---------- Attachments -- Not working
//        if (attachments != null && attachments.Count > 0)
//        {
//            foreach (var file in attachments)
//            {
//                if (file.Length > 0)
//                {
//                    var extension = Path.GetExtension(file.FileName).ToLowerInvariant();
//                    using var ms = new MemoryStream();
//                    await file.CopyToAsync(ms);

//                    // There is a problem of attaching jpeg, in mail it is getting attached,
//                    // but not displaying. pdf files are attached and displaying.

//                    if (extension == ".jpg" || extension == ".jpeg")
//                    {
//                        // Inline JPEG image
//                        var image = new MimePart("image", "jpeg")
//                        {
//                            Content = new MimeContent(ms, ContentEncoding.Default),
//                            ContentId = Path.GetFileNameWithoutExtension(file.FileName),
//                            //ContentId = file.FileName,
//                            FileName = file.FileName,
//                            IsAttachment = false
//                        };
//                        builder.LinkedResources.Add(image);
//                    }
//                    else if (extension == ".pdf")
//                    {
//                        // PDF attachment
//                        var pdf = new MimePart("application", "pdf")
//                        {
//                            Content = new MimeContent(ms, ContentEncoding.Default),
//                            FileName = file.FileName,
//                            IsAttachment = true
//                        };
//                        builder.Attachments.Add(pdf);
//                    }
//                }
//            }
//        }

//        message.Body = builder.ToMessageBody();

//        using var client = new SmtpClient();
//        await client.ConnectAsync(_settings.Server, _settings.Port, SecureSocketOptions.StartTls);
//        await client.AuthenticateAsync(_settings.Username, _settings.Password);
//        await client.SendAsync(message);
//        await client.DisconnectAsync(true);
//    }




//===========================================
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

//=============================================

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