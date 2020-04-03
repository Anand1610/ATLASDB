﻿CREATE PROCEDURE [dbo].[GETINSURANCE_BYVENUE] --'','01/01/2008','01/01/2010','ACUPUNCTURE'
	@SZ_INSCOMP_ID NVARCHAR(50),
	@SZ_START_DATE NVARCHAR(50),
	@SZ_END_DATE NVARCHAR(50),
	@SZ_SPECIALITY NVARCHAR(100)
AS
BEGIN
	DECLARE @STRQUERY AS VARCHAR(MAX)
	DECLARE @STRFROM AS VARCHAR(MAX)
	DECLARE @STRWHERE AS VARCHAR(MAX)
	DECLARE @STRGROUP AS VARCHAR(MAX)
	DECLARE @STRORDERBY AS VARCHAR(MAX)
	SET @STRQUERY = 'SELECT
		COURT_Name,
		COURT_MISC,
		CONVERT(DECIMAL(38,2),AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) AS OPEN_CLAIM,
		CONVERT(DECIMAL(38,2),AVG(CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_AMOUNT,0.00))+CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_INT,0.00)))) AS SETTLEMENT_AMOUNT,
		(CASE WHEN (AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) = 0.00
		THEN 0.00 ELSE CONVERT(DECIMAL(38,2),((AVG(CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_AMOUNT,0.00))+CONVERT(DECIMAL(38,2),ISNULL(SETTLEMENT_INT,0.00))) /
		AVG(CONVERT(DECIMAL(38,2),ISNULL(TC.CLAIM_AMOUNT,0.00))-CONVERT(DECIMAL(38,2),ISNULL(TC.PAID_AMOUNT,0.00)))) * 100)) END) AS SETTLEMENT_PERC,
		AVG(DATEDIFF(DD,TC.DATE_OPENED,TS.SETTLEMENT_DATE)) AS AVG_DAYS_TO_SETTLE,
		SERVICE_TYPE'
	SET @STRFROM = ' FROM 
		TBLCASE TC INNER JOIN TBLTREATMENT TT
		ON TC.CASE_ID = TT.CASE_ID
		INNER JOIN TBLSETTLEMENTS TS
		ON TC.CASE_ID = TS.CASE_ID
		INNER JOIN TBLCOURT TCO
		ON TC.COURT_ID = TCO.COURT_ID'
	SET @STRWHERE = ' WHERE
		SERVICE_TYPE = ''' + @SZ_SPECIALITY + '''
		AND
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) >= REPLACE('''+ @SZ_START_DATE + ''',''/'',''-'') 
		AND  
		CAST(FLOOR(CAST(DATE_OPENED AS FLOAT))AS DATETIME) <= REPLACE('''+ @SZ_END_DATE + ''',''/'',''-'')
		AND
		COURT_NAME <> ''0Select Court'' '
	IF @SZ_INSCOMP_ID <> '' AND @SZ_INSCOMP_ID <> '0'
	BEGIN
		SET @STRWHERE = @STRWHERE + ' AND INSURANCECOMPANY_ID IN (''' + @SZ_INSCOMP_ID + ''')'
	END
	SET @STRGROUP = ' GROUP BY
		TC.COURT_ID,
		COURT_Name,
		COURT_MISC,
		SERVICE_TYPE'
	SET @STRORDERBY = ' ORDER BY 1'
	PRINT(@STRQUERY + @STRFROM + @STRWHERE + @STRGROUP + @STRORDERBY)
	EXEC(@STRQUERY + @STRFROM + @STRWHERE + @STRGROUP + @STRORDERBY)
END

