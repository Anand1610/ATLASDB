--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[S_BatchBoxDetails] -- [S_BatchBoxDetails] 869
  
(  
	@autoid varchar(50)      
)  
AS  
BEGIN
	select * from tblProviderBoxDetails where auto_id=@autoid 
End

