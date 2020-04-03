CREATE PROCEDURE [dbo].[delImageFile](
@DomainId NVARCHAR(50),
@fid int,
@cid varchar(50),
@uid varchar(50)
)
as
begin	
declare
@doctype varchar(50),
@ndesc varchar(200)
	Select @doctype =b.document_type from tblimages a inner join tbldocumenttype b on a.documentID=b.document_id where a.ImageId = @fid and a.DomainId=@DomainId
	select @ndesc = 'File ' +  convert(varchar,@fid) + ' of type ' + @doctype  + ' deleted'
	insert into tblnotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId) values (@ndesc,'A',0,@cid,getdate(),@uid,@DomainId)
	--delete from tblimages where imageid =@fid
	update tblimages set deleteflag=1 where imageid=@fid and DomainId=@DomainId
end

