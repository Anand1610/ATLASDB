


CREATE PROCEDURE [dbo].[Retrive_CaseDetails]
	
	(
		@DomainId VARCHAR(50),
		@Case_Id VARCHAR(100)
		
	)

AS

BEGIN

	SELECT    *
	FROM        LCJ_VW_CaseDetails (NOLOCK)
	WHERE    Case_Id like '%'+ @Case_Id + '%'
	and DomainId=@DomainId
END



