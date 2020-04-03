CREATE PROCEDURE [dbo].[LCJ_DDL_UserListNames]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
CREATE TABLE #tmpUserList
	(UserId INT, Username varchar(100))

begin
--insert into #tmpAttorney values(0,'...Select Attorney...')
insert into #tmpUserList

	SELECT    UserId, Upper(ISNULL(Username, '')) AS Username
	FROM         IssueTracker_Users
	WHERE     (1 = 1 )

select UserId, Username from #tmpUserList order by 2
end

