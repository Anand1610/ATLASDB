CREATE PROCEDURE [dbo].[proc_test1]	
AS
BEGIN	
	SET NOCOUNT ON;
    DECLARE @username as varchar(50)
    DECLARE @userid as varchar(50)
    DECLARE @caseid as varchar(50)
    DECLARE @date as datetime
    DECLARE @tagid as int
    DECLARE @FileName as varchar(200)
    DECLARE @Filepath as varchar(200)
    declare @a as int
    
    DECLARE CUR CURSOR
    FOR select sz_user_id,sz_case_id,Dt_upload_time from dbo. TXN_DOCUMENT_UPLOAD where SZ_FILENAME like '%ARBITRATION_DOC%'
	
    OPEN CUR
    FETCH CUR INTO @username,@caseid,@date
    WHILE @@FETCH_STATUS = 0
    BEGIN
    SET @userid=(select UserId from dbo.IssueTracker_Users where UserName =(LTRIM (Rtrim(@username))))
   
    set @FileName =(@caseid+'_ARB_FILED_'+ replace(convert(varchar, @date, 101), '/','-')+'.pdf')
    set @Filepath = (@caseid+'/ARB Docs/')
     SELECT @a=COUNT(*) FROM tblDocImages WHERE FilePath = @Filepath AND Filename = @FileName 
	  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
       AND tblDocImages.IsDeleted=0   
     ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	 and ImageID in   
	 (SELECT ImageID FROM tblImageTag WHERE 
	   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
      tblImageTag.IsDeleted=0   AND
     ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	 
	 TagID IN (SELECT NodeID FROM tblTags WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @caseid))))
if(@a>1)
begin
print (@caseid)
print (@a)
end
    FETCH CUR INTO @username,@caseid,@date
    END
    CLOSE CUR
    DEALLOCATE CUR
END

