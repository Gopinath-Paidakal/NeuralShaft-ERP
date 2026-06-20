CREATE TABLE UserLoginHistory
(
    LoginId             INT IDENTITY(1,1) PRIMARY KEY,
    EmpId               INT,
    LoginTime           DATETIME,
    LogoutTime          DATETIME,
    IpAddress           NVARCHAR(100),
    DeviceInfo          NVARCHAR(500)
);