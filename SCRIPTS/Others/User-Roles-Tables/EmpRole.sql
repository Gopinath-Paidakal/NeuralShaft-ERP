CREATE TABLE EmpRole
(
    EmpRoleId           INT IDENTITY(1,1) PRIMARY KEY,
    EmpId               INT,
    RoleId              INT,

    CreatedUserId       INT,
    CreatedDate         DATETIME DEFAULT GETDATE(),

    --CONSTRAINT FK_EmployeeRole_Employee
    --    FOREIGN KEY (EmpId) REFERENCES Employee(EmpId),

    --CONSTRAINT FK_EmployeeRole_Roles
    --    FOREIGN KEY (RoleId) REFERENCES Roles(EmpRoleId)
);