CREATE PROCEDURE [dbo].[procInsertCopyImage](
@imageid int,
@cid varchar(50))
as 
begin
insert into tblimages(ImagePath,FileName,DocumentId,Case_Id,ScanDate,UserId,RecordDescriptor,DeleteFlag)
select ImagePath,FileName,DocumentId,@cid,getdate(),userid,'',0 from tblimages where imageid=@imageid
end

