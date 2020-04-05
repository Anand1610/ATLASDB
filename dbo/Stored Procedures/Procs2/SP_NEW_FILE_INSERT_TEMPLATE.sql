CREATE PROCEDURE [dbo].[SP_NEW_FILE_INSERT_TEMPLATE]      
(            
 @DomainId NVARCHAR(50),
 @s_a_case_id  NVARCHAR(50),          
 @i_a_node_id INT,          
 @s_a_filename VARCHAR(255),          
 @s_a_file_path VARCHAR(255)   ,     
 @i_a_basepath_id INT, 
 @i_a_user_id VARCHAR(100)='',    
 @i_a_from_flag int=1
     
)            
AS            
BEGIN               
	 DECLARE @i_l_max_id  INT      
	 SET @i_l_max_id  = 0      
	 DECLARE @i_l_duplicate INT = 0    
	 SELECT @i_l_duplicate = COUNT(1) FROM tblDocImages (NOLOCK) 
	 WHERE FilePath = @s_a_file_path AND Filename = @s_a_filename and ImageID in   
	 (SELECT ImageID FROM tblImageTag (NOLOCK)  WHERE @DomainId = DomainId 
	 AND TagID IN (SELECT NodeID 
					FROM tblTags (NOLOCK) WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @s_a_case_id)) and DomainId=@DomainId)) and DomainId=@DomainId
	
	 IF(@i_l_duplicate = 0)      
	 BEGIN      
	   INSERT INTO  tblDocImages  (Filename,FilePath,OCRData,Status,from_flag,DomainId, BasePathId)              
	   VALUES (@s_a_filename,@s_a_file_path,'',1  ,@i_a_from_flag,@DomainId, @i_a_basepath_id)
	             
	   SET @i_l_max_id = SCOPE_IDENTITY()            
	      
	   INSERT INTO tblImageTag(ImageID,TagID,LoginID,DateInserted,DateModified,DateScanned,DomainId)           
	   VALUES (@i_l_max_id,@i_a_node_id,@i_a_user_id,GETDATE(),NULL, NULL,@DomainId)
	 END       
	 ELSE    
	 BEGIN
		SELECT @i_l_max_id = imageid FROM tblDocImages  WHERE FilePath = @s_a_file_path and DomainId=@DomainId
		AND Filename = @s_a_filename and DomainId = @DomainId and ImageID in 
		(SELECT ImageID FROM tblImageTag WHERE TagID IN (SELECT NodeID FROM tblTags WHERE ltrim(rtrim( caseid)) = ltrim(rtrim( @s_a_case_id)) and DomainId=@DomainId) and DomainId=@DomainId)      
	 END    
       
	  
	      
	select @i_a_node_id  ,@i_l_max_id as Imageid,@i_l_duplicate as duplicate    
END

GO


