-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[provider_monthly_statement_feescost_received] 
	@s_a_DomainId varchar(50),
	@i_a_providerId int
AS
BEGIN
	
	SET NOCOUNT ON;

	Select SUM(Transactions_Amount) AS FeesCostReceived 
	from tbltransactions 
    where TRANSACTIONS_TYPE = 'FFC' AND DomainId=@s_a_DomainId AND Provider_Id = @i_a_providerId
    AND Transactions_Date between DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) and DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)

END
