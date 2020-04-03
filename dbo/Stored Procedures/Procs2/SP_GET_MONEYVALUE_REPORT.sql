CREATE PROCEDURE [dbo].[SP_GET_MONEYVALUE_REPORT] --'1993','ANSWER-RECD'
@PROVIDER_ID NVARCHAR(100),
@STATUS NVARCHAR(100)=NULL
AS
BEGIN
 SET NOCOUNT ON;
CREATE TABLE #TEMP
(
	Case_Id nvarchar(1000),
	InjuredParty_Name varchar(8000),
	Provider_Name nvarchar(2000),
	Provider_Id nvarchar(50),
	InsuranceCompany_Name nvarchar(200),  
	Indexoraaa_number nvarchar(100),
	Balance decimal(38,2),
	Claim_Amount decimal(38,2),
	Status nvarchar(50),  
	Ins_Claim_Number nvarchar(200),
	DateOfStart nvarchar(50),
	INITIAL_STATUS nvarchar(50)
)
IF @STATUS IS NOT NULL
BEGIN
	INSERT INTO #TEMP
		select 
		TC.Case_Id,
		InjuredParty_LastName + ' ' + InjuredParty_FirstName as [InjuredParty_Name] , 
		Provider_Name,
		tblprovider.Provider_Id ,
		InsuranceCompany_Name ,
		Indexoraaa_number,  
		round(convert(money,convert(float,TC.Claim_Amount) - convert(float,TC.Paid_Amount)),2) as Balance,
		(SELECT ISNULL(SUM(TBLTREATMENT.CLAIM_AMOUNT),0.00) AS [AMOUNT BILLED]
		FROM TBLCASE 
		INNER JOIN
		TBLTREATMENT ON TBLCASE.CASE_ID = TBLTREATMENT.CASE_ID
		WHERE PROVIDER_ID=@PROVIDER_ID AND TBLCASE.CASE_ID=TC.CASE_ID
		GROUP BY TBLCASE.CASE_ID) as Claim_Amount,
		Status ,
		Ins_Claim_Number ,
		convert(varchar, TC.DateOfService_Start,101)as[DateOfStart],  
		INITIAL_STATUS
		From tblcase TC
		 inner join 
		tblprovider on TC.provider_id=tblprovider.provider_id 
		inner join 
		tblinsurancecompany on TC.insurancecompany_id=tblinsurancecompany.insurancecompany_id  
		inner join 
		tblTreatment on TC.Case_Id=tblTreatment.Case_Id
		WHERE TBLPROVIDER.PROVIDER_ID=@PROVIDER_ID AND TC.STATUS=@STATUS AND
		TC.status not in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')

END
ELSE
BEGIN

		INSERT INTO #TEMP
		select 
		TC.Case_Id,
		InjuredParty_LastName + ' ' + InjuredParty_FirstName as [InjuredParty_Name] , 
		Provider_Name,
		tblprovider.Provider_Id ,
		InsuranceCompany_Name ,
		Indexoraaa_number,  
		round(convert(money,convert(float,TC.Claim_Amount) - convert(float,TC.Paid_Amount)),2) as Balance,
		ISNULL((SELECT ISNULL(SUM(TBLTREATMENT.CLAIM_AMOUNT),0.00) AS [AMOUNT BILLED]
		FROM TBLCASE 
		INNER JOIN
		TBLTREATMENT ON TBLCASE.CASE_ID = TBLTREATMENT.CASE_ID
		WHERE TBLCASE.CASE_ID=TC.CASE_ID
		GROUP BY TBLCASE.CASE_ID),0.00) as Claim_Amount,
		Status ,
		Ins_Claim_Number ,
		convert(varchar, TC.DateOfService_Start,101)as[DateOfStart],  
		INITIAL_STATUS
		From tblcase TC
		 inner join 
		tblprovider on TC.provider_id=tblprovider.provider_id 
		inner join 
		tblinsurancecompany on TC.insurancecompany_id=tblinsurancecompany.insurancecompany_id  
		inner join 
		tblTreatment on TC.Case_Id=tblTreatment.Case_Id
		WHERE TBLPROVIDER.PROVIDER_ID=@PROVIDER_ID AND
		TC.status not in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')

END

select DISTINCT * from #temp ORDER BY STATUS ASC
drop table #temp

END

