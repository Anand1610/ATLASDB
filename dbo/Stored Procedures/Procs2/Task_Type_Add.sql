
CREATE PROCEDURE [dbo].[Task_Type_Add]
(
   @i_a_Task_Type_ID	 INT,
   @s_a_Description		 VARCHAR(100),
   @s_a_DomainID		 VARCHAR(50),   
   @s_a_Comments	     VARCHAR(50),   
   @s_a_Deadline_Day     VARCHAR(200),
   @s_a_Created_By_User	 VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from Task_Type
	-- Task_Type_ID	
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_Status				VARCHAR(200)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
	IF(@i_a_Task_Type_ID = 0)
	BEGIN
	    IF EXISTS(SELECT Description FROM Task_Type WHERE Description = @s_a_Description and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Task already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO Task_Type
		      (
			      Description,
				  DomainID,
				  Comments,
				  Deadline_Day,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Description,
				  @s_a_DomainID,
				  @s_a_Comments,
				  @s_a_Deadline_Day,								 
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message		=  'Task  details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Task -'+	 @s_a_Description	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='TaskType',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldDescription VARCHAR(200)

		SET @oldDescription = (SELECT TOP 1 Description FROM Task_Type WHERE  Task_Type_ID = @i_a_Task_Type_ID and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Description FROM Task_Type WHERE  Task_Type_ID <>  @i_a_Task_Type_ID and Description= @s_a_Description and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE Task_Type
			SET 
				 Description		= @s_a_Description,                 			
				 Comments			= @s_a_Comments,
				 Deadline_Day		= @s_a_Deadline_Day,				 
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Task_Type_ID = @i_a_Task_Type_ID
				 and DomainID = @s_a_DomainID

			

			SET @s_l_message	=  'Task  details updated successfully'
			SET @i_l_result		=  @i_a_Task_Type_ID
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Task  already exist. You can not change the Task '
			SET @i_l_result		=  @i_a_Task_Type_ID
		END
		
		
		SET @s_l_notes_desc = 'Updated Task -'+	 @s_a_Description	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='TaskType',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
