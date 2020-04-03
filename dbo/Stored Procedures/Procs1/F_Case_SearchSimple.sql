CREATE PROCEDURE [dbo].[F_Case_SearchSimple]
(
	 @s_a_Case_ID	VARCHAR(100)	=	'',
	 @s_a_InjuredLastName	VARCHAR(100)	=	'',
	 @s_a_InjuredFirstName	VARCHAR(100)	=	'',
	 @s_a_InsuredLastName	VARCHAR(100)	=	'',
	 @s_a_InsuredFirstName	VARCHAR(100)	=	'',
	 @s_a_IndexOrAAANo	VARCHAR(100)	=	'',
	 @s_a_PolicyNo	VARCHAR(100)	=	'',
	 @s_a_ClaimNo	VARCHAR(100)	=	'',
	 @s_a_InitialStatus	VARCHAR(500)	=	'',
	 @s_a_CurrentStatus	VARCHAR(500)	=	'',
	 @i_a_Provider		INT	=	0,
	 @i_a_Insurance	INT	=	0,
	 @i_a_Court	INT	=	0,
	 @i_a_DenailReason	INT	=	0,
	 @i_a_ReviewingDoctor	INT	=	0
											 
)
AS
BEGIN	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
	
	SELECT  distinct TOP 2000
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
		(@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND status <> 'IN ARB OR LIT'
		AND (@s_a_InjuredLastName ='' OR cas.InjuredParty_LastName like '%'+ @s_a_InjuredLastName + '%')
		AND (@s_a_InjuredFirstName ='' OR cas.InjuredParty_FirstName like '%'+ @s_a_InjuredFirstName + '%')
		AND (@s_a_InsuredLastName ='' OR cas.InsuredParty_LastName like '%'+ @s_a_InsuredLastName + '%')
		AND (@s_a_InsuredFirstName ='' OR cas.InsuredParty_FirstName like '%'+ @s_a_InsuredFirstName + '%')
		
		
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')

		
		AND (@s_a_InitialStatus ='' OR cas.Initial_Status = @s_a_InitialStatus)
		AND (@s_a_CurrentStatus ='' OR cas.Status = @s_a_CurrentStatus )
		AND (@i_a_Provider = 0 OR cas.Provider_Id = @i_a_Provider)
		AND (@i_a_Insurance = 0 OR cas.InsuranceCompany_Id = @i_a_Insurance)
		AND (@i_a_Court = 0 OR cas.Court_Id = @i_a_Court)
		AND (@i_a_DenailReason = 0 OR t_tre.DenialReasons_Id = @i_a_DenailReason)
		AND (@i_a_ReviewingDoctor = 0 OR prdoc.DOCTOR_ID = @i_a_ReviewingDoctor)

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

