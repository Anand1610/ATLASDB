CREATE PROCEDURE [dbo].[LCJ_Admin_DeleteDesks]
(
@DomainId nvarchar(50),
@Username nvarchar(50),
@Desk_Id nvarchar(3000)
)
AS
BEGIN
DECLARE
@ST NVARCHAR(3500)
IF @Username <> '' AND @Desk_Id <> ''
BEGIN

SET @ST = 'Delete from tblUserDesk where UserName = '''+@Username+''' AND Desk_Id In (' + @Desk_Id + ') AND DomainId = '''+@DomainId+''''
PRINT @ST
EXEC SP_EXECUTESQL @ST
END
END

