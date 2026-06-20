USE [NSHAFTERPDB]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FormatDateTime]    Script Date: 15-04-2026 11:05:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_FormatDateTime]
(
    @InputDate DATETIME
)
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN FORMAT(
        @InputDate AT TIME ZONE 'UTC'
        AT TIME ZONE 'India Standard Time',
        'dd-MM-yyyy'   -- HH:mm:ss'
    )
END
GO


