DECLARE @FromDate DATE = '2026-04-28'
DECLARE @ToDate   DATE = '2026-04-28'

SELECT *
FROM EnqHdr
WHERE EnqDate >= @FromDate
AND EnqDate < DATEADD(DAY, 1, @ToDate)


Exec SP_GetEnqFollowUp_ByUserId 15
