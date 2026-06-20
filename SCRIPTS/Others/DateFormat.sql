SELECT 
    FORMAT(EnqDate, 'dd-MM-yyyy') AS OnlyDate,
    FORMAT(EnqDate, 'HH:mm:ss')   AS OnlyTime
FROM EnqHdr;