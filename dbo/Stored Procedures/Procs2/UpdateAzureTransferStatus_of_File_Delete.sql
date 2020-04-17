﻿  
CREATE PROCEDURE [dbo].[UpdateAzureTransferStatus_of_File_Delete]  
 @ImageId int,  
 @TransferStatus varchar(200)--,  
 --@BasePathId int,
 --@FilePath varchar(200) =''
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
       
		Update tblDocImages set azure_statusdone =@TransferStatus
		 where ImageID=@ImageId   
		     ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
       AND IsDeleted =0  
         ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
END  