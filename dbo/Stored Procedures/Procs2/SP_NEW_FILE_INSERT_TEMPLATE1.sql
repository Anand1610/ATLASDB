CREATE PROCEDURE [dbo].[SP_NEW_FILE_INSERT_TEMPLATE1]      
(      
@DomainId	  NVARCHAR(50),      
 @s_a_case_id VARCHAR(MAX),          
 @i_a_node_id INT,          
 @s_a_filename NVARCHAR(MAX),          
 @s_a_file_path NVARCHAR(MAX)   ,      
 @i_a_user_id VARCHAR(100)='',    
 @i_a_from_flag int=1 ,
 @date datetime  
)            
AS            
BEGIN               
	 DECLARE @i_l_max_id  INT      
	 SET @i_l_max_id  = 0      
	 DECLARE @i_l_duplicate INT = 0    

	 SELECT @i_l_duplicate = COUNT(*) FROM tblDocImages WHERE 
	   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
     tblDocImages.IsDeleted=0 AND   
     ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
	 FilePath = @s_a_file_path AND Filename = @s_a_filename and ImageID in   
	 (SELECT ImageID FROM tblImageTag WHERE
	  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
   tblImageTag.IsDeleted=0 AND   
     ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	  TagID IN (SELECT NodeID FROM tblTags WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @s_a_case_id))))

	 IF(@i_l_duplicate = 0)      
	 BEGIN      
		   INSERT INTO  tblDocImages (Filename,FilePath,OCRData,Status,from_flag)              
		   VALUES (@s_a_filename,@s_a_file_path,'',1  ,@i_a_from_flag)
		             
		   SET @i_l_max_id = SCOPE_IDENTITY()            
		      
		   INSERT INTO tblImageTag(ImageID,TagID,LoginID,DateInserted,DateModified,DateScanned,DomainId)          
		   VALUES (@i_l_max_id,@i_a_node_id,@i_a_user_id,@date,NULL, NULL,@DomainId)        
	 END       
	 ELSE    
	 BEGIN
			SELECT @i_l_max_id = imageid FROM tblDocImages WHERE 
			 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
           tblImageTag.IsDeleted=0 AND    
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
			
			FilePath = @s_a_file_path 
			AND Filename = @s_a_filename and ImageID in 
			(SELECT ImageID FROM tblImageTag WHERE TagID IN (SELECT NodeID FROM tblTags WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @s_a_case_id))))      
	 END    
          
	select @i_a_node_id  ,@i_l_max_id as Imageid,@i_l_duplicate as duplicate    
END

GO


