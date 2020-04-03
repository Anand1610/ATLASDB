﻿CREATE PROCEDURE [dbo].[GETINSURANCE_NOTFILED] --'','01/01/2008','01/01/2011','ACUPUNCTURE'
	@SZ_INSCOMP_ID NVARCHAR(50),
	@SZ_START_DATE NVARCHAR(50),
	@SZ_END_DATE NVARCHAR(50),
	@SZ_SPECIALITY NVARCHAR(100)
AS
BEGIN
	DECLARE @STRQUERYW AS VARCHAR(MAX)
	DECLARE @STRFROMW AS VARCHAR(MAX)
	DECLARE @STRWHEREW AS VARCHAR(MAX)
	DECLARE @STRQUERYWO AS VARCHAR(MAX)
	DECLARE @STRFROMWO AS VARCHAR(MAX)
	DECLARE @STRWHEREWO AS VARCHAR(MAX)
	DECLARE @STRGROUP AS VARCHAR(MAX)
	DECLARE @STRORDERBY AS VARCHAR(MAX)
	SET @STRQUERYW = 'SELECT
		''WITH NOT'' AS [W_WO_NOT],
		--CONVERT(NVARCHAR,YEAR(DATE_OPENED)) + ''/'' + CONVERT(NVARCHAR,MONTH(DATE_OPENED)) AS [YEAR/MONTH],
		CONVERT(DECIMAL(38,2),AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) AS OPEN_CLAIM,
		CONVERT(DECIMAL(38,2),AVG(CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_AMOUNT,0.00))+CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_INT,0.00)))) AS SETTLEMENT_AMOUNT,
		(CASE WHEN (AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) = 0.00
		THEN 0.00 ELSE CONVERT(DECIMAL(38,2),((AVG(CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_AMOUNT,0.00))+CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_INT,0.00))) /
		AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) * 100)) END) AS SETTLEMENT_PERC,
		AVG(DATEDIFF(DD,TC.DATE_OPENED,TS.SETTLEMENT_DATE)) AS AVG_DAYS_TO_SETTLE,
		SERVICE_TYPE'
	SET @STRFROMW = ' FROM 
		TBLCASE TC INNER JOIN TBLTREATMENT TT
		ON TC.CASE_ID = TT.CASE_ID
		INNER JOIN TBLSETTLEMENTS TS
		ON TC.CASE_ID = TS.CASE_ID'
	SET @STRWHEREW = ' WHERE
		SERVICE_TYPE = ''' + @SZ_SPECIALITY + '''
		AND
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE('''+ @SZ_START_DATE + ''',''/'',''-'') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE('''+ @SZ_END_DATE + ''',''/'',''-'')
		AND
		(TC.TRIAL_DATE IS NOT NULL OR TC.TRIAL_DATE <> '''') '
	IF @SZ_INSCOMP_ID <> '' AND @SZ_INSCOMP_ID <> '0'
	BEGIN
		SET @STRWHEREW = @STRWHEREW + ' AND INSURANCECOMPANY_ID IN (''' + @SZ_INSCOMP_ID + ''')'
	END
	
	SET @STRQUERYWO = 'SELECT
		''WITHOUT NOT'' AS [W_WO_NOT],
		--CONVERT(NVARCHAR,YEAR(DATE_OPENED)) + ''/'' + CONVERT(NVARCHAR,MONTH(DATE_OPENED)) AS [YEAR/MONTH],
		CONVERT(DECIMAL(38,2),AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) AS OPEN_CLAIM,
		CONVERT(DECIMAL(38,2),AVG(CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_AMOUNT,0.00))+CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_INT,0.00)))) AS SETTLEMENT_AMOUNT,
		(CASE WHEN (AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) = 0.00
		THEN 0.00 ELSE CONVERT(DECIMAL(38,2),((AVG(CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_AMOUNT,0.00))+CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_INT,0.00))) /
		AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) * 100)) END) AS SETTLEMENT_PERC,
		AVG(DATEDIFF(DD,TC.DATE_OPENED,TS.SETTLEMENT_DATE)) AS AVG_DAYS_TO_SETTLE,
		SERVICE_TYPE'
	SET @STRFROMWO = ' FROM 
		TBLCASE TC INNER JOIN TBLTREATMENT TT
		ON TC.CASE_ID = TT.CASE_ID
		INNER JOIN TBLSETTLEMENTS TS
		ON TC.CASE_ID = TS.CASE_ID'
	SET @STRWHEREWO = ' WHERE
		SERVICE_TYPE = ''' + @SZ_SPECIALITY + '''
		AND
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE('''+ @SZ_START_DATE + ''',''/'',''-'') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE('''+ @SZ_END_DATE + ''',''/'',''-'')
		AND
		(TC.TRIAL_DATE IS NULL) '
	IF @SZ_INSCOMP_ID <> '' AND @SZ_INSCOMP_ID <> '0'
	BEGIN
		SET @STRWHEREWO = @STRWHEREWO + ' AND INSURANCECOMPANY_ID IN (''' + @SZ_INSCOMP_ID + ''')'
	END
	SET @STRGROUP = ' GROUP BY
		--YEAR(DATE_OPENED),
		--MONTH(DATE_OPENED),
		SERVICE_TYPE'
	SET @STRORDERBY = ' ORDER BY 2'
	PRINT(@STRQUERYW + @STRFROMW + @STRWHEREW + @STRGROUP + ' UNION ' + @STRQUERYWO + @STRFROMWO + @STRWHEREWO + @STRGROUP + @STRORDERBY)
	EXEC(@STRQUERYW + @STRFROMW + @STRWHEREW + @STRGROUP + ' UNION ' + @STRQUERYWO + @STRFROMWO + @STRWHEREWO + @STRGROUP + @STRORDERBY)
END

