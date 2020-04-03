Create PROCEDURE [dbo].[template_word_insert] 
(
	 @s_a_DomainID				varchar(50)		=	'',
	 @i_a_pk_template_id		INT,
	 @s_a_template_name			VARCHAR(200),
	 @s_a_template_file_name	VARCHAR (200),
	 @i_a_default_node_id		int	=	null,
	 @s_a_created_by  			varchar(100)	=	'admin',
	 @s_a_remarks				VARCHAR(4000),
	 @i_a_status_id             int,
	 @i_a_BasePathId			int,
	 @s_a_template_path			varchar(4000)
)
AS  
BEGIN  
SET NOCOUNT ON
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_template_name	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	--DECLARE @s_a_Created_By_User NVARCHAR(100)

	--SET @s_a_Created_By_User = (select TOP 1 UserName from IssueTracker_Users WHERE UserId = @i_a_created_by)
	IF(@i_a_pk_template_id = 0)
	BEGIN
	    IF EXISTS(SELECT template_name FROM tbl_template_word WHERE template_name = @s_a_template_name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Template already exists..!!!'
		   SET @i_l_result	=  0
	    END
	    ELSE
	    BEGIN
	        BEGIN TRAN
		      INSERT INTO tbl_template_word
		      (
			      template_name,
				  template_file_name,
				  template_path,
				  remarks,
				  fk_default_node_id,
				  DomainID,
			      created_by_user,
			      created_date,
				  Status_Id,
				  BasePathId
		      )
		      VALUES
		      (
                  @s_a_template_name,
				  @s_a_template_file_name,
				  @s_a_template_path,		--'/'+ @s_a_DomainID +'/' +@s_a_template_file_name,
				  @s_a_remarks,
				  @i_a_default_node_id,
				  @s_a_DomainID,
                  @s_a_created_by,
                  GETDATE(),
				  @i_a_status_id,
				  @i_a_BasePathId
		      )
		      SET @s_l_message	=  'Template details saved successfully'
		      SET @i_l_result	=  SCOPE_IDENTITY()		      
		      
		      SET @s_l_notes_desc = 'Added Template -'+	 @s_a_template_name	

		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_created_by,@s_a_notes_type='Template Word',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT template_name FROM tbl_template_word WHERE template_name = @s_a_template_name and DomainID = @s_a_DomainID and pk_template_id <> @i_a_pk_template_id)
		BEGIN
			BEGIN TRAN		
				DECLARE @old_template_word VARCHAR(200)

				SET @old_template_word = (SELECT TOP 1 template_name FROM tbl_template_word WHERE  pk_template_id = @i_a_pk_template_id and DomainID = @s_a_DomainID )
		
				--IF(@s_a_template_name<> @old_template_word)
				--BEGIN
					UPDATE tbl_template_word
					SET 
						 template_name		=	@s_a_template_name,
						 remarks			=	@s_a_remarks,
						 fk_default_node_id =	@i_a_default_node_id,
						 modified_by_user	=	@s_a_created_by,
						 modified_date		=	GETDATE(),
						 Status_Id          =   @i_a_status_id
					WHERE 
						 pk_template_id		=	@i_a_pk_template_id
						 and DomainID		=	@s_a_DomainID			

					SET @s_l_notes_desc = 'Updated Template -'+	 @s_a_template_name	            
					EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_created_by,@s_a_notes_type='Template Word',@DomainID =@s_a_DomainID 
		        
				--END
				SET @s_l_message	=  'Template details updated successfully'
				SET @i_l_result		=  @i_a_pk_template_id		
			                                 
			COMMIT TRAN		
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save, Template name already exist...' --Template Status details updated successfuly'
			SET @i_l_result	=  @i_a_pk_template_id
		END
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	
SET NOCOUNT OFF  
END
