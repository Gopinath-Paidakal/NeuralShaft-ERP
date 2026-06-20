USE [NSHAFTERPDB]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FormatUTCToISTDate]    Script Date: 15-04-2026 10:55:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_FormatDate]
(
    @InputDate DATETIME
)
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN FORMAT(
        @InputDate AT TIME ZONE 'UTC'
        AT TIME ZONE 'India Standard Time',
        'dd-MM-yyyy'
    )
END
GO


