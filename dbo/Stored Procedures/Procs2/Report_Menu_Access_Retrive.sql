
CREATE PROCEDURE [dbo].[Report_Menu_Access_Retrive] -- [ReportMenu_Access_Retrive] 'ALLReportMenu'
(
	@s_a_Type Varchar(200),
	@DomainId Varchar(200)= null,
	@roleid Varchar(200)=null,
	@ReportMenuID Varchar(200)=null
)
AS
begin
SET NOCOUNT ON;

	IF(@s_a_Type = 'ALLReportMenu')
    BEGIN 
		select * from tblMenu_Report WHERE ReportMenuId IN (select ReportMenuId from tblMenu_Report_Domain_Access WHERE DomainId=@DomainId)
	END	 	
	ELSE IF(@s_a_Type = 'SelectedRole')
    BEGIN
		select ReportMenuID,Menuname from tblMenu_Report
		where ReportMenuID in (select ReportMenuID  from tblMenu_Report_access where DomainId = @DomainId and roleid=@roleid And parentid is Not null)
		UNION
		select ReportMenuID,Menuname from tblMenu_Report
		where ReportMenuID in (select ReportMenuID  from tblMenu_Report_access where DomainId = @DomainId and roleid=@roleid 
		And parentid is null and ReportMenuID NOT IN(SELECT ISNULL(parentid,'') From tblMenu_Report))
    END
 	
END
 

