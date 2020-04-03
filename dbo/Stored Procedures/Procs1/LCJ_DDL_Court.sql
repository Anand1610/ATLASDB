CREATE PROCEDURE [dbo].[LCJ_DDL_Court]
(
	@DomainId NVARCHAR(50)
)
AS
begin

   SELECT '0' as Court_ID,' --- Select Court Name --- ' as Court_Name
    UNION
	SELECT   DISTINCT Court_ID, Upper(ISNULL(RTRIM(LTRIM(Court_Name)), ''))+'('+ISNULL(Court_Misc,'')+')' AS Court_Name
	FROM         tblCourt
	WHERE     (1 = 1) and DomainId=@domainId order by Court_Id

end

