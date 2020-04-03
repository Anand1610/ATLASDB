CREATE PROCEDURE [dbo].[LCJ_ADMIN_GETPROVIDERS]

@DomainId NVARCHAR(50)
AS

Select Provider_Id, LTRIM(RTRIM(UPPER(Provider_Name))) AS Provider_Name  from tblProvider where 1=1 and DomainId=@DomainId

