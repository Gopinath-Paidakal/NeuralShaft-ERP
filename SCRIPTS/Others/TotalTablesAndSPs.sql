USE [NSERPLIVE]
GO

SELECT
    (SELECT COUNT(*) FROM sys.tables) AS TotalTables,
    (SELECT COUNT(*) FROM sys.procedures) AS TotalStoredProcedures;