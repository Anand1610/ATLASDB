CREATE PROCEDURE [dbo].[SP_UPDATE_DOCUMENT_MANAGER]  --  @SZ_OLD_CASE_ID='ZF09-211',@SZ_NEW_CASE_ID='ZF09-211'
(
	@SZ_OLD_CASE_ID AS NVARCHAR(20),
	@SZ_NEW_CASE_ID AS NVARCHAR(20)
)
as
begin

UPDATE dbo.TEST_PRI SET DM_Transfer = 1 where Case_ID_Old = @SZ_OLD_CASE_ID
	BEGIN TRANSACTION TRAN_UPDATE_DOCUMENT_MANAGER
	-- update document manager entries
		--declare @new_old_case_id nvarchar(20)
		--declare	@temp_image_id nvarchar(20)
		--declare	@temp_file_path nvarchar(2000)
	
		UPDATE tblTags SET CASEID = @SZ_NEW_CASE_ID WHERE CASEID = @SZ_OLD_CASE_ID
		UPDATE tbltags set nodename = @SZ_NEW_CASE_ID where CASEID = @SZ_NEW_CASE_ID  and parentid is null

		update tbldocimages set FilePath = replace(replace(FilePath,@SZ_OLD_CASE_ID,@SZ_NEW_CASE_ID),'/','\')
		where FilePath like '%' +@SZ_OLD_CASE_ID +'%'
			
		
		
		
	IF @@ERROR <> 0
		ROLLBACK
	ELSE
		COMMIT TRANSACTION TRAN_UPDATE_DOCUMENT_MANAGER

end

