CREATE PROCEDURE [dbo].[SP_DELETE_WORKDESK_CASES_NEW] 
@DomainId NVARCHAR(50),
@History_Id NVARCHAR(100)
AS
BEGIN

	DELETE FROM tblCaseDeskHistory WHERE History_Id = @History_Id and DomainId=@DomainId

END

