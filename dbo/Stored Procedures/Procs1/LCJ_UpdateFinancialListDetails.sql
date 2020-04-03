
create PROCEDURE [dbo].[LCJ_UpdateFinancialListDetails] (
	@Provider_Id VARCHAR(10)
	,@Gross_Amount DECIMAL(19, 2)
	,@Firm_Fees DECIMAL(19, 2)
	,@Cost_Balance DECIMAL(19, 2)
	,@Applied_Cost DECIMAL(19, 2)
	,@Prev_Cost_Balance DECIMAL(19, 2)
	,@Final_Remit DECIMAL(19, 2)
	,@Account_Date DATETIME
	,@Invoice_Image VARCHAR(MAX)
	,@DomainId VARCHAR(20)
	,@VENDOR_FEE DECIMAL(19, 2)
	)
AS
BEGIN
	BEGIN TRANSACTION;

	BEGIN TRY
		UPDATE tblprovider
		SET cost_balance = CONVERT(MONEY, @Cost_Balance)
		WHERE provider_id = @Provider_Id
			AND DomainId = @DomainId

		INSERT INTO tblClientAccount (
			Provider_Id
			,Gross_Amount
			,Firm_Fees
			,Cost_Balance
			,Applied_Cost
			,Prev_Cost_Balance
			,Final_Remit
			,Account_Date
			,Invoice_Image
			,DomainId
			,VENDOR_FEE
			)
		VALUES (
			@Provider_Id
			,@Gross_Amount
			,@Firm_Fees
			,@Cost_Balance
			,@Applied_Cost
			,@Prev_Cost_Balance
			,@Final_Remit
			,@Account_Date
			,@Invoice_Image
			,@DomainId
			,@VENDOR_FEE
			)

		EXEC LCJ_FREEZETRANSACTIONS @DomainId
			,@Provider_Id

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END

		RAISERROR ('Some Error Occured',16,1)
	END CATCH
END
