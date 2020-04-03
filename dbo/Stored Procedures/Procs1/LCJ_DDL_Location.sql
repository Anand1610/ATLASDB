CREATE PROCEDURE [dbo].[LCJ_DDL_Location]
@DomainId NVARCHAR(50)
AS


BEGIN
	
	select Location_Id, isnull (Location_Address,'') +', '+isnull (Location_City,'')+', '+isnull (Location_State,'')+ ' '+isnull (Location_Zip,'') as addresss  from MST_Service_Rendered_Location WHERE DomainId=@DomainId

END

