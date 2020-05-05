/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[GetPreLitigationInfo]
@providerID int,
@domainID varchar(10),
@year int,
@month int
as
begin
	Select	LawFirmName, 
			Client_Billing_Address, 
			Client_Billing_City, 
			Client_Billing_State,
			Client_Billing_Zip, 
			Client_Billing_Phone, 
			Client_Billing_Fax 
	from	tbl_Client c 
	where	c.DomainId =@domainID

	select
	DISTINCT
	case_autoid,treatment_id,
	tblTransactions.case_id, 
	tblcase.provider_id,
	tblcase.InjuredParty_FirstName + ' ' + tblcase.InjuredParty_LastName [Patient_Name],
	provider_name,
	insurancecompany_name,
	tblcase.date_opened, 
	transactions_amount,
	Account_Number,
	isnull(tbltreatment.Date_BillSent,'') as Date_BillSent,
	isnull(tbltreatment.DateOfService_Start,isnull(tblcase.DateOfService_Start,0.00)) as DateOfService_Start,
	isnull(tbltreatment.DateOfService_End,isnull(tblcase.DateOfService_End,0.00)) as DateOfService_End,
	isnull(tbltreatment.Claim_Amount,isnull(tblcase.Claim_Amount,0.00)) as Claim_Amount,
	isnull(tbltreatment.Fee_Schedule,isnull(tblcase.Fee_Schedule,0.00)) as Fee_Schedule,
	isnull(tbltreatment.Paid_Amount,isnull(tblcase.Paid_Amount,0.00)) as Paid_Amount,
	isnull(tbltreatment.SERVICE_TYPE,'') as SERVICE_TYPE,
	isnull(tbltreatment.Claim_Amount,isnull(tblcase.Claim_Amount,0.00))- isnull(tbltreatment.Paid_Amount,isnull(tblcase.Paid_Amount,0.00)) as [Amount_Outstanding],
	(select MAX(DENIALREASONS_TYPE) from tblDenialReasons inner join TXN_tblTreatment on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id where Treatment_Id= tblTreatment.Treatment_Id)  as DENIALREASONS_TYPE, 
	  
	--isnull(tbltreatment.DENIALREASONS_TYPE,'') as DENIALREASONS_TYPE,
	tblcase.IndexOrAAA_Number,
	tblTransactions.transactions_type,
	tblTransactions.transactions_date,
	tblcase.DomainID INTO #TEMP
from tblTransactions 
inner join tblcase on tblTransactions.case_id= tblcase.case_id
inner join tblprovider on tblcase.provider_id=tblprovider.provider_id
inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
inner join tbltreatment on tblcase.case_id=tbltreatment.case_id
	where	tblcase.provider_id =@providerID 
			and year(transactions_date)=@year
			and month(transactions_date)=@month
			AND tblTransactions.transactions_type='PreC'
			order by case_autoid desc
			SELECT * FROM #TEMP

	select	count(case_id) [Tot_count],			
			sum(isnull(Claim_Amount,0)) [Claim_Amount],
			sum(isnull(Paid_Amount,0)) [Paid_Amount]			
	from #TEMP
	end