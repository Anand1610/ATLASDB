CREATE PROCEDURE [dbo].[LCJ_UpdateFinancialListDirectTypeDetails](        
@DomainId VARCHAR(20),
@Provider_Id varchar(10),
@Invoice_Image NVARCHAR(MAX),
@Gross_Amount DECIMAL(19,2),
@Firm_Fees DECIMAL(19,2),
@Intrest_Due DECIMAL(19,2),
@Expense_Due DECIMAL(19,2),
@Final_Remit DECIMAL(19,2),
@Account_Date DATETIME,
@VENDOR_FEE DECIMAL(19,2)
,@REBUTTAL_FEE DECIMAL(19, 2)
)        
AS
BEGIN
	BEGIN TRANSACTION;    
	BEGIN TRY
	update tblprovider Set cost_balance = Convert(money,@Gross_Amount) where provider_id = @Provider_Id AND DomainId = @DomainId

	INSERT INTO tblClientAccount(Provider_Id,Gross_Amount,Firm_Fees,Intrest_Due,Expense_Due,Final_Remit,Account_Date,Invoice_Image,DomainId,VENDOR_FEE,REBUTTAL_FEE)
	VALUES(@Provider_Id,@Gross_Amount,@Firm_Fees,@Intrest_Due,@Expense_Due,@Final_Remit,@Account_Date,@Invoice_Image,@DomainId,@VENDOR_FEE,@REBUTTAL_FEE)

	EXEC LCJ_FREEZETRANSACTIONS_TYPE1 @DomainId,@Provider_Id
	COMMIT TRANSACTION
	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION
        END
		RAISERROR('Some Error Occured',16,1)
    END CATCH
END