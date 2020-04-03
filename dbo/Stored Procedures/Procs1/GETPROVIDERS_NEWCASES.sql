﻿CREATE PROCEDURE [dbo].[GETPROVIDERS_NEWCASES] --'40552','01/01/2009','01/01/2011','1'
	@SZ_PROVIDER_ID NVARCHAR(20),
	@SZ_START_DATE NVARCHAR(20),
	@SZ_END_DATE NVARCHAR(20),
	@PROVIDER_GROUP VARCHAR(10)
AS
BEGIN
IF @PROVIDER_GROUP <> '0'
BEGIN
	SELECT 
		INITIAL_STATUS, 
		(CONVERT(NVARCHAR(20),YEAR(DATE_OPENED))+'/'+
			CONVERT(NVARCHAR(20),MONTH(DATE_OPENED))) AS [MONTHYEAR],
		COUNT(*) AS 'COUNT_CASES',
		SUM(CAST(CLAIM_AMOUNT AS MONEY)) AS 'SUM_CLAIM_AMOUNT',
		SUM(CAST(CLAIM_AMOUNT AS MONEY)-CAST(PAID_AMOUNT AS MONEY)) AS 'SUM_BALANCE' 
	FROM 
		[dbo].[SJR-CASE_REPORT] 
	WHERE 
		PROVIDER_ID IN
		(SELECT PROVIDER_ID FROM TBLPROVIDER WHERE PROVIDER_GROUPNAME IN
			(SELECT PROVIDER_GROUPNAME FROM TBLPROVIDER WHERE PROVIDER_ID = @SZ_PROVIDER_ID))
		AND 
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE(@SZ_START_DATE,'/','-') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE(@SZ_END_DATE,'/','-')
	GROUP BY 
		INITIAL_STATUS, 
		YEAR(DATE_OPENED),
		MONTH(DATE_OPENED)
	ORDER BY 
		YEAR(DATE_OPENED) DESC, 
		MONTH(DATE_OPENED) DESC
END
ELSE
BEGIN
	SELECT 
		INITIAL_STATUS, 
		(CONVERT(NVARCHAR(20),YEAR(DATE_OPENED))+'/'+
			CONVERT(NVARCHAR(20),MONTH(DATE_OPENED))) AS [MONTHYEAR],
		COUNT(*) AS 'COUNT_CASES',
		SUM(CAST(CLAIM_AMOUNT AS MONEY)) AS 'SUM_CLAIM_AMOUNT',
		SUM(CAST(CLAIM_AMOUNT AS MONEY)-CAST(PAID_AMOUNT AS MONEY)) AS 'SUM_BALANCE' 
	FROM 
		[dbo].[SJR-CASE_REPORT] 
	WHERE 
		PROVIDER_ID = @SZ_PROVIDER_ID
		AND 
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE(@SZ_START_DATE,'/','-') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE(@SZ_END_DATE,'/','-')
	GROUP BY 
		INITIAL_STATUS, 
		YEAR(DATE_OPENED),
		MONTH(DATE_OPENED),
		PROVIDER_ID 
	ORDER BY 
		YEAR(DATE_OPENED) DESC, 
		MONTH(DATE_OPENED) DESC
END
END

