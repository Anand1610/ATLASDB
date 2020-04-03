
CREATE PROCEDURE [dbo].[UpdateAzureTransferStatus_of_File]

@ImageId int,
@TransferStatus varchar(200),
@BasePathId int
AS
BEGIN
	
	SET NOCOUNT ON;
	-- if exists(select * from tblDocImages where ImageID =@ImageId )
	 --begin
	 update tblDocImages set statusdone =@TransferStatus,BasePathId=@BasePathId where ImageID=@ImageId 
	 --and DomainId='AF' 
	-- end

  
END
