CREATE PROCEDURE [dbo].[SP_DM_FILE_RENAME]
(  
	@DomainId	VARCHAR(50),    
	@i_a_image_id BIGINT,    
	@s_a_file_name VARCHAR(MAX),    	
	@i_a_user_id int =0   ,
	@i_a_from_flag	int=2
)      
AS      
BEGIN      
	UPDATE 
		tblDocImages    
	SET 
		Filename=@s_a_file_name,
		from_flag=@i_a_from_flag	
	WHERE 
		imageid=@i_a_image_id
	AND	DomainId=@DomainId
		
	UPDATE 
		tblImageTag 
	SET 
		DateModified=GETDATE()
	WHERE 
		IMAGEID=@i_a_image_id
	AND DomainId=@DomainId
		
	IF EXISTS(SELECT 1 FROM tbl_ImageTag_Modifiedby  WHERE imageid =@i_a_image_id and DomainId=@DomainId)
		BEGIN
			UPDATE 
				tbl_ImageTag_Modifiedby    
			SET 
				modified_by=@i_a_user_id
			WHERE	
				imageid=@i_a_image_id
			AND DomainId=@DomainId
		END
	ELSE
		BEGIN
			INSERT INTO tbl_ImageTag_Modifiedby 
			VALUES(@i_a_image_id,@i_a_user_id,@DomainId)
		END
	
END

