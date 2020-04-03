
CREATE PROCEDURE [dbo].[SPGetClientInvoiceReportElementTag] -- SPGetClientInvoiceReportElementTag 'AF',3998,6,4034
	@DomainID VARCHAR(10)
	,@ProviderID INT
	,@DT VARCHAR(5)
	,@AccountID INT
AS
BEGIN
	SELECT CONVERT(VARCHAR(MAX), t1.invoice_image) [invoice_image]
		,t2.provider_name
	FROM tblclientaccount t1
	JOIN tblprovider t2 ON t1.Provider_Id = t2.provider_id
	WHERE account_id = @AccountID
		AND t1.provider_id = @ProviderID
		AND Datediff(m, Account_Date, getdate()) <= @DT
		AND t1.DomainId = @DomainID
END
