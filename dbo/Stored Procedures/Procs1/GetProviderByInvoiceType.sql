
CREATE PROCEDURE [dbo].[GetProviderByInvoiceType] --GetProviderByInvoiceType 'D','af'
	@s_a_Value VARCHAR(5)
	,@DomainId VARCHAR(10)
AS
BEGIN
	SELECT provider_id
		,provider_name
	FROM tblprovider
	WHERE invoice_type = @s_a_Value
		AND DomainId = @DomainId
	ORDER BY provider_name
END
