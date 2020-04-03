CREATE PROCEDURE [dbo].[LCJ_DDL_RoleNames]
@DomainId NVARCHAR(50)
AS
CREATE TABLE #tmpRolesNames
	(RoleId int, RoleName varchar(50))

begin
insert into #tmpRolesNames

	SELECT  RoleId, RoleName from IssueTracker_Roles WHERE DomainId=@DomainId
	
select RoleId, RoleName from #tmpRolesNames order by 2
end

