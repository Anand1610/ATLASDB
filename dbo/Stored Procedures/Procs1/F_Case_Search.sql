CREATE PROCEDURE [dbo].[F_Case_Search]
(
	 @s_a_ProviderGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_InsuranceGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_Case_ID	VARCHAR(100)	=	'',
	 @s_a_OldCaseId	VARCHAR(100)	=	'',
	 @s_a_InjuredName	VARCHAR(100)	=	'',
	 @s_a_InsuredName	VARCHAR(100)	=	'',
	 @s_a_IndexOrAAANo	VARCHAR(100)	=	'',
	 @s_a_PolicyNo	VARCHAR(100)	=	'',
	 @s_a_ClaimNo	VARCHAR(100)	=	'',
	 @s_a_InitialStatus	VARCHAR(500)	=	'',
	 @s_a_CurrentStatus	VARCHAR(500)	=	'',
	 @i_a_DenailReason	INT	=	0,
	 @i_a_Court	INT	=	0,
	 @i_a_SRL	INT	=	0,
	 @i_a_ReviewingDoctor	INT	=	0,
	 @i_a_Defendant	INT	=	0,
	 @s_a_ProviderGroup	VARCHAR(100)	=	'',
	 @s_a_DOSFrom	VARCHAR(100)	=	'',
	 @s_a_DOSTo	VARCHAR(100)	=	'',
	 @s_a_date_opened_from	VARCHAR(100)	=	'',
	 @s_a_date_Opened_To	VARCHAR(100)	=	'',
	 
	 @i_a_AgeFrom	INT	=	NULL,
	 @i_a_AgeTo	INT	=	NULL
											 
)
AS
BEGIN	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
	
	SELECT distinct
		cas.Case_Id,
		cas.Case_AutoId,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.Indexoraaa_number,  
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Amount,
		cas.Status,  
		cas.Ins_Claim_Number, 
		pro.Provider_GroupName,
		CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as Status_Age
			
	FROM tblCase cas
	INNER JOIN tblprovider pro on cas.provider_id=pro.provider_id 
	INNER JOIN tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
	LEFT OUTER JOIN tblTreatment tre on tre.Case_Id= cas.Case_Id
	LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR prdoc on prdoc.TREATMENT_ID = tre.treatment_id
	LEFT OUTER JOIN TXN_tblTreatment t_tre on t_tre.Treatment_Id = tre.treatment_id
	WHERE
		status <> 'IN ARB OR LIT'
		AND (@s_a_ProviderGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderGroupSel,',')))
		AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))

		
		AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
		AND (@s_a_ProviderGroup ='' OR pro.Provider_GroupName = @s_a_ProviderGroup )
		
		AND (@s_a_InitialStatus ='' OR cas.Initial_Status = @s_a_InitialStatus)
		AND (@s_a_CurrentStatus ='' OR cas.Status = @s_a_CurrentStatus )
		AND (@i_a_DenailReason = 0 OR t_tre.DenialReasons_Id = @i_a_DenailReason)
		AND (@i_a_Court = 0 OR cas.Court_Id = @i_a_Court)
		AND (@i_a_SRL = 0 OR cas.location_id = @i_a_SRL)
		AND (@i_a_ReviewingDoctor = 0 OR prdoc.DOCTOR_ID = @i_a_ReviewingDoctor)
		AND (@i_a_Defendant ='' OR cas.defendant_Id = @i_a_Defendant)
		
		AND (@s_a_date_opened_from='' OR (Date_Opened Between convert(datetime,@s_a_date_opened_from) And convert(datetime,@s_a_date_Opened_To)))
		
		AND (@s_a_DOSFrom ='' or (CONVERT(DATETIME,cas.DateOfService_Start) >=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSFrom,101))  and cas.DateOfService_Start IS NOT NULL))
		AND (@s_a_DOSTo ='' or (CONVERT(DATETIME,cas.DateOfService_End) <=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSTo,101))  and cas.DateOfService_End IS NOT NULL))

		AND (@i_a_AgeFrom	IS NULL	OR CONVERT(VARCHAR,DATEDIFF(dd,cas.Date_Status_Changed,GETDATE())) >= @i_a_AgeFrom)
		AND (@i_a_AgeTo	IS NULL OR CONVERT(VARCHAR,DATEDIFF(dd,cas.Date_Status_Changed,GETDATE())) <= @i_a_AgeTo)

	Group by 	
		cas.Case_Id,
		cas.Case_AutoId,
		cas.InjuredParty_FirstName,
		cas.InjuredParty_LastName,
		pro.Provider_Name,
		ins.InsuranceCompany_Name,
		cas.Indexoraaa_number,
		cas.Claim_Amount,
		cas.Status,
		pro.Provider_GroupName,
		cas.Paid_Amount,
		cas.Ins_Claim_Number,
		Cas.Date_Opened,
		Cas.Date_Status_Changed
	ORDER BY Case_AutoId	desc
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
END

