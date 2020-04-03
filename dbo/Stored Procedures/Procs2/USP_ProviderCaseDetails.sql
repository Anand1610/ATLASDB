CREATE PROCEDURE [dbo].[USP_ProviderCaseDetails]
	
	(
		@DomainId NVARCHAR(50),
		@Case_Id NVARCHAR(100),
		@Provider_Id int
		
	)

AS

BEGIN

	SELECT    *	FROM        tblProviderCase
	WHERE    Case_Id = @Case_Id	and DomainId=@DomainId and Provider_Id= @Provider_Id
END

