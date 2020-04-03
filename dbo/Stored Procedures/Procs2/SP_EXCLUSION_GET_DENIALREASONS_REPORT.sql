CREATE PROCEDURE [dbo].[SP_EXCLUSION_GET_DENIALREASONS_REPORT]-- 'COUNTRY WIDE REDACTED DENIAL'
  
(  

@Denial_Type nvarchar(50) =null,
@PROVIDER_ID NVARCHAR(50),
@RESULT NVARCHAR(50)=NULL
)  
  
AS
BEGIN
	
	SET NOCOUNT ON;
CREATE TABLE #TEMP
(
	Case_Id nvarchar(50),
	Case_Code nvarchar(50),
	InjuredParty_Name nvarchar(1000),
	Provider_Name nvarchar(200),
	Provider_Id nvarchar(50),
	InsuranceCompany_Name nvarchar(200),  
	Indexoraaa_number nvarchar(100),
	Balance decimal(38,2),
	Status nvarchar(50),  
	Ins_Claim_Number nvarchar(20), 
	DateOfStart nvarchar(50),
	DateOfEnd nvarchar(50),
	INITIAL_STATUS nvarchar(50),	
	DENIALREASONS_TYPE nvarchar(50)
)
IF @Denial_Type IS NOT NULL
BEGIN
	DECLARE @DENIAL_ID NVARCHAR(10)
	SET @DENIAL_ID = (SELECT DenialReasons_Id FROM TBLDENIALREASONS WHERE DENIALREASONS_TYPE=@Denial_Type)
	INSERT INTO #TEMP
	select
	tblcase.Case_Id,
	tblcase.Case_Code,   
	InjuredParty_LastName + ' ' + InjuredParty_FirstName as [InjuredParty_Name],  
	Provider_Name,
	 tblprovider.Provider_Id, 
	InsuranceCompany_Name,  
	Indexoraaa_number,  
	round(convert(money,convert(float,tblcase.Claim_Amount) - convert(float,tblcase.Paid_Amount)),2) as Balance,
	Status,  
	Ins_Claim_Number,  
	convert(varchar, tblcase.DateOfService_Start,101)as[DateOfStart],  
	convert(varchar, tblcase.DateOfService_End,101) as [DateOfEnd] , INITIAL_STATUS ,
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
	AND TBLPROVIDER.PROVIDER_ID = @PROVIDER_ID
	WHERE 
	TXN_tblTreatment.DenialReasons_Id=@Denial_Id AND
	TBLCASE.status in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')  
END
ELSE
BEGIN
	INSERT INTO #TEMP
	select
	tblcase.Case_Id,
	tblcase.Case_Code,   
	InjuredParty_LastName + ' ' + InjuredParty_FirstName as [InjuredParty_Name],  
	Provider_Name,
	 tblprovider.Provider_Id, 
	InsuranceCompany_Name,  
	Indexoraaa_number,  
	round(convert(money,convert(float,tblcase.Claim_Amount) - convert(float,tblcase.Paid_Amount)),2) as Balance,
	Status,  
	Ins_Claim_Number,  
	convert(varchar, tblcase.DateOfService_Start,101)as[DateOfStart],  
	convert(varchar, tblcase.DateOfService_End,101) as [DateOfEnd] , INITIAL_STATUS ,
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
	WHERE TBLPROVIDER.PROVIDER_ID = @PROVIDER_ID
	AND
	TBLCASE.status in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')

END
IF @RESULT = 'TOTAL'
BEGIN
	select sum(cast(Balance as money)) as Sum_Balance ,count(Distinct Case_id) as Tot_Count FROM #TEMP
END
ELSE
BEGIN

	SELECT * FROM #TEMP WHERE DENIALREASONS_TYPE <> '0Select Denial Reason' or DENIALREASONS_TYPE <> '' OR DENIALREASONS_TYPE IS NOT NULL ORDER BY DENIALREASONS_TYPE
	--select * from #temp where case_id='FH07-42372'
END
DROP TABLE #TEMP
    
END

