CREATE PROCEDURE [dbo].[proc_test]
	
AS
BEGIN	
	SET NOCOUNT ON;
    DECLARE @username as varchar(50)
    DECLARE @userid as varchar(50)
    DECLARE @caseid as varchar(50)
    DECLARE @date as varchar(50)
    DECLARE @nodeid as int
    DECLARE @FileName as varchar(200)
    DECLARE @Filepath as varchar(200)
    
    DECLARE CUR CURSOR
    FOR select sz_user_id,sz_case_id,Dt_upload_time from dbo. TXN_DOCUMENT_UPLOAD where SZ_FILENAME like '%ARBITRATION_DOC%' and sz_case_id='FH13-162991'
    OPEN CUR
    FETCH CUR INTO @username,@caseid,@date
    WHILE @@FETCH_STATUS = 0
    BEGIN
    SET @userid=(select UserId from dbo.IssueTracker_Users where UserName =(LTRIM (Rtrim(@username))))
    EXEC STP_DSP_TREEVIEWCASEID '',@caseid,@caseid,'','Folder.gif',1,1,0
    set @nodeid=(select NodeID from MST_DOCUMENT_NODES where NodeName ='ARB Docs')
    set @FileName =(@caseid+'_ARB_FILED_'+ replace(convert(varchar, @date, 101), '/','-')+'.pdf')
    set @Filepath = (@caseid+'/ARB Docs/')
    EXEC SP_NEW_FILE_INSERT_TEMPLATE @caseid,@nodeid,@FileName,@Filepath,@userid,1
    FETCH CUR INTO @username,@caseid,@date
    END
    CLOSE CUR
    DEALLOCATE CUR
END

