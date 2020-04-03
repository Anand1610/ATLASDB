CREATE PROCEDURE [dbo].[F_M_DenialReasons_Insert]    
	( 
		 @DomainId NVARCHAR(50), 
		 @i_a_DenialReasonID INT,
		 @s_a_DenialReason  NVARCHAR(200),
		 @s_l_UserID		NVARCHAR(100)
	)    
	AS    
	 BEGIN 
		DECLARE @s_l_message NVARCHAR(500),
				@desc VARCHAR(200),
				@s_l_notes_desc NVARCHAR(500),
				@i_l_result		INT
			  
	    IF(@i_a_DenialReasonID=0) 
			BEGIN     
				INSERT INTO MST_DenialReasons    
				(    
					DenialReason,
					DomainId  
				)    
				VALUES
				(    
					@s_a_DenialReason,
					@DomainId 
				)  
				SET @s_l_message='Denial Reason added Successfully'
				SET @i_l_result		=  SCOPE_IDENTITY()
				SET @s_l_notes_desc = 'DenialReason added-'+@s_a_DenialReason
				EXEC F_AdminNotes_Add @DomainId = @DomainId, @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_UserID,@s_a_notes_type='DenialReason'
				SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
			END
			
		IF(@i_a_DenialReasonID<>0)
			BEGIN
				UPDATE MST_DenialReasons
				SET
					DenialReason=@s_a_DenialReason,
					DomainId=@DomainId
				WHERE		
					PK_Denial_ID=@i_a_DenialReasonID
				SET @s_l_message='Denial Reason updated Successfully'
				SET @i_l_result		=  SCOPE_IDENTITY()
				SET @s_l_notes_desc = 'DenialReason updated-'+@s_a_DenialReason
				EXEC F_AdminNotes_Add @DomainId = @DomainId, @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_UserID,@s_a_notes_type='DenialReason'
				SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]	
			END 
		END



		SELECT * FROM MST_DenialReasons

