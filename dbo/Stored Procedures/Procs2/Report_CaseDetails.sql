CREATE PROCEDURE [dbo].[Report_CaseDetails] 
--[Report_CaseDetails] 'amt', '',''
	@s_a_DomainId nvarchar(50),
	@s_a_status VARCHAR(100)
	--@s_a_ReportDate nvarchar(100)='',
	--@s_a_Portfolio nvarchar(100)=''

AS
BEGIN

--	 select 
--	* from DailyAdditional_Case_Details (NOLOCK)
--where DomainId=@s_a_DomainId --and Date_report_ran = @s_a_ReportDate and portfolio = @s_a_Portfolio
	 select distinct a.case_id,a.InjuredParty_FirstName,a.InjuredParty_LastName,
	 (select InsuranceCompany_Name from tblInsuranceCompany s where s.InsuranceCompany_Id=a.InsuranceCompany_Id)[InsuranceCompany_Name],
	 CONVERT(NVARCHAR(12),CONVERT(DATETIME, a.DATEOFSERVICE_START), 101) + '-' +	CONVERT(NVARCHAR(12), CONVERT(DATETIME, a.DATEOFSERVICE_END), 101)[DOS],
	 c.Code[Project_Code],
	(select Provider_Name from tblProvider p where p.Provider_Id=a.Provider_Id)[Medical_Provider],
	c.Specialty[Specialty],
	b.Bill_number[Bill_number],
	Patient_no_Medic,
	Convert(varchar(50), a.Accident_Date, 101) Accident_Date,
	(select Doctor_Name from tblOperatingDoctor o left outer join tblTreatment t on t.Doctor_Id=o.Doctor_Id where t.Case_Id=a.Case_Id)[DOCTOR_NAME],
	 a.injuredparty_lastname,c.code,c.amount,
	 --d.MOD1,
	 Units,
	ICD10_1,
	ICD10_2,
	ICD10_3,
	a.Date_BillSent[billing_date],
	c.Specialty[bill_type],
	(select Sum(isnull(cast(c.Claim_Amount as float),0)) from tblcase c where c.Case_Id=d.case_id)[total_billed_amt],
	c.Bill_Adjustment,
	'' as TT_PreC_1,
	'' as TD_PreC_1,
	'' as TT_PreC_2,
	'' as TD_PreC_2,
	'' as TT_PreC_3,
	'' as TD_PreC_3,
	'' as Deductible,
	'' as Interest,
	--(select sum(transactions_amount) from tblTransactions tt where tt.Case_Id=a.Case_Id and tt.Transactions_Type='D')[Deductible],
	--(select sum(transactions_amount) from tblTransactions tt where tt.Case_Id=a.Case_Id and tt.Transactions_Type='PreI')[Interest],
	Purchase_Balance,
	Purchase_Price,
	a.Policy_Number,
	a.Memo[Note],
	First_Party_Case_Status,
	--d.Case_Evaluation_Date,
	--First_Party_Suit_Filed_Date,
	(select Court_Name from tblCourt r where r.Court_Id=a.Court_Id)[court_type],
	(select Court_Venue from tblCourt r where r.Court_Id=a.Court_Id)[court_county],
	First_Party_Attorney,
	First_Party_LawFirm,
	Attorney_frmBiller_Note,
	Our_Attorney,
	Our_Attorney_Law_Firm,
	Law_Suit_Type,
	convert(varchar,getdate(),101)[InvDate]

	from tblcase a
	inner join tbl_Voluntary_Payment p on p.Case_Id=a.Case_Id and p.Payment_Type = 'V'
	left join tbltreatment b on a.case_id=b.case_id left join 
	BILLS_WITH_PROCEDURE_CODES c on b.BILL_NUMBER=c.BillNumber 
	left outer join tblCase_additional_info d on d.case_id=a.Case_Id
	where a.DomainId=@s_a_DomainId and (@s_a_status = '' or a.Status = @s_a_status)
END

