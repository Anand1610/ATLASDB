create PROCEDURE [dbo].[Update_Client_Account_Print_Date] 
	@AccountId int,
	@DomainId varchar(50)
AS
BEGIN

		SET NOCOUNT ON;

		UPDATE TBLCLIENTACCOUNT SET Last_Printed = GetDate() WHERE ACCOUNT_ID = @AccountId and DomainId = @DomainId
END
