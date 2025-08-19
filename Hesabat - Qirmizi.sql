USE [BazarlamaHesabatDB]

IF OBJECT_ID('tempdb..#Report107') IS NOT NULL
    DROP TABLE #Report107;

CREATE TABLE #Report107
(
    Code NVARCHAR(50),
    Congragent NVARCHAR(200),
    SaleGroup NVARCHAR(200),
    Seller NVARCHAR(200),
    Debt DECIMAL(18,2),
    BottomLimit DECIMAL(18,2),
    TopLimit DECIMAL(18,2),
    Expire NVARCHAR(20),
    ExpireDebt DECIMAL(18,2) NULL
);

DECLARE @Code NVARCHAR(10);

DECLARE CodeCursor CURSOR FOR
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
    INSERT INTO #Report107
    EXEC [dbo].[Report_107] @tarix2, @Code;

    FETCH NEXT FROM CodeCursor INTO @Code;
END

CLOSE CodeCursor;
DEALLOCATE CodeCursor;

SELECT
    LTRIM(SUBSTRING(SaleGroup, CHARINDEX('-', SaleGroup) + 1, LEN(SaleGroup))) FILIAL,
    SUM(ExpireDebt) QIRMIZI
FROM #Report107
WHERE
    Expire = 'OLMAZ 0'
GROUP BY
    SaleGroup