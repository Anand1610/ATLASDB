--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[F_DenialReasons_Add]  
  
(  
	  @DomainId nvarchar(50),
	  @s_a_case_id NVARCHAR(200),
	  @i_a_denial_id INT,
	  @s_a_user_id NVARCHAR(100)
)  
AS 
	BEGIN 
		DECLARE	@s_l_notes VARCHAR(200),
				@s_l_denial_reason_type NVARCHAR(200)
    
			 IF NOT EXISTS (SELECT * FROM tbl_Case_Denial  WHERE FK_Denial_ID=@i_a_denial_id and Case_Id=@s_a_case_id and DomainId = @DomainId)
			 BEGIN
				
				
				INSERT INTO tbl_Case_Denial (FK_Denial_ID,Case_Id, DomainId) 
				VALUES (@i_a_denial_id,@s_a_case_id, @DomainId)
				
				SET @s_l_denial_reason_type=(SELECT DenialReason FROM MST_DenialReasons  WHERE PK_Denial_ID=@i_a_denial_id AND DomainId = @DomainId)
				SET @s_l_notes = 'Denial Reason Added ' + @s_l_denial_reason_type
				
				EXEC LCJ_AddNotes @DomainId = @DomainId, @case_id=@s_a_case_id,@notes_type='Activity',@Ndesc=@s_l_notes,@User_id=@s_a_user_id,@Applytogroup=0
			 END
    END

