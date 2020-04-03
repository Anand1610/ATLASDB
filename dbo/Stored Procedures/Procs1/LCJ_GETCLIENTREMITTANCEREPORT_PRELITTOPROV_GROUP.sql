
CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_PRELITTOPROV_GROUP] --'40558'    
	(
	@dt1 DATETIME
	,@dt2 DATETIME
	,@provider_group VARCHAR(50)
	)
AS
BEGIN
	SELECT tbltransactions.Case_Id
		,Provider_name
		,ISNULL(dbo.tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name
		,dbo.tblcase.Accident_Date
		,CONVERT(VARCHAR(12), dbo.tblcase.DateOfService_Start, 1) AS DateOfService_Start
		,CONVERT(VARCHAR(12), dbo.tblcase.DateOfService_End, 1) AS DateOfService_End
		,ISNULL(CONVERT(MONEY, ISNULL(tblcase.CLAIM_AMOUNT, 0.00)) - CONVERT(MONEY, ISNULL(tblcase.PAID_AMOUNT, 0.00)), 0.00) AS CLAIM_AMOUNT
		,TRANSACTIONS_TYPE
		,TRANSACTIONS_DESCRIPTION
		,TRANSACTIONS_AMOUNT
		,TRANSACTIONS_Fee
		,TRANSACTIONS_dATE
	FROM tbltransactions (NOLOCK)
	INNER JOIN tblcase (NOLOCK) ON tblcase.Case_Id = tblTransactions.Case_Id
	INNER JOIN tblProvider (NOLOCK) ON tblcase.Provider_Id = tblProvider.Provider_Id
	WHERE Invoice_Id IN (
			SELECT Account_Id
			FROM tblclientaccount (NOLOCK)
			WHERE Provider_id IN (
					SELECT Provider_Id
					FROM tblProvider
					WHERE Provider_GroupName = @provider_group
					)
				AND cast(floor(convert(FLOAT, account_date)) AS DATETIME) >= @dt1
				AND cast(floor(convert(FLOAT, account_date)) AS DATETIME) <= @dt2
			)
		AND TRANSACTIONS_TYPE IN ('PreCToP')
END
