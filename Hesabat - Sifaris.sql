USE [BazarlamaHesabatDB]

IF OBJECT_ID('tempdb..#Report104') IS NOT NULL
    DROP TABLE #Report104;

CREATE TABLE #Report104
(
    RegionType NVARCHAR(100),
    Code NVARCHAR(50),
    Name NVARCHAR(200),
    ContragentCode NVARCHAR(50),
    ContragentName NVARCHAR(200),
    TotalOrder DECIMAL(18,0),
    RaporDateOrder DECIMAL(18,0),
    RaporDate_1_Order DECIMAL(18,0),
    RaporDate_2_Order DECIMAL(18,0),
    RaporDate_3_Order DECIMAL(18,0),
    RaporDate_4_Order DECIMAL(18,0),
    RaporDate_5_Order DECIMAL(18,0),
    RaporDate_6_Order DECIMAL(18,0),
    RaporDate_7_Order DECIMAL(18,0)
);

DECLARE @Code NVARCHAR(15);

DECLARE CodeCursor CURSOR FAST_FORWARD FOR
SELECT C
FROM (VALUES
   ('210'),('220'),('230'),('240'),('250'),
   ('520'),('521'),('523'),('540'),('542'),
   ('554'),('555'),('575')
) AS V(C);

OPEN CodeCursor;
FETCH NEXT FROM CodeCursor INTO @Code;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #Report104
    EXEC [dbo].[Report_104] @tarix2, @Code;

    FETCH NEXT FROM CodeCursor INTO @Code;
END

CLOSE CodeCursor;
DEALLOCATE CodeCursor;

SELECT 
    [Name] [FILIAL],
    ROUND(SUM(TotalOrder),0)        AS [SIFARIS]
    /*
    ROUND(SUM(RaporDateOrder),0)    AS [BU GÜN],
    ROUND(SUM(RaporDate_1_Order),0) AS [1 GÜN ƏVVƏL],
    ROUND(SUM(RaporDate_2_Order),0) AS [2 GÜN ƏVVƏL],
    ROUND(SUM(RaporDate_3_Order),0) AS [3 GÜN ƏVVƏL],
    ROUND(SUM(RaporDate_4_Order),0) AS [4 GÜN ƏVVƏL],
    ROUND(SUM(RaporDate_5_Order),0) AS [5 GÜN ƏVVƏL],
    ROUND(SUM(RaporDate_6_Order),0) AS [6 GÜN ƏVVƏL],
    ROUND(SUM(RaporDate_7_Order),0) AS [7 GÜN ƏVVƏL]
    */
FROM #Report104
GROUP BY [Name]
ORDER BY [Name]