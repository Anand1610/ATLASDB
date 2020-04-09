CREATE PROCEDURE [dbo].[GET_MONTHLY_CASE_COUNT] @PreviousMonths INT = 6
AS
BEGIN
	DECLARE @cols AS VARCHAR(MAX)
	DECLARE @query AS VARCHAR(MAX)
	DECLARE @horizontalSum AS VARCHAR(MAX)

	SELECT DISTINCT UPPER(DomainId) AS DomainID
	INTO #temp
	FROM tbl_Client(NOLOCK)
	WHERE DomainId IS NOT NULL

	CREATE TABLE #Data (
		DomainId VARCHAR(20)
		,CaseCount INT
		,CaseOpenedMonth INT
		,CaseOpenedYear INT
		)

	DECLARE @FromDateOpened DATE = CONVERT(DATE, DATEADD(MONTH, - @PreviousMonths, GETDATE()))
	DECLARE @ToDateOpened DATE = EOMONTH(@FromDateOpened)
	DECLARE @Counter INT = 1

	WHILE (@Counter <= @PreviousMonths)
	BEGIN
		DECLARE @Month INT = MONTH(@FromDateOpened)
		DECLARE @Year INT = YEAR(@FromDateOpened)

		INSERT INTO #Data
		SELECT t.DomainId [DomainId]
			,COUNT(tc.Case_Id) [Count]
			,@Month [CaseOpenedMonth]
			,@Year [CaseOpenedYear]
		FROM #temp t
		LEFT JOIN tblcase tc(NOLOCK) ON tc.DomainId = t.DomainID
			AND CONVERT(DATE, Date_Opened) BETWEEN @FromDateOpened
				AND @ToDateOpened
			AND isnull(IsDeleted, 0) = 0
		GROUP BY t.DomainId

		SET @FromDateOpened = DATEADD(MONTH, 1, @FromDateOpened)
		SET @ToDateOpened = EOMONTH(@FromDateOpened)
		SET @Counter = @Counter + 1
	END

	SELECT @cols = STUFF((
				SELECT ',' + QUOTENAME(DomainId)
				FROM #Data
				GROUP BY DomainId
				FOR XML PATH('')
					,TYPE
				).value('.', 'VARCHAR(MAX)'), 1, 1, '')

	SELECT @horizontalSum = STUFF((
				SELECT '+' + QUOTENAME(DomainId)
				FROM #Data
				GROUP BY DomainId
				FOR XML PATH('')
					,TYPE
				).value('.', 'VARCHAR(MAX)'), 1, 1, '')

	SET @query = 'SELECT DateName( month , DateAdd( month , [CaseOpenedMonth] , -1 ) ) [Month],CaseOpenedYear [Year],' + @cols + ',(' + @horizontalSum + ') AS Total from
           (
              Select [CaseOpenedMonth], DomainId, CaseCount,CaseOpenedYear
              from #Data
          ) x
          pivot 
          (
              sum(CaseCount)
              for [DomainId] in (' + @cols + ')
          ) p order by p.CaseOpenedYear ,p.[CaseOpenedMonth]'

	EXECUTE (@query);
END
