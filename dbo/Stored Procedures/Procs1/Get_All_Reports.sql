CREATE PROCEDURE [dbo].[Get_All_Reports] --[Get_All_Reports] 'NSLIJ'
(
 @prov_grpName nvarchar(100)='NSLIJ'
)
as

begin

--NSLIJ and TRITEC

	select  top 5000
	tblcase.Case_Id as [Case Id],
	InjuredParty_LastName + ', ' + InjuredParty_FirstName as [InjuredParty Name],  
	Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]','') as [Provider Name],  
	InsuranceCompany_Name as [InsuranceCompany Name],
	Ins_Claim_Number as [Claim Number],
	convert (varchar(10),convert(datetime,tblcase.DateOfService_Start),101) as [DOS Start],
	convert (varchar(10),convert(datetime,tblcase.DateOfService_End),101) as [DOS End],
	convert(varchar, Date_Opened,101)as [Date Opened],
	tblcase.Fee_Schedule as [Fee_Schedule],
	tblcase.Claim_Amount as [Claim Amount],
	tblcase.paid_amount as [Paid Amount],
	(convert(float,tblcase.Claim_Amount)-convert(float,tblcase.paid_amount))as [Balance],
	Status,  
	convert (varchar(10),Date_AAA_Arb_Filed,101) as [Date_AAA_Arb_Filed],
	max(Settlement_Date) as [Settlement Date],
	sum(isnull(Settlement_Amount,0.00)) as [Settlement Amount],
	sum(isnull(Settlement_AF,0.00)) as [Attorney Fee],
	sum(isnull(Settlement_FF,0.00)) as [Filing Fee],
	sum(isnull(Settlement_Int,0.00)) as [Settlement Int],
	case when (convert(float,(isnull(tblcase.Claim_Amount,0.00)))-convert(float,(isnull(tblcase.Paid_Amount,0.00))))<>  0.00
	Then convert(numeric(18,2),((sum(isnull(Settlement_Amount,0.00))+sum(isnull(Settlement_Int,0.00)))*100)/
	(convert(float,(isnull(tblcase.Claim_Amount,0.00)))-convert(float,(isnull(tblcase.Paid_Amount,0.00)))))
	else '0.00' end as [Set Per],
	tblSettlement_Type.Settlement_Type,
	isnull(Temp.principle_Date,'-')as [PRINCIPLE DATE],
	isnull(Temp.principle,0)as [PRINCIPLE],
	isnull(Temp.Transactions_Fee,0)as FEE,
	dbo.fncGetInvoiceID (tblcase.Case_Id )as [INVOICE ID],
	[dbo].[fncGetAccountNumber](tblcase.Case_Id) as [Account Number],
	[dbo].[fnc_Case_Bill_Count] (tblcase.Case_Id) as [Bill Count]	
	From tblcase left outer join tblprovider on tblcase.provider_id=tblprovider.provider_id
	left outer join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
	left outer join tblsettlements on tblsettlements.case_id = tblcase.case_id
	left outer join tblSettlement_Type on SettlementType_Id = tblsettlements.Settled_Type
	left outer join (select case_id,sum(transactions_amount)as principle,convert(varchar(10),MAX(Transactions_Date),101) as principle_Date,SUM(Transactions_Fee) as Transactions_Fee  from tblTransactions t where transactions_type in ('I','C') group by Case_Id) Temp  --'PreCToP','PreC','C'
	on tblcase.Case_Id =Temp.Case_Id 
	WHERE 1=1 AND tblcase.Provider_Id in (select Provider_id from tblprovider where Provider_GroupName = @prov_grpName) --TRITEC HC or NSLIJ
	group by temp.principle , Temp.principle_Date, case_autoid,location_id,tblcase.Initial_Status,TBLCASE.CASE_ID,tblcase.Last_Status,tblprovider.Provider_GroupName,TBLPROVIDER.Provider_Name,INJUREDPARTY_FIRSTNAME,INJUREDPARTY_LASTNAME,InsuranceCompany_Name,Accident_Date,Policy_Number,Ins_Claim_Number,TBLCASE.Claim_Amount,TBLCASE.Paid_Amount,TBLCASE.Status,TBLCASE.Date_Opened,DATE_STATUS_CHANGED,tblcase.IndexOrAAA_Number,tblcase.DateOfService_Start,tblcase.DateOfService_End,Date_AAA_Arb_Filed,tblcase.Fee_Schedule,tblSettlement_Type.Settlement_Type,Temp.Transactions_Fee
	order by case_autoid desc

End

