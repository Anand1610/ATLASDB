
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
	  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
     AND IsDeleted =0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	 --and DomainId='AF' 
	-- end

  
END
