
CREATE PROCEDURE [dbo].[F_M_DenialReason_Delete] 
		(
			@DomainId NVARCHAR(50),
			@i_a_DenialReason_id		    INT,
			@s_l_username				NVARCHAR(100)
		)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			@desc						VARCHAR(200),
			@s_l_notes_desc				NVARCHAR(500),
			@s_l_DenialReason		    NVARCHAR(200),
			@UsedCount int=0

		SELECT		@UsedCount= COUNT(PK_ID)
		FROM		MST_DenialReasons M
		INNER JOIN	tbl_Case_Denial C ON C.FK_Denial_ID=M.PK_Denial_ID 
		WHERE		M.DomainId=@DomainId AND C.FK_Denial_ID=@i_a_DenialReason_id
	 
		SELECT @s_l_DenialReason= DenialReason FROM MST_DenialReasons  WHERE PK_Denial_ID=@i_a_DenialReason_id and DomainId = @DomainId
		
		IF @UsedCount = 0		
		BEGIN
				DELETE FROM MST_DenialReasons  WHERE PK_Denial_ID=@i_a_DenialReason_id and DomainId = @DomainId
				SET @s_l_message='DenialReason deleted'
				SET @s_l_notes_desc = 'DenialReason deleted:'+@s_l_DenialReason
				EXEC F_AdminNotes_Add @DomainId=@DomainId,@s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_username,@s_a_notes_type='DenialReason'
				SELECT @s_l_message AS [MESSAGE]				
        End
		ELSE
		BEGIN

			SELECT @UsedCount		

		END	
END

