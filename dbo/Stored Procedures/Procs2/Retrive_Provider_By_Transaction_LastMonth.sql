-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Retrive_Provider_By_Transaction_LastMonth] -- Retrive_Provider_By_Transaction_LastMonth 'GLF'
	@s_a_DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	Select
	 Provider_Id
	,  Provider_Name
	,  CASE WHEN ISNULL(Email_For_Monthly_Report,'') <> '' THEN Email_For_Monthly_Report
			WHEN ISNULL(Provider_Email,'') <> '' THEN Provider_Email
			ELSE '' END Provider_Email
	,  cost_balance 
	FROM tblprovider
	Where  Provider_Id in 
	(Select distinct Provider_ID from tbltransactions 
	Where Transactions_Date between DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) and  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) 
	and DomainId= @s_a_DomainId) and DomainId= @s_a_DomainId
    
END
