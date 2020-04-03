CREATE PROCEDURE [dbo].[LCJ_CaseDetails]
	
	(
		@DomainId NVARCHAR(50),
		@Case_Id NVARCHAR(100)
		
	)

AS

BEGIN

	SELECT    *
	FROM        LCJ_VW_CaseDetails
	WHERE    Case_Id = @Case_Id
	and DomainId=@DomainId
END

