USE [BazarlamaHesabatDB]

IF OBJECT_ID('tempdb..#Report103') IS NOT NULL
    DROP TABLE #Report103;

CREATE TABLE #Report103
(
    Code NVARCHAR(50),
    Name NVARCHAR(200),
    TotalSaleAmount DECIMAL(18,2),
    TotalPlan DECIMAL(18,2),
    Boya DECIMAL(18,2),
    BoyaPlan DECIMAL(18,2),
    Boru DECIMAL(18,2),
    BoruPlan DECIMAL(18,2),
    Elektrik DECIMAL(18,2),
    ElektrikPlan DECIMAL(18,2),
    Xirdavat DECIMAL(18,2),
    XirdavatPlan DECIMAL(18,2),
    Xirdavat2 DECIMAL(18,2),
    XirdavatPlan2 DECIMAL(18,2)
);

DECLARE @Code NVARCHAR(10);

DECLARE CodeCursor CURSOR FOR
SELECT C
FROM (VALUES
   ('210'),('220'),('230'),('240'),('250'),('575'),
   ('520'),('521'),('523'),('540'),('542'),
   ('554'),('555')
) AS V(C);

OPEN CodeCursor;
FETCH NEXT FROM CodeCursor INTO @Code;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #Report103
    EXEC [dbo].[Report_103] @tarix1,@tarix2, @Code;

    FETCH NEXT FROM CodeCursor INTO @Code;
END

CLOSE CodeCursor;
DEALLOCATE CodeCursor;

SELECT [Name] [FILIAL], TotalSaleAmount AS [SATIS]
FROM #Report103;
