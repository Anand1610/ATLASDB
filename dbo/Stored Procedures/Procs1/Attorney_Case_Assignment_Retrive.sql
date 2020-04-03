CREATE PROCEDURE [dbo].[Attorney_Case_Assignment_Retrive] 
	@i_a_Case_Id NVARCHAR(50),
	@s_a_DomainID varchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		 Attorney_Type
		,AT.Attorney_Type_ID
		,AM.Attorney_Id
		,(ISNULL(AM.Attorney_FirstName,'') + ' ' + ISNULL(AM.Attorney_LastName,'')) AS AttorneyName 
		,AC.created_by_user
		,AC.Assignment_Id
		,LawFirmName
		,Attorney_Address
		,Attorney_City
		,Attorney_State
		,Attorney_Zip
		,Attorney_Phone
		,Attorney_Fax
		,Attorney_Email
		,iif(Isnull(IsOutsideAttorney,0) = 0, 'No', 'Yes') AS IsOutsideAttorney
		,ISNULL(Attorney_BAR_Number,'') AS Attorney_BAR_Number
	FROM 
	tblAttorney_Case_Assignment AC INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = AC.Attorney_Id 
	INNER JOIN tblAttorney_Type AT ON AT.Attorney_Type_ID = AM.Attorney_Type_Id
	WHERE 
	AM.DomainID=@s_a_DomainID 
	AND AC.Case_Id=@i_a_Case_Id




END

