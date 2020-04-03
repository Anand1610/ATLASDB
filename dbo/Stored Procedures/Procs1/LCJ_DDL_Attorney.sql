CREATE PROCEDURE [dbo].[LCJ_DDL_Attorney]
@DomainId NVARCHAR(50)
AS
begin

 select Attorney_Id, Ltrim(Upper(ISNULL(Attorney_FirstName, '') + ' ' +  ISNULL(Attorney_LastName, ''))) as Attorney_Name from tblAttorney  
 WHERE DomainId = @DomainId
 order by Attorney_Name

	--SELECT  UserName, UserId FROM IssueTracker_Users WHERE RoleId = 22
 --   ORDER BY UserName

end

