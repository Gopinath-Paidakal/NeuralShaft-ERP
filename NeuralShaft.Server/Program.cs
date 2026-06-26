using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi;
using NeuralShaft.Repository.RepoImplementation;
using NeuralShaft.Repository.RepoInterfaces;
using NeuralShaft.Service.EMail;
using NeuralShaft.Service.ServiceImplementation;
using NeuralShaft.Service.ServiceImplementation.CRM;
using NeuralShaft.Service.ServiceImplementation.Enquiry;
using NeuralShaft.Service.ServiceImplementation.JobOrder;
using NeuralShaft.Service.ServiceImplementation.Login;
using NeuralShaft.Service.ServiceImplementation.Masters;
using NeuralShaft.Service.ServiceImplementation.OrderApprove;
using NeuralShaft.Service.ServiceImplementation.Previlege;
using NeuralShaft.Service.ServiceImplementation.Quotation;
using NeuralShaft.Service.ServiceImplementation.SalesOrder;
using NeuralShaft.Service.ServiceImplementation.Upload;
using NeuralShaft.Service.ServiceInterfaces;
using NeuralShaft.Service.ServiceInterfaces.CRM;
using NeuralShaft.Service.ServiceInterfaces.Enquiry;
using NeuralShaft.Service.ServiceInterfaces.JobOrder;
using NeuralShaft.Service.ServiceInterfaces.Login;
using NeuralShaft.Service.ServiceInterfaces.Masters;
using NeuralShaft.Service.ServiceInterfaces.OrderApprove;
using NeuralShaft.Service.ServiceInterfaces.Previlege;
using NeuralShaft.Service.ServiceInterfaces.Quotation;
using NeuralShaft.Service.ServiceInterfaces.SalesOrder;
using NeuralShaft.Service.ServiceInterfaces.Upload;
//using NeuralShaft.Shared.Hubs;
using NeuralShaft.Data;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//---- --------  DEPENDENCY INJECTION IMPLEMENTED BY CORE API --------------------------
// --- Database Connection
builder.Services.AddSingleton<DbConnection>();

// === JSON Generic Repository for all db data
builder.Services.AddScoped<IJsonRepository, JsonRepository>();

// === Login 
builder.Services.AddScoped<ILogin, LoginService>();

// === Notification
//builder.Services.AddScoped<INotification, NotificationService>();
builder.Services.AddSignalR();

//---- Masters
builder.Services.AddScoped<ICompany, CompanyService>();
builder.Services.AddScoped<IBranch, BranchService>();
builder.Services.AddScoped<IEmployee, EmployeeService>();
builder.Services.AddScoped<IDefaultData, DefaltDataService>();
builder.Services.AddScoped<IEmployee, EmployeeService>();
builder.Services.AddScoped<IOrdClient, OrdClientService>();
builder.Services.AddScoped<IItem, ItemService>();
builder.Services.AddScoped<IBOM, BOMService>();
builder.Services.AddScoped<IFile, FileService>();

builder.Services.AddScoped<IDepartment, DepartmentService>();
builder.Services.AddScoped<IDesignation, DesignationService>();
builder.Services.AddScoped<IGrade, GradeService>();
builder.Services.AddScoped<IHoliday, HolidayService>();
builder.Services.AddScoped<IMenus, MenuService>();
builder.Services.AddScoped<IMenuPermissions, MenuPermissionService>();
builder.Services.AddScoped<IContact, ContactService>();

// -------- Upload Files
builder.Services.AddScoped<IUpload, UploadService>();
/// --- Required for download
builder.Services.AddHttpContextAccessor();
//builder.Services.AddScoped<FileService>();
//builder.Services.AddSingleton<AppState>();

//  ----- Enquiry
builder.Services.AddScoped<IEnquiry, EnquiryService>();
builder.Services.AddScoped<IEnqClient, EnqClientService>();

// --- Enquiry FollowUp
builder.Services.AddScoped<IEnqFollowUp, EnqFollowUpService>();

