--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[u_BatchBoxDetails] -- [u_BatchBoxDetails] 2,10
  
(  
	@autoid int,
	@files int
	     
)  
AS  
BEGIN
	declare @file_scaned as int
	declare @file_pending as int
	declare @new_file_scaned as int
	declare @new_file_pending as int

	set @file_scaned= (select file_scanned from tblProviderBoxDetails where auto_id=@autoid)
	set @file_pending= (select file_pending from tblProviderBoxDetails where auto_id=@autoid)

	set @new_file_scaned = @file_scaned+@files
	set @new_file_pending = @file_pending -@files
	if @new_file_scaned >=0 and @new_file_pending>=0
		Begin
			update tblProviderBoxDetails 
			set file_pending=@new_file_pending, file_scanned = @new_file_scaned
			where auto_id=@autoid 
		End
End

