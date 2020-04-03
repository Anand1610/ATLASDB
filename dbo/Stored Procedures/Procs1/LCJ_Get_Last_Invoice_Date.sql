CREATE PROCEDURE [dbo].[LCJ_Get_Last_Invoice_Date]
(
@DomainId	 NVARCHAR(50),
@PROVIDER_ID NVARCHAR(100)
)

 AS
	DECLARE @STR_DATE DATETIME
	SELECT @STR_DATE = CONVERT(CHAR(10), MAX(account_date) ,101) FROM tblClientAccount 
	WHERE provider_Id = @PROVIDER_ID
	AND DomainId=@DomainId

	IF ((@STR_DATE IS NULL) OR (@STR_DATE = ''))
		BEGIN
			SELECT @STR_DATE = CONVERT(CHAR(10), MIN(Transactions_Date) ,101) FROM tbltransactions 
			WHERE Provider_id = @PROVIDER_ID
			AND DomainId=@DomainId
		END
	SELECT @STR_DATE

