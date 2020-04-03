CREATE PROCEDURE [dbo].[GET_BILL_REPORT] --GET_BILL_REPORT 4460,'06/30/2019','08/20/2020','AMT'
	(
	@ProviderId VARCHAR(1000)
	,@DateOfServiceStart DATE
	,@DateOfServiceEnd DATE
	,@DomainId VARCHAR(10)
	)
AS
BEGIN
	SELECT Provider_Name
		,tblCase.Case_Id AS Case_Id
		,ISNULL(Bill_Number, '') AS Bill_Number
		,Convert(VARCHAR(10), tblCase.DateOfService_Start, 101) AS DateOfService_Start
		,Convert(VARCHAR(10), tblCase.DateOfService_End, 101) AS DateOfService_End
		,tbltreatment.Claim_Amount
		,tbltreatment.Paid_Amount
		,Convert(VARCHAR(10), tbltreatment.Date_BillSent, 101) AS Date_BillSent
		,ISNULL(Service_Type, '') AS Service_Type
	FROM tblCase
	INNER JOIN tbltreatment ON tbltreatment.Case_Id = tblCase.Case_Id
	INNER JOIN tblProvider ON tblProvider.Provider_Id = tblCase.Provider_Id
	WHERE tblCase.Provider_Id IN (
			SELECT ITEMS
			FROM dbo.STRING_SPLIT(@ProviderId, ',')
			)
		AND (
			@DateOfServiceStart = ''
			OR CONVERT(DATE, tblCase.DateOfService_Start) >= @DateOfServiceStart
			)
		AND (
			@DateOfServiceEnd = ''
			OR CONVERT(DATE, tblCase.DateOfService_Start) <= @DateOfServiceEnd
			)
		AND tblcase.DomainId = @DomainId
	ORDER BY tblcase.Case_Id DESC
END
