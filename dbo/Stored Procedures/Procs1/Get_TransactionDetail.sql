-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_TransactionDetail]
	@i_a_Transactions_Id int,
	@s_a_DomainId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Select 
		Case_Id, 
		Transactions_Id,
		Provider_Id,  
		Transactions_Amount,  
		CONVERT(VARCHAR(10), Transactions_Date,101) As Transactions_Date,  
		Transactions_Type,  
		Transactions_Description,  
		User_id,  
		Transactions_status,
		Transactions_Fee,
		DomainId,
		ChequeNo,
		CONVERT(VARCHAR(10), CheckDate,101) As CheckDate,
		BatchNo,
		TreatmentIds
	from tblTransactions where Transactions_Id = @i_a_Transactions_Id  and DomainId=@s_a_DomainId



END
