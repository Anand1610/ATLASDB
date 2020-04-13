CREATE PROCEDURE [dbo].[SP_MULTIPLE_FILE_INSERT_TEMPLATE]      
(            
 @DomainId VARCHAR(50),
 @case_id_pom_id [dbo].[CasePomDetails] READONLY,          
 @s_a_filename NVARCHAR(MAX),          
 @s_a_file_path NVARCHAR(MAX)   ,     
 @i_a_basepath_id INT, 
 @i_a_user_id VARCHAR(100)='',    
 @i_a_from_flag int=1
     
)            
AS            
BEGIN  
	DECLARE @totalcounter int
	DECLARE @counter int = 1
	DECLARE @s_a_case_id VARCHAR(20)
	DECLARE @i_a_node_id INT

	DECLARE @TEMP TABLE
	(
		ID INT IDENTITY(1,1) NOT NULL,
		NodeID INT NULL,
		CaseID VARCHAR(20) NULL
	)   
	
	INSERT INTO @TEMP (NodeID,CaseID) SELECT NodeID,CaseID FROM @case_id_pom_id
	set @totalcounter = @@ROWCOUNT



	WHILE(@counter <= @totalcounter)
	BEGIN
		SELECT @s_a_case_id=CaseID,@i_a_node_id=NodeID FROM @TEMP WHERE ID = @counter

		DECLARE @i_l_max_id  INT      
	 SET @i_l_max_id  = 0      
	 DECLARE @i_l_duplicate INT = 0    
	 SELECT @i_l_duplicate = COUNT(*) FROM tblDocImages WHERE
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
     tblDocImages.IsDeleted=0   AND 
     ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	 
	  FilePath = @s_a_file_path AND Filename = @s_a_filename and ImageID in   
	 (SELECT ImageID FROM tblImageTag  WHERE 
	  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
     tblImageTag.IsDeleted=0 AND   
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
	 @DomainId = DomainId AND TagID IN (SELECT NodeID FROM tblTags WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @s_a_case_id)) and DomainId=@DomainId)) and DomainId=@DomainId
	
	 IF(@i_l_duplicate = 0)      
	 BEGIN      
	   INSERT INTO  tblDocImages  (Filename,FilePath,OCRData,Status,from_flag,DomainId, BasePathId)              
	   VALUES (@s_a_filename,@s_a_file_path,'',1  ,@i_a_from_flag,@DomainId, @i_a_basepath_id)
	             
	   SET @i_l_max_id = SCOPE_IDENTITY()            
	      
		INSERT INTO tblImageTag(ImageID,TagID,LoginID,DateInserted,DateModified,DateScanned,DomainId)           	   VALUES (@i_l_max_id,@i_a_node_id,@i_a_user_id,GETDATE(),NULL, NULL,@DomainId)

	  

	   update top(1) cas
	   set cas.status='BILLING SENT' 
	   from tblcase cas
	   where cas.Case_Id = @s_a_case_id and cas.Status='BILLING POM GENERATED'

	  


	 END       
	 --ELSE    
	 --BEGIN
		--SELECT @i_l_max_id = imageid FROM tblDocImages  WHERE FilePath = @s_a_file_path and DomainId=@DomainId
		--AND Filename = @s_a_filename and DomainId = @DomainId and ImageID in 
		--(SELECT ImageID FROM tblImageTag WHERE TagID IN (SELECT NodeID FROM tblTags WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @s_a_case_id)) and DomainId=@DomainId) and DomainId=@DomainId)      
	 --END    
       
	  
	      
	--select @i_a_node_id  ,@i_l_max_id as Imageid,@i_l_duplicate as duplicate   

		SET @counter = @counter + 1
	END
	         
	  
END

