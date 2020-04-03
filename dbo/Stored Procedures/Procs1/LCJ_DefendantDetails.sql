CREATE PROCEDURE [dbo].[LCJ_DefendantDetails]
	
	(
		@DomainId nvarchar(50),
		@Defendant_Id NVARCHAR(100)
		
	)

AS

BEGIN

SELECT    *,Defendant_City+' , '+Defendant_State+' '+Defendant_Zip as DefendantCity
	FROM        tblDefendant 
	WHERE    Defendant_Id = @Defendant_Id
	AND DomainId = @DomainId

END

