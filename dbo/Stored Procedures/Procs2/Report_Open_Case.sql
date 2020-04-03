

CREATE PROCEDURE [dbo].[Report_Open_Case] -- [Report_Open_Case] 'GLF'
(
	@DomainId NVARCHAR(50),
	@s_a_ProviderNameGroupSel VARCHAR(MAX)=0,
	@s_a_date_opened_FROM VARCHAR(20) = '',
	@s_a_date_Opened_To VARCHAR(20) = ''
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		SELECT  
		cas.Case_Id,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		pro.Provider_Name as Provider_Name,
		pro.Provider_Id as Provider_Id,
		ISNULL(pro.Email_For_Monthly_Report,'') as Email_For_Monthly_Report,   
		CONVERT(VARCHAR(10), min(cas.Date_Opened), 101) AS Date_Opened,
		CONVERT(VARCHAR(10), min(tre.DateOfService_Start), 101) +' - '+ CONVERT(VARCHAR(12), min(tre.DateOfService_End), 1) AS DOS_Range, 

		--ins.InsuranceCompany_Name,  
		--ins.InsuranceCompany_Local_Address AS InsuranceCompany_Address,
		--ins.InsuranceCompany_Local_City AS InsuranceCompany_City,
		--ins.InsuranceCompany_Local_State AS InsuranceCompany_State,
		--ins.InsuranceCompany_Local_Zip AS InsuranceCompany_Zip,
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Amount,
		CONVERT(VARCHAR(10),MIN(tre.Date_BillSent),101) AS Date_BillSent,
		--convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)))) as FS_Balance,
		--cas.Status,  
		--cas.Initial_Status,
		--cas.Accident_Date,		
		--pro.Provider_GroupName,
		ISNULL(LawFirmName,'') AS LawFirmName, 
		ISNULL(Client_Billing_Address,'') AS Client_Billing_Address,
		ISNULL(Client_Billing_City,'') AS Client_Billing_City,
		ISNULL(Client_Billing_State,'') AS Client_Billing_State,
		ISNULL(Client_Billing_Zip,'') AS Client_Billing_Zip,
		ISNULL(Client_Billing_Phone,'') AS Client_Billing_Phone,
		ISNULL(Client_Billing_Fax,'') AS Client_Billing_Fax
	FROM dbo.tblCase cas (NOLOCK)
	INNER JOIN dbo.tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id 
	INNER JOIN dbo.tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
	LEFT OUTER JOIN dbo.tblTreatment tre (NOLOCK) on tre.Case_Id= cas.Case_Id
	LEFT OUTER JOIN dbo.TXN_tblTreatment t_tre (NOLOCK) on t_tre.Treatment_Id = tre.treatment_id
	INNER JOIN tbl_Client cl (NOLOCK) on cas.DomainId = cl.DomainId
	
	WHERE
		cas.DomainId = @DomainID --AND Status <> 'POM GENERATED'
		AND (@s_a_ProviderNameGroupSel  ='0' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
		AND (@s_a_date_opened_FROM  = '' OR (cas.Date_Opened BETWEEN CONVERT(DATETIME,@s_a_date_opened_FROM) AND CONVERT(DATETIME,@s_a_date_Opened_To) + 1))
		AND cas.Case_Id like 'ACT%'
	Group by 	
		cas.Case_Id,
		cas.InjuredParty_FirstName,
		cas.InjuredParty_LastName,
		pro.Provider_Name,
		pro.Provider_Id,
		cas.Claim_Amount,
		--cas.Fee_Schedule,
		--cas.Status,
		--cas.Accident_Date,		
		--cas.Initial_Status,
		--pro.Provider_GroupName,
		cas.Paid_Amount,
		--cas.Ins_Claim_Number,
		--Cas.Date_Opened,
		--Cas.Date_Status_Changed,
		ISNULL(pro.Email_For_Monthly_Report,''),
		CL.LawFirmName,
		CL.Client_Billing_Address,
		CL.Client_Billing_City,
		CL.Client_Billing_State,
		CL.Client_Billing_Zip,
		CL.Client_Billing_Phone,
		CL.Client_Billing_Fax
	ORDER BY pro.Provider_Name,cas.Case_Id	desc

	

	
END

