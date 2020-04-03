CREATE PROCEDURE [dbo].[LCJ_DDL_UserRoleNames]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
CREATE TABLE #tmpRolesNames
	(RoleId int, RoleName varchar(25))

begin
--insert into #tmpClientNames values(Null, Null)
--insert into #tmpRolesNames values(0,'...Select Firm...')
insert into #tmpRolesNames

	SELECT  RoleId, RoleName from IssueTracker_Roles --where RoleId In(1,4,5)
	
select RoleId, RoleName from #tmpRolesNames order by 2
end

