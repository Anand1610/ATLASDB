CREATE PROCEDURE [dbo].[SP_GET_DENIALREASONS] --'40392'   [SP_GET_DENIALREASONS] '40392' 
@PROVIDER_ID NVARCHAR(100)
AS
BEGIN

	CREATE TABLE #TEMP
	(
		CASE_ID NVARCHAR(50),
		Provider_Id INT,
		Provider_Name NVARCHAR(200),
		INITIAL_STATUS NVARCHAR(50),
		DENIALREASONS_TYPE NVARCHAR(200)
	)
	INSERT INTO #TEMP

	select

	tblcase.Case_Id,
	tblcase.Provider_Id,
	Provider_Name,
	INITIAL_STATUS ,
	TBLDENIALREASONS.DENIALREASONS_TYPE
	From tblcase
	 inner join 
	tblprovider on tblcase.provider_id=tblprovider.provider_id 
	inner join 
	tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id  
	inner join 
	tblTreatment on tblcase.Case_Id=tblTreatment.Case_Id
	inner join
	TXN_tblTreatment on tblTreatment.Treatment_Id=TXN_tblTreatment.Treatment_Id
	INNER JOIN
	TBLDENIALREASONS ON TBLDENIALREASONS.DenialReasons_Id=TXN_tblTreatment.DenialReasons_Id
	 
	WHERE 
	tblcase.provider_id =@PROVIDER_ID AND
	TBLCASE.status not in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')

	SELECT  Provider_Id,DENIALREASONS_TYPE as DenialReason,COUNT(DISTINCT CASE_ID) AS cnt FROM #TEMP WHERE DENIALREASONS_TYPE <> '0Select Denial Reason' 
	group by DENIALREASONS_TYPE,Provider_Id
	ORDER BY DENIALREASONS_TYPE 
	
	--SELECT COUNT(DISTINCT CASE_ID) AS tot_cnt FROM #TEMP WHERE DENIALREASONS_TYPE <> '0Select Denial Reason' 
	
	DROP TABLE #TEMP
END

