CREATE PROCEDURE [dbo].[LCJ_AttorneyDetails]
	
	(
		@DomainId nvarchar(50),
		@Attorney_Id varchar (40)
		
	)

AS

BEGIN

	SELECT    Attorney_Id, Attorney_LastName, Attorney_FirstName, Attorney_Address, 
		    Attorney_City, Attorney_State, Attorney_Zip, Attorney_Phone, 
		    Attorney_Fax, Attorney_Email, Defendant_Id
	FROM       tblAttorney 
	WHERE    Attorney_Id = @Attorney_Id
	AND DomainId = @DomainId

END

