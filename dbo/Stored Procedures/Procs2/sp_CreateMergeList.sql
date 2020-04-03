CREATE PROCEDURE [dbo].[sp_CreateMergeList](
@idList nvarchar(4000)
)
as
begin
declare
@sq nvarchar(4000)

set @sq = 'select ImagePath + ''\'' + FileName as [FilePath],documentId from tblimages where ImageId in (' + @idList + ')'
--print @sq

exec sp_executesql @sq
end

