CREATE PROCEDURE [dbo].[sp_insertPDF] (
@imagePath nvarchar(255),
@newfile nvarchar(255),
@documentId varchar(50),
@Case_Id varchar(50),
@user_id varchar(50),
@RecordDescriptor nvarchar(100)
)
as
begin

insert into tblimages values (@imagePath,@newfile,@documentId,@Case_Id,getdate(),@user_id,@RecordDescriptor,0,'dk')


end

