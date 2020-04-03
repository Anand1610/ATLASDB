CREATE PROCEDURE [dbo].[EMAIL_GET_STATUS_REPORT]
AS
BEGIN
	select Status,COUNT(*) as [Count of Cases] from tblcase
	where Status like 'AAA%'
	group by Status
	ORDER BY STATUS

	select 'Total:' as Status,COUNT(*) as [Total Cases] from tblcase
	where Status like 'AAA%' 
END

