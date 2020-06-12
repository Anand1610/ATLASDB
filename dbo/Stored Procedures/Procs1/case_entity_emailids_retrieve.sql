CREATE PROCEDURE [dbo].[case_entity_emailids_retrieve]
(
	@DomainId	VARCHAR(MAX),
	@case_id	VARCHAR(MAX)
)
AS
BEGIN
  SET NOCOUNT ON	
	
    CREATE TABLE #TBL_ENTITY_EMAILS
    (
		s_no		INT IDENTITY(1,1) NOT NULL,
		name		VARCHAR(MAX) NOT NULL,
		email_id	VARCHAR(MAX) NOT NULL,
		entity_type	VARCHAR(MAX) NOT NULL
    )
   
	--Staff Users
    INSERT INTO #TBL_ENTITY_EMAILS	
	SELECT						
			DisplayName + ' (Staff)',
			Email,
			'Staff'
	FROM
			IssueTracker_Users				
	WHERE
			DomainId			=	@DomainId	AND
			IsActive			=	1 AND
			ISNULL(Email,'')	<> ''
	ORDER BY
			DisplayName + ' (Staff)' ASC
    
    --Provider
    INSERT INTO #TBL_ENTITY_EMAILS
    SELECT DISTINCT
		Provider_Name + ' (Provider)',
		ISNULL(Provider_Email,''),
		'Provider'
	FROM
		tblcase C
		JOIN tblProvider p ON p.Provider_Id = C.Provider_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Provider_Email,'')	<> ''
	UNION
	SELECT DISTINCT
		Provider_Name + ' (Provider)',
		ISNULL(Email_For_Arb_Awards,''),
		'Provider'
	FROM
		tblcase C
		JOIN tblProvider p ON p.Provider_Id = C.Provider_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Email_For_Arb_Awards,'')	<> ''
	UNION
	SELECT DISTINCT
		Provider_Name + ' (Provider)',
		ISNULL(Email_For_Invoices,''),
		'Provider'
	FROM
		tblcase C
		JOIN tblProvider p ON p.Provider_Id = C.Provider_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Email_For_Invoices,'')	<> ''
	UNION
	SELECT DISTINCT
		Provider_Name + ' (Provider)',
		ISNULL(Email_For_Closing_Reports,''),
		'Provider'
	FROM
		tblcase C
		JOIN tblProvider p ON p.Provider_Id = C.Provider_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Email_For_Closing_Reports,'')	<> ''
	UNION
	SELECT DISTINCT
		Provider_Name + ' (Provider)',
		ISNULL(Email_For_Monthly_Report,''),
		'Provider'
	FROM
		tblcase C
		JOIN tblProvider p ON p.Provider_Id = C.Provider_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Email_For_Monthly_Report,'')	<> ''
	ORDER BY
		Provider_Name + ' (Provider)' ASC
	
	--Insurance Company
	INSERT INTO #TBL_ENTITY_EMAILS
    SELECT DISTINCT
		InsuranceCompany_Name + ' (Ins. Company)',
		ISNULL(InsuranceCompany_Email,''),
		'Ins. Company'
	FROM
		tblcase C
		JOIN tblInsuranceCompany I ON I.InsuranceCompany_Id = C.InsuranceCompany_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(InsuranceCompany_Email,'')	<> ''
	ORDER BY
		InsuranceCompany_Name + ' (Ins. Company)' ASC

	--Defendant
	INSERT INTO #TBL_ENTITY_EMAILS
    SELECT DISTINCT
		Defendant_Name + ' (Defendant)',
		ISNULL(Defendant_Email,''),
		'Defendant'
	FROM
		tblcase C
		JOIN tblDefendant D ON D.Defendant_id = C.Defendant_id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Defendant_Email,'')	<> ''
	ORDER BY
		Defendant_Name + ' (Defendant)' ASC

	--Adjuster
	INSERT INTO #TBL_ENTITY_EMAILS
    SELECT DISTINCT
		Adjuster_FirstName+' '+Adjuster_LastName + ' (Adjuster)',
		ISNULL(Adjuster_Email,''),
		'Adjuster'
	FROM
		tblcase C
		JOIN tblAdjusters A ON A.Adjuster_Id = C.Adjuster_Id
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Adjuster_Email,'')	<> ''
	ORDER BY
		Adjuster_FirstName+' '+Adjuster_LastName + ' (Adjuster)' ASC

	--Arbitrator
	INSERT INTO #TBL_ENTITY_EMAILS
    SELECT DISTINCT
		ARBITRATOR_NAME + ' (Arbitrator)',
		ISNULL(ARBITRATOR_Email,''),
		'Arbitrator'
	FROM
		tblcase C
		JOIN TblArbitrator A ON A.ARBITRATOR_ID = C.Arbitrator_ID
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(ARBITRATOR_Email,'')	<> ''
	ORDER BY
		ARBITRATOR_NAME + ' (Arbitrator)' ASC

	--Attorney
	INSERT INTO #TBL_ENTITY_EMAILS
	    SELECT DISTINCT
		ISNULL(Attorney_FirstName,'')+' '+ ISNULL(Attorney_LastName,'') + ' (Attorney)',
		ISNULL(Attorney_Email,''),
		'Attorney'
	FROM
		tblAttorney_Master A INNER JOIN tblAttorney_Case_Assignment C
		ON A.Attorney_Id = C.Attorney_Id 
		
		
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Attorney_Email,'')	<> ''
	ORDER BY
		ISNULL(Attorney_FirstName,'')+' '+ ISNULL(Attorney_LastName,'') + ' (Attorney)' ASC

 --   SELECT DISTINCT
	--	Attorney_FirstName+' '+ Attorney_LastName + ' (Attorney)',
	--	ISNULL(Attorney_Email,''),
	--	'Attorney'
	--FROM
	--	tblcase C
	--	JOIN tblAttorney A ON A.Attorney_Id = C.Attorney_Id
	--WHERE
	--	C.DomainId					=	@DomainId	AND
	--	C.Case_Id					=	@case_id	AND
	--	ISNULL(Attorney_Email,'')	<> ''
	--ORDER BY
	--	Attorney_FirstName+' '+ Attorney_LastName + ' (Attorney)' ASC

	--LawFirm
	INSERT INTO #TBL_ENTITY_EMAILS
    SELECT DISTINCT
		Firm_Name + ' (LawFirm)',
		ISNULL(Firm_Email,''),
		'LawFirm'
	FROM
		tblcase C
		JOIN tblFirms F ON F.Firm_Id = C.AttorneyFirmId
	WHERE
		C.DomainId					=	@DomainId	AND
		C.Case_Id					=	@case_id	AND
		ISNULL(Firm_Email,'')	<> ''
	ORDER BY
		Firm_Name + ' (LawFirm)' ASC


		 IF @DomainId='PDC'
		BEGIN

    INSERT INTO #TBL_ENTITY_EMAILS
   	SELECT  COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,''),' - ') + ' (Opposing Counsel)',
	Attorney_Email, 'Opposing Counsel'
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) 
					on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where   Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId =@DomainId and aa.Case_Id =	@case_id	AND
		            ISNULL(Attorney_Email,'')	<> ''
					END

	
	SELECT DISTINCT
		name,
		email_id,
		entity_type
	FROM
		#TBL_ENTITY_EMAILS
	ORDER BY
		entity_type,name ASC
	
	DROP TABLE #TBL_ENTITY_EMAILS
   
  SET NOCOUNT OFF        
END

