-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Voluntary_Payment_Delete]
	@s_a_Voluntary_Pay_Id varchar(max),
	@s_a_DomainId varchar(50)
AS
BEGIN
		BEGIN TRY
			BEGIN TRAN  

				Declare @s_a_Payment_Type varchar(10);
				Declare @i_a_TransactionId int;
				Declare @s_a_Case_Id varchar(150);
				Declare @dTransaction_Id int;
				Declare @iTransaction_Id int;

				Select @s_a_Case_Id = Case_Id, @s_a_Payment_Type = Payment_Type, @i_a_TransactionId = Transactions_Id,
				 @dTransaction_Id =  dTransactions_Id, @iTransaction_Id = iTransactions_Id
				from tbl_Voluntary_Payment where Voluntary_Pay_Id = @s_a_Voluntary_Pay_Id and DomainId = @s_a_DomainId

				Delete from tbl_Voluntary_Payment where
				Voluntary_Pay_Id = @s_a_Voluntary_Pay_Id and DomainId = @s_a_DomainId

				Delete from tblTransactions where Transactions_Id = @i_a_TransactionId and DomainId = @s_a_DomainId

				If @dTransaction_Id is not null
				BEGIN
				 Delete from tblTransactions where Transactions_Id = @dTransaction_Id and DomainId = @s_a_DomainId
				END

				If @iTransaction_Id is not null
				BEGIN
				 Delete from tblTransactions where Transactions_Id = @iTransaction_Id and DomainId = @s_a_DomainId
				END


				DECLARE @i_l_Treat_Coount INT 
				DECLARE @d_Transactions_Amount MONEY

				SET @i_l_Treat_Coount = (select ISNULL(count(case_id),0) from tblTreatment where DomainId=@s_a_DomainId and Case_Id=@s_a_Case_Id)
				SET @d_Transactions_Amount = (select ISNULL(SUM(Transactions_Amount),0) from tblTransactions where DomainId=@s_a_DomainId and Case_Id=@s_a_Case_Id and Transactions_Type IN ('PreC','PreCToP'))

				IF(@i_l_Treat_Coount = 1 AND @s_a_DomainId IN ('GLF'))
				BEGIN
					UPDATE tblTreatment SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Coount)) WHERE DomainId=@s_a_DomainId and Case_Id = @s_a_Case_Id
				END
				ELSE IF(@i_l_Treat_Coount > 0)
				BEGIN
					UPDATE tblTreatment SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Coount)) WHERE DomainId=@s_a_DomainId and Case_Id = @s_a_Case_Id
				END

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
		END CATCH
END
