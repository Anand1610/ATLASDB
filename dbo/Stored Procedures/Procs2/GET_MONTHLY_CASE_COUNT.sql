CREATE PROCEDURE [dbo].[GET_MONTHLY_CASE_COUNT]
AS
BEGIN
	SELECT UPPER(DomainId) [DomainId]
		,COUNT(Case_Id) [Count]
		,DATENAME(MONTH, Date_Opened) [CaseOpenedMonth]
		,YEAR(Date_Opened) [CaseOpenedYear]
	FROM tblCase
	WHERE MONTH(Date_Opened) = MONTH(GETDATE() - 1)
		AND YEAR(Date_Opened) = YEAR(GETDATE())
		AND isnull(IsDeleted, 0) = 0
		AND UPPER(DomainId) <> 'TEST'
	GROUP BY DomainId
		,DATENAME(MONTH, Date_Opened)
		,YEAR(Date_Opened)
	ORDER BY DomainID
END