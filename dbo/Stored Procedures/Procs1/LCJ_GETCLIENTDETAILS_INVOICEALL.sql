CREATE PROCEDURE [dbo].[LCJ_GETCLIENTDETAILS_INVOICEALL] (
	@FromDate DATETIME
	,@ToDate DATETIME
	,@DomainId VARCHAR(20)
	)
AS
BEGIN
	
	SELECT	 a.Provider_Name
			,b.Account_Id
			,b.Provider_Id 
			,b.Invoice_Image
			,b.Account_Date
			,a.PROVIDER_NAME
			,a.Provider_Local_Address
			,a.Provider_Local_City
			,a.Provider_Local_State
			,a.Provider_Local_Zip
			,ISNULL(tbl_Client.LawFirmName,'') AS LawFirmName
			,ISNULL(tbl_Client.client_header,'') AS client_header
	FROM	tblprovider a (NOLOCK)
	INNER	JOIN TBLCLIENTACCOUNT b (NOLOCK) ON a.provider_id = b.provider_id
	LEFT	OUTER JOIN tbl_Client (NOLOCK) ON tbl_Client.DomainId = a.DomainId
	WHERE	CAST(CONVERT(VARCHAR(10),b.account_date,101) AS DATETIME) >= @FromDate
	AND		CAST(CONVERT(VARCHAR(10),b.account_date,101) AS DATETIME) <= @ToDate
	AND		b.domainid = @DomainId
	ORDER	BY a.provider_name
			,account_date
END

