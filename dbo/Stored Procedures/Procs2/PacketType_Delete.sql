CREATE PROCEDURE [dbo].[PacketType_Delete]
(
		   @i_a_CaseType_Id			 INT,
		   @s_a_CaseType			 VARCHAR(100),
           @s_a_DomainID			 VARCHAR(50),
	       @s_a_Created_By_User		 VARCHAR(100) 
)
AS
BEGIN
	 DECLARE @s_l_message					NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500),
			 @CaseType	                    VARCHAR(100) 
			
	 BEGIN
		IF EXISTS(select FK_CaseType_Id from dbo.tblPacket WHERE FK_CaseType_Id =@i_a_CaseType_Id and DomainId = @s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Packet Type exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM MST_PacketCaseType  WHERE PK_CaseType_Id = @i_a_CaseType_Id and  DomainId =@s_a_DomainID 
	        
			SET @s_l_message= 'Packet Type deleted'
			SET @s_l_notes_desc = 'Packet Type deleted - ' + @s_a_CaseType 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Packet Type',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END
