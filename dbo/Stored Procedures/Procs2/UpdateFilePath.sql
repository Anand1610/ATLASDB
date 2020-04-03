
CREATE PROCEDURE [dbo].[UpdateFilePath]

@ImageId int,
@TransferStatus varchar(200),
@BasePathId int,
@filepath varchar(400),
@filename varchar(100)
AS
BEGIN
	
	SET NOCOUNT ON;

	 update tblDocImages set statusdone =@TransferStatus,BasePathId=@BasePathId,filepath = @filepath,Filename =@filename
	 where ImageID=@ImageId 
	

  
END
