--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[F_DenialReasons_Update]  
  
(  
	  @DomainId NVARCHAR(50),
	  @Case_Id NVARCHAR(200),
	  @DenialReason_Id INT,
	  @DenialReasons_Type NVARCHAR(50),
	  @UserID NVARCHAR(100)
)  
AS 
	BEGIN 
		DECLARE @NOTES VARCHAR(200)
    
			BEGIN
				UPDATE tblcase  SET DenialReasons_Type=@DenialReasons_Type , Denial_Date=CONVERT(NVARCHAR(15), GETDATE(),101) where Case_Id=@Case_Id and DomainId = @DomainId
			END
				SET @NOTES = 'Denial Reason Added ' + @DenialReasons_Type +'on'+ CONVERT(NVARCHAR(15), GETDATE(),101)
				EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@case_id,@notes_type='Activity',@Ndesc=@NOTES,@User_id=@UserID,@Applytogroup=0
    END

