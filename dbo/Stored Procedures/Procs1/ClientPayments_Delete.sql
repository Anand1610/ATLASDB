-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientPayments_Delete] 
	-- Add the parameters for the stored procedure here
	@DomainId NVARCHAR(50),		
	@ClientPaymentId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CB Money
	DECLARE @Payment_Amount Money
	DECLARE @pid INT
    -- Insert statements for procedure here
	select @pid = Provider_id from tblClientPayment(NOLOCK) where ClientPaymentId=@ClientPaymentId and DomainId=@DomainId

	select @cb = cost_balance from tblprovider(NOLOCK) where provider_id=@pid and DomainId=@DomainId

	select @Payment_Amount = Payment_Amount from tblClientPayment(NOLOCK) where ClientPaymentId=@ClientPaymentId and DomainId=@DomainId

	set @cb = @cb + @Payment_Amount

	update tblProvider set cost_balance = @cb where provider_id=@pid and DomainId=@DomainId

	DELETE FROM tblClientPayment WHERE ClientPaymentId=@ClientPaymentId and DomainId=@DomainId

END
