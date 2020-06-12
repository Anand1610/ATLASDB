CREATE PROCEDURE [dbo].[MotionType_Delete]
(
		   @i_a_MotionType_Id		 INT,
		   @s_a_MotionType			 VARCHAR(100),
           @s_a_DomainID			 VARCHAR(50),
	       @s_a_Created_By_User		 VARCHAR(100) 
)
AS
BEGIN
	 DECLARE @s_l_message					NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500),
			 @CaseType	                    VARCHAR(100) 
			
	 BEGIN
		IF EXISTS(select MotionTypeId from dbo.tblCaseDateMotionMapping WHERE MotionTypeId =@i_a_MotionType_Id and DomainId = @s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Motion Type used in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblMotionType  WHERE MotionTypeId = @i_a_MotionType_Id and  DomainId =@s_a_DomainID 
	        
			SET @s_l_message= 'Motion Type deleted'
			SET @s_l_notes_desc = 'Motion Type deleted - ' + @s_a_MotionType + ' MotionTypeId:' + cast(@i_a_MotionType_Id as varchar(100))
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Motion Type',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END