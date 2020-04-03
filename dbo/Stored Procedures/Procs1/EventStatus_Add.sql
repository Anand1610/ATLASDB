

CREATE PROCEDURE [dbo].[EventStatus_Add]
(
@i_a_EventStatusId	INT,
@s_a_EventStatusName		VARCHAR(100),
@s_a_DomainID			VARCHAR(50),
@s_a_Created_By_User	VARCHAR(100)
)
AS
BEGIN
		SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_EventStatusName	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)


	SET @s_a_EventStatusName = LTRIM(RTRIM(@s_a_EventStatusName))
	IF(@i_a_EventStatusId = 0)
	BEGIN
	    IF EXISTS(SELECT EventStatusName FROM tblEventStatus WHERE EventStatusName = @s_a_EventStatusName and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Event status already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END

	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblEventStatus
		      (
			      EventStatusName,
				  DomainID,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_EventStatusName,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Event status details saved successfully...'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Event Status -'+	@s_a_EventStatusName	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Event Status',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT EventStatusName FROM tblEventStatus WHERE EventStatusName = @s_a_EventStatusName and DomainID = @s_a_DomainID and EventStatusId <> @i_a_EventStatusId)
		BEGIN
			BEGIN TRAN
		
			DECLARE @oldEvent_Status VARCHAR(200)

			SET @oldEvent_Status = (SELECT TOP 1 EventStatusName FROM tblEventStatus WHERE  EventStatusId = @i_a_EventStatusId and DomainID = @s_a_DomainID )
		
			IF(@s_a_EventStatusName<> @oldEvent_Status)
			BEGIN
				UPDATE tblEventStatus
				SET 
					 EventStatusName		= @s_a_EventStatusName,
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE()
				WHERE 
					 EventStatusId = @i_a_EventStatusId
					 and DomainID = @s_a_DomainID

				SET @s_l_notes_desc = 'Updated Event Status-'+	 @s_a_EventStatusName	
            
				EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Event Status',@DomainID =@s_a_DomainID 
		        
			END

			SET @s_l_message	=  'Event Status details updated successfully'
			SET @i_l_result	=  @i_a_EventStatusId
		
			                                 
			COMMIT TRAN	
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save, Event status already exist...' 
			SET @i_l_result	=  @i_a_EventStatusId
		END
		
	END

	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END	
