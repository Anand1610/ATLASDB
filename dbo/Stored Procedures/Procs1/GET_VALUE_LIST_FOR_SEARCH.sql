CREATE PROCEDURE [dbo].[GET_VALUE_LIST_FOR_SEARCH]
@SEARCHTEXT NVARCHAR(150),
@FLAG NVARCHAR(50)
AS

IF @FLAG='PROVIDERLIST'
	BEGIN
		SELECT 
			Provider_Name 
		FROM tblProvider WHERE  Provider_Name like @SEARCHTEXT + '%'
		ORDER BY provider_name ASC
	END
IF @FLAG='INSURANCECOMPANYLIST'
	BEGIN
		SELECT    
			DISTINCT  Upper(ISNULL(InsuranceCompany_Name, '')) AS InsuranceCompany_Name 
		FROM tblInsuranceCompany 
		WHERE      active = 2 
				AND InsuranceCompany_Name like @SEARCHTEXT + '%'
		order by InsuranceCompany_Name asc
	END
IF @FLAG='COURTTYPELIST'
	BEGIN
		SELECT   DISTINCT Upper(ISNULL(Court_Name, '')) AS Court_Name
	FROM         tblCourt
	WHERE     (1 = 1) AND Court_Name like @SEARCHTEXT + '%' order by Court_Name
	END
IF @FLAG='CASESTATUSLIST'
	BEGIN
		SELECT   Upper(ISNULL(Status_Type, '')) AS Status_Type
	FROM         tblStatus
	WHERE     (1 = 1) AND Status_Type like @SEARCHTEXT + '%' order by Status_Type
	END
IF @FLAG='DEFNAMELIST'
	BEGIN
		SELECT    DISTINCT  Upper(ISNULL(Defendant_Name, '')) AS Defendant_Name
	FROM         tblDefendant
	WHERE     (1 = 1) AND Defendant_Name like @SEARCHTEXT + '%' order by defendant_name
	END