//---- Quotation
builder.Services.AddScoped<IQuoteService, QuoteService>();

//--- Order Approve
builder.Services.AddScoped<IOrdApprove, OrdApproveService>();

//--- Sales Order
builder.Services.AddScoped<ISalesOrder, SalesOrderService>();

//--- Job Order
builder.Services.AddScoped<IJobOrder, JobOrderService>();

//--- CRM
builder.Services.AddScoped<IDefaultDataDocs, DefaultDataDocsService>();
builder.Services.AddScoped<ICRMDocs, CRMDocsService>();
builder.Services.AddScoped<IPVR, PVRService>();
builder.Services.AddScoped<ISVR, SVRService>();
builder.Services.AddScoped<ISCR, SCRService>();
builder.Services.AddScoped<IPTC, PTCService>();

//----- SMTP Setting for email services
builder.Services.Configure<SmtpSettings>(
    builder.Configuration.GetSection("SmtpSettings"));

// Register EmailService
builder.Services.AddTransient<EMailService>();


////////////////////////////////////////////////single domain -CORS - Cross - origin resource sharing 
//builder.Services.AddCors(p => p.AddPolicy("AllowAll", build =>
//{
//    // build.WithOrigins("http://192.168.1.0:5000", "http://localhost:5000", "192.168.1.43:5173:5173").AllowAnyMethod().AllowAnyHeader();
//    //build.WithOrigins("http://0.0.0.0:5143").AllowAnyOrigin();
//    build.WithOrigins("http://0.0.0.0:5173").AllowAnyMethod().AllowAnyHeader();


//}
//));

builder.Services.AddControllers()
    .AddJsonOptions(options =>
     {
         options.JsonSerializerOptions.WriteIndented = true;
     });

//builder.Services.AddControllers().AddJsonOptions(options =>
//{
//    // Increase the maximum depth if your JSON is very nested
//    options.JsonSerializerOptions.MaxDepth = 128;
//});

// Original 
//builder.Services.AddCors(options =>
//{
//    options.AddPolicy("AllowAll",
//        policy => policy.AllowAnyOrigin()
//                        .AllowAnyMethod()
//                        .AllowAnyHeader());

//});

//  -- Created for SignalR for a particular Origin
builder.Services.AddCors(options =>
{
options.AddPolicy("AllowAll",
    policy => policy.WithOrigins("http://192.168.1.0:5173", "http://192.168.1.123:5173",
                                 "http://192.168.1.52:5173", "http://localhost:5173")  //45-Gopi //43-Jeevitha //, "https://neuralshaft.com")
                    .AllowAnyMethod()
                    .AllowAnyHeader());

});

//builder.Services.AddControllers();

//builder.Services.AddCors(options =>
//{
//    options.AddPolicy("AllowAll", b => b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
//});

builder.Services.AddRateLimiter(p => p.AddFixedWindowLimiter(policyName: "fixedwindow", options =>
{
    options.Window = TimeSpan.FromSeconds(10);
    options.PermitLimit = 1;
    options.QueueLimit = 1;
    options.QueueProcessingOrder = System.Threading.RateLimiting.QueueProcessingOrder.OldestFirst;
}).RejectionStatusCode = 401);

//---------- Checking for local files



// Increase Kestrel Limits
builder.WebHost.ConfigureKestrel(options =>
{
    // The default is 30MB; if your JSON is massive, increase this
    options.Limits.MaxRequestBodySize = 100 * 1024 * 1024; // 100MB

    // Limits the rate at which data is read/written
    options.Limits.MinRequestBodyDataRate = null;
    options.Limits.MinResponseDataRate = null;
});

//builder = WebApplication.CreateBuilder("http://192.168.1.54:5143");

//---------- Checking for local files

var app = builder.Build();

////  === for retreiving the images for Enquiry
// Serve static files from wwwroot by default
//////app.UseStaticFiles();
//////// Map your custom folder
//////app.UseStaticFiles(new StaticFileOptions
//////{
//////    FileProvider = new PhysicalFileProvider(
//////            //Path.Combine(@"C:\Images\Enquiry")),
//////            Path.Combine(@"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.Server\UploadNew\Images\Enquiry")),
//////    //Path.Combine(@"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.RunTime\Debug\net10.0\Images")),
//////    RequestPath = "/images/enquiry"
//////});
//////// =========================================
///

//app.UseStaticFiles(); // wwwroot

//app.UseStaticFiles(new StaticFileOptions
//{
//    FileProvider = new PhysicalFileProvider(
//            //Path.Combine(@"C:\Images\Enquiry")),
//            Path.Combine("/var/www/backend/UploadNew/Images/Enquiry")),
//    //Path.Combine(@"D:\NEURALSHAFT\BackEnd\NEURAL-SHAFT-ERP\NeuralShaft.RunTime\Debug\net10.0\Images")),
//    RequestPath = "/Images/Enquiry"
//});

//app.UseStaticFiles(new StaticFileOptions
//{
//    FileProvider = new PhysicalFileProvider(
//        //Path.Combine(url, "UploadNew", "Images", "Enquiry")),
//        Path.Combine(app.Environment.ContentRootPath, "UploadNew", "Images", "Enquiry")),
//        //Path.Combine("/var/www/uploads/enquiry/")),
//    RequestPath = "/Images/Enquiry"
//    //RequestPath = "/uploads/enquiry/"
//});


///////////////////// Configure forwarded headers and trust the local Nginx proxy on 127.0.0.1//////////////////
var forwardedHeadersOptions = new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
};


//////////////////////////// If Nginx runs on the same host, add the loopback address as a known proxy//////////////////////////
///
forwardedHeadersOptions.KnownProxies.Clear();

forwardedHeadersOptions.KnownProxies.Add(IPAddress.Parse("127.0.0.1"));

app.UseForwardedHeaders(forwardedHeadersOptions);

// --- Configure HTTPS redirection to use port 443 explicitly ---

//app.UseHttpsRedirection(new HttpsRedirectionOptions

//{
//    HttpsPort = 443
//});

//builder.WebHost.ConfigureKestrel(serverOptions =>
//{
//    serverOptions.Limits.MaxRequestBodySize = 104857600; // 100 MB
//});

app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        context.Response.StatusCode = StatusCodes.Status500InternalServerError;
        context.Response.ContentType = "application/json";

        var exceptionFeature = context.Features.Get<IExceptionHandlerPathFeature>();

        var result = new
        {
            Message = exceptionFeature?.Error?.Message,
            Path = exceptionFeature?.Path,
            ExceptionType = exceptionFeature?.Error?.GetType().Name
        };

        await context.Response.WriteAsJsonAsync(result);
    });
});

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseCors("AllowFrontend");
app.UseCors("AllowAll");

app.UseRouting();
app.UseRateLimiter();
app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// For Notification
//app.MapHub<NotificationHub>("/NotificationHub");


// Ensure it listens on port 5000 (matching your Nginx config)
app.Run();



































































//builder.Services.AddScoped<IDepartmentService, DepartmentService>();
//builder.Services.AddScoped<IDepartmentRepository, DepartmentRepository>();


//builder.Services.AddScoped<IEnquiryRepository, EnquiryRepository>();
//builder.Services.AddScoped<IFormDefaultDataRepository, FormDefaultDataRepository>();


//app.UseExceptionHandler(errorApp =>
//{
//    errorApp.Run(async context =>
//    {
//        context.Response.StatusCode = 500;
//        context.Response.ContentType = "application/json";

//        var exception =
//            context.Features.Get<Microsoft.AspNetCore.Diagnostics.IExceptionHandlerPathFeature>();

//        await context.Response.WriteAsJsonAsync(new
//        {
//            Message = exception?.Error?.Message
//        });
//    });
//});
