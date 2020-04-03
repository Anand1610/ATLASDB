CREATE PROCEDURE [dbo].[SelectAllProvider_Name]  
(  
@DomainId nvarchar(50)  
)  
as  
begin  
SELECT '0' AS Provider_Id,' ---Select Provider--- ' AS Provider_Name
  UNION
select Provider_Id,Provider_Name + isnull('['+ provider_groupname + ']','') as Provider_Name from tblProvider WHERE @DomainId = DomainId order by Provider_Name  
end  
  
