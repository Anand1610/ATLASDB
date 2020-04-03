


CREATE PROCEDURE [dbo].[EventType_Add]
(
@i_a_EventTypeId	INT,
@s_a_EventTypeName		VARCHAR(100),
@s_a_DomainID			VARCHAR(50),
@s_a_Created_By_User	VARCHAR(100)
)
AS
BEGIN
		SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_EventTypeName	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)


	SET @s_a_EventTypeName = LTRIM(RTRIM(@s_a_EventTypeName))
	IF(@i_a_EventTypeId = 0)
	BEGIN
	    IF EXISTS(SELECT EventTypeName FROM tblEventType WHERE EventTypeName = @s_a_EventTypeName and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Event Type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END

	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblEventType
		      (
			      EventTypeName,
				  DomainID,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_EventTypeName,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Event Type details saved successfully...'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Event Type -'+	@s_a_EventTypeName	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Event Type',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT EventTypeName FROM tblEventType WHERE EventTypeName = @s_a_EventTypeName and DomainID = @s_a_DomainID and EventTypeId <> @i_a_EventTypeId)
		BEGIN

			BEGIN TRAN
			DECLARE @oldEvent_Type VARCHAR(200)

			SET @oldEvent_Type = (SELECT TOP 1 EventTypeName FROM tblEventType WHERE  EventTypeId = @i_a_EventTypeId and DomainID = @s_a_DomainID )

			
			IF(@s_a_EventTypeName<> @oldEvent_Type)
			BEGIN
				UPDATE tblEventType
				SET 
					 EventTypeName		= @s_a_EventTypeName,
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE()
				WHERE 
					 EventTypeId = @i_a_EventTypeId
					 and DomainID = @s_a_DomainID

				SET @s_l_notes_desc = 'Updated Event Type-'+	 @s_a_EventTypeName	
            
				EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Event Type',@DomainID =@s_a_DomainID 
		       

			END

			SET @s_l_message	=  'Event Type details updated successfully'
			SET @i_l_result	=  @i_a_EventTypeId
		
			                                  
			COMMIT TRAN	
		END
		BEGIN
			SET @s_l_message	=  'Cannot save, Event Type already exist...' 
			SET @i_l_result	=  @i_a_EventTypeId
		END
	END

	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END	
