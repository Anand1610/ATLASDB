﻿CREATE PROCEDURE [dbo].[GETPROVIDERS_INITIALSTATUS]
	@SZ_PROVIDER_ID NVARCHAR(50),
	@SZ_START_DATE NVARCHAR(50),
	@SZ_END_DATE NVARCHAR(50),
	@PROVIDER_GROUP VARCHAR(10)
AS
BEGIN
IF @PROVIDER_GROUP <> '0'
BEGIN
	SELECT 
		INITIAL_STATUS,
		COUNT(DISTINCT CASE_ID) AS [CNT] 
	FROM 
		TBLCASE 
	WHERE 
	PROVIDER_ID IN
		(SELECT PROVIDER_ID FROM TBLPROVIDER WHERE PROVIDER_GROUPNAME IN
			(SELECT PROVIDER_GROUPNAME FROM TBLPROVIDER WHERE PROVIDER_ID = @SZ_PROVIDER_ID))
		AND
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE(@SZ_START_DATE,'/','-') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE(@SZ_END_DATE,'/','-')
	GROUP BY 
		INITIAL_STATUS 
	ORDER BY INITIAL_STATUS
END
ELSE
BEGIN
	SELECT 
		INITIAL_STATUS,
		COUNT(DISTINCT CASE_ID) AS [CNT] 
	FROM 
		TBLCASE 
	WHERE 
		PROVIDER_ID=@SZ_PROVIDER_ID
		AND
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE(@SZ_START_DATE,'/','-') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE(@SZ_END_DATE,'/','-')
	GROUP BY 
		INITIAL_STATUS 
	ORDER BY INITIAL_STATUS
END
END

