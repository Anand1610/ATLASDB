CREATE PROCEDURE [dbo].[check_case_entity_email_or_fax_number_exists] 
	 @DomainID		VARCHAR(50),
	 @CaseId		VARCHAR(50),
	 @EntityId		INT
AS
BEGIN
	DECLARE @s_l_entity_name	VARCHAR(MAX)	=	''
	DECLARE @s_l_email_id		VARCHAR(100)	=	''
	DECLARE @s_l_fax_number		VARCHAR(100)	=	''
	DECLARE @s_l_pl_att_name	VARCHAR(MAX)	=	''
	Declare @CompanyType varchar(150)=''

	Select TOP 1 @CompanyType = LOWER(LTRIM(RTRIM(CompanyType))) from tbl_Client(NOLOCK) Where DomainId=@DomainID

	IF @CompanyType = 'funding'
		BEGIN
			SELECT TOP 1 @s_l_pl_att_name = isnull(am.Attorney_FirstName, '') + ' ' + isnull(am.Attorney_LastName,'') FROM tblAttorney_Case_Assignment aa (NOLOCK) 
				inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
				Where aa.Case_Id = @CaseId  and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId 
		END
	ELSE
		BEGIN
			SELECT TOP 1 @s_l_pl_att_name = ISNULL(AA.Assigned_Attorney,'') FROM tblcase(NOLOCK) C JOIN Assigned_Attorney(NOLOCK) AA ON AA.PK_Assigned_Attorney_ID = C.Assigned_Attorney WHERE C.Case_Id=@CaseId AND C.DomainId = @DomainID
		END

	IF(@EntityId = 1)--Provider President
	BEGIN		
			SELECT
				@s_l_entity_name=	Provider_Name,
				@s_l_email_id	=	ISNULL(E.Provider_Email,''),
				@s_l_fax_number	=	CASE  WHEN ISNULL(E.Provider_Local_Fax,'') = '' THEN ISNULL(E.Provider_Perm_Fax,'') ELSE ISNULL(E.Provider_Local_Fax,'') END
			FROM 
				tblProvider E
				JOIN tblCase C ON C.Provider_Id = E.Provider_Id 
			WHERE 
				C.Case_Id					=	@CaseId AND 
				C.DomainId					=	@DomainID
	END
	ELSE IF(@EntityId = 2)--Insurance Company
	BEGIN
			SELECT
				@s_l_entity_name=	InsuranceCompany_Name,
				@s_l_email_id	=	ISNULL(E.InsuranceCompany_Email,''),
				@s_l_fax_number	=	CASE  WHEN ISNULL(E.InsuranceCompany_Local_Fax,'') = '' THEN ISNULL(E.InsuranceCompany_Perm_Fax,'') ELSE ISNULL(E.InsuranceCompany_Local_Fax,'') END
			FROM 
				tblInsuranceCompany E
				JOIN tblCase C ON C.InsuranceCompany_Id = E.InsuranceCompany_Id 
			WHERE 
				C.Case_Id					=	@CaseId AND 
				C.DomainId					=	@DomainID
	END
	ELSE IF(@EntityId = 3)--Defendant
	BEGIN
			SELECT
				@s_l_entity_name=	Defendant_Name,
				@s_l_email_id	=	ISNULL(E.Defendant_Email,''),
				@s_l_fax_number	=	ISNULL(E.Defendant_Fax,'')
			FROM 
				tblDefendant E
				JOIN tblCase C ON C.Defendant_Id = E.Defendant_id 
			WHERE 
				C.Case_Id					=	@CaseId AND 
				C.DomainId					=	@DomainID
	END
	ELSE IF(@EntityId = 4)--Adjuster
	BEGIN
			SELECT
				@s_l_entity_name=	ISNULL(Adjuster_FirstName,'')+' '+ISNULL(Adjuster_LastName,''),
				@s_l_email_id	=	ISNULL(E.Adjuster_Email,''),
				@s_l_fax_number	=	ISNULL(E.Adjuster_Fax,'')
			FROM 
				tblAdjusters E
				JOIN tblCase C ON C.Adjuster_Id = E.Adjuster_Id 
			WHERE 
				C.Case_Id					=	@CaseId AND 
				C.DomainId					=	@DomainID
	END
	ELSE IF(@EntityId = 5)--Adversary Attorney
	BEGIN
			SELECT
				@s_l_entity_name=	ISNULL(E.Defendant_Name,'') ,  --ISNULL(Attorney_FirstName,'')+' '+ISNULL(Attorney_LastName,''),
				@s_l_email_id	=	ISNULL(E.Defendant_Email,''),
				@s_l_fax_number	=	ISNULL(E.Defendant_Fax,'')
			FROM 
				tblDefendant E
				JOIN tblCase C ON C.Defendant_Id = E.Defendant_id 
			WHERE 
				C.Case_Id					=	@CaseId AND 
				C.DomainId					=	@DomainID
	END
	ELSE IF(@EntityId = 6)--Arbitrator
	BEGIN
			SELECT
				@s_l_entity_name=	ARBITRATOR_NAME,
				@s_l_email_id	=	ISNULL(E.ARBITRATOR_Email,''),
				@s_l_fax_number	=	ISNULL(E.ARBITRATOR_FAX,'')
			FROM 
				TblArbitrator E
				JOIN tblCase C ON C.Arbitrator_ID = E.ARBITRATOR_ID 
			WHERE 
				C.Case_Id					=	@CaseId AND 
				C.DomainId					=	@DomainID
	END
	ELSE IF(@EntityId = 7)--Opposing Counsel
	BEGIN
	   SET @s_l_entity_name = (SUBSTRING(ISNULL(STUFF((
								SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
										FROM tblAttorney_Case_Assignment aa (NOLOCK) 
										inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
										Where aa.Case_Id = @CaseId  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
								for xml path('')
							),1,0,''),','),1,(LEN(ISNULL(STUFF(
							(
								SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
										FROM tblAttorney_Case_Assignment aa (NOLOCK) 
										inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
										Where aa.Case_Id = @CaseId and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
								for xml path('')
							),1,0,''),',')))-1))

       SET @s_l_email_id = (SUBSTRING(ISNULL(STUFF((
								 SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
										FROM tblAttorney_Case_Assignment aa (NOLOCK) 
										inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
										Where aa.Case_Id = @CaseId  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId and  isnull(Attorney_Email,'') != ''
								for xml path('')
							),1,0,''),','),1,(LEN(ISNULL(STUFF(
							(
								 SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
										FROM tblAttorney_Case_Assignment aa (NOLOCK) 
										inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
										Where aa.Case_Id = @CaseId and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId and isnull(Attorney_Email,'') != ''
								for xml path('')
							),1,0,''),',')))-1))

		SET @s_l_fax_number = (SUBSTRING(ISNULL(STUFF((
								 SELECT COALESCE(isnull(Attorney_Fax,'')+',',' - ')
										FROM tblAttorney_Case_Assignment aa (NOLOCK) 
										inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
										Where aa.Case_Id = @CaseId  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId and  isnull(Attorney_Fax,'') != ''
								for xml path('')
							),1,0,''),','),1,(LEN(ISNULL(STUFF(
							(
								 SELECT COALESCE(isnull(Attorney_Fax,'')+',',' - ')
										FROM tblAttorney_Case_Assignment aa (NOLOCK) 
										inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
										Where aa.Case_Id = @CaseId and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId and isnull(Attorney_Fax,'') != ''
								for xml path('')
							),1,0,''),',')))-1))
	END
	ELSE IF(@EntityId = 8)--Firm
	BEGIN
		SELECT
				@s_l_entity_name=	ISNULL(LawFirmName,''),
				@s_l_email_id	=	ISNULL(Client_Email,''),
				@s_l_fax_number	=	ISNULL(Client_Billing_Fax,'')

				
			FROM 
			tbl_Client where DomainId=@DomainID
	END

	SELECT @s_l_email_id AS EmailId,@s_l_fax_number AS FaxNumber,@s_l_entity_name AS EntityName,@s_l_pl_att_name AS pl_att_name
END