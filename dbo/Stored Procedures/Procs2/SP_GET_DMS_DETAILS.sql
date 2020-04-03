CREATE PROCEDURE [dbo].[SP_GET_DMS_DETAILS] --[SP_GET_DMS_DETAILS] '\\ssbwlaw\ssbwdata\Images\IRIS_Documents\Case\',7082,7082,'Not Found'    
 @DEFAULT_PATH varchar(8000)='\\ssbwlaw\ssbwdata\Images\IRIS_Documents\Case\',    
 @START_CASE_ID INT=1,    
 @END_CASE_ID INT=12413,    
 @STATUS_FILTER nvarchar(20)='Not Found'    
AS    
BEGIN    
DECLARE @SQLQUERY VARCHAR(8000)    
DECLARE @FILEPATH VARCHAR(8000)    
DECLARE @i INT    
DECLARE @CASE_ID NVARCHAR(20)    
DECLARE CASE_CURSOR CURSOR FOR    
SELECT DISTINCT CASEID FROM TBLTAGS WHERE CONVERT(INT,CASEID) BETWEEN @START_CASE_ID AND @END_CASE_ID 
and caseid in (select pk_case_id from iris.dbo.tbl_case_details  where file_number like '%ssbw%')
order by caseid    
    
CREATE TABLE #TEMP    
(    
 CASEID NVARCHAR(20),    
 CASE_NAME VARCHAR(8000),    
 FILE_NUMBER VARCHAR(8000),    
 NODENAME NVARCHAR(300),    
 PHYSICAL_PATH VARCHAR(8000),   
 Image_Id varchar(8000),   
 STATUS nvarchar(20)    
)    
    
OPEN CASE_CURSOR      
FETCH NEXT FROM CASE_CURSOR INTO @CASE_ID      
    
 WHILE @@FETCH_STATUS = 0      
 BEGIN    
  DECLARE @NODEID NVARCHAR(20)    
  DECLARE NODE_CURSOR CURSOR FOR    
  SELECT NODEID FROM TBLTAGS WHERE CASEID=@CASE_ID    
    
  OPEN NODE_CURSOR      
  FETCH NEXT FROM NODE_CURSOR INTO @NODEID    
   WHILE @@FETCH_STATUS = 0      
   BEGIN    
   SET @FILEPATH =(SELECT @DEFAULT_PATH+FilePath+FileName from tbldocimages where isnull(is_saga_doc,0)=0 and  imageid =     
     (select top 1 imageid from tblimagetag where tagid = @nodeid))    
     if(ISNULL( @FILEPATH,'')!='')
     begin
     
	   EXEC master..xp_fileexist @FILEPATH, @i out    
	   INSERT INTO #TEMP    
	   SELECT     
		@CASE_ID,     
		(SELECT case_name from IRIS.dbo.tbl_case_details where pk_case_id=@CASE_ID) AS CASE_NAME,    
		(SELECT file_number from IRIS.dbo.tbl_case_details where pk_case_id=@CASE_ID) AS FILE_NUMBER,    
		(SELECT NODENAME FROM TBLTAGS WHERE NODEID=@NODEID) AS NODENAME,    
		(SELECT @DEFAULT_PATH+FilePath+FileName from tbldocimages where imageid =     
		 (select top 1 imageid from tblimagetag where tagid = @nodeid)) AS PHYSICAL_PATH,    
		 (SELECT ImageID from tbldocimages where imageid =     
		 (select top 1 imageid from tblimagetag where tagid = @nodeid)) AS Image_Id,  
		STATUS=(CASE WHEN @i = 1 THEN 'FOUND' ELSE 'NOT FOUND' END)    
    
     end  
   FETCH NEXT FROM NODE_CURSOR INTO @NODEID      
   END      
    
  CLOSE NODE_CURSOR      
  DEALLOCATE NODE_CURSOR      
       
      
 FETCH NEXT FROM CASE_CURSOR INTO @CASE_ID      
 END      
IF @STATUS_FILTER IS NOT NULL    
BEGIN    
 SELECT * FROM #TEMP WHERE STATUS=@STATUS_FILTER and physical_path is not null order by caseid    
END    
ELSE    
BEGIN    
 SELECT * FROM #TEMP where physical_path is not null order by caseid    
END    
    
DROP TABLE #TEMP    
CLOSE CASE_CURSOR      
DEALLOCATE CASE_CURSOR      
    
END

