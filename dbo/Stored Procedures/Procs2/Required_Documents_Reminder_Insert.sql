-- drop PROCEDURE Required_Documents_Insert  
CREATE PROCEDURE [dbo].[Required_Documents_Reminder_Insert]  
(
	
	@s_a_DomainID varchar(50),
	@s_a_ID varchar(2000),
	@dt_a_ReminderDate Datetime = null,
	@s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
    DECLARE @s_l_message NVARCHAR(500)=''
	DECLARE @s_l_DocumentType varchar(150)
	DECLARE @Success bit = 1
	SET NOCOUNT ON;
		BEGIN
			BEGIN TRAN
				UPDATE Required_Documents 
				SET isCompleted = 1
				WHERE ReminderDate IS NOT NULL and ID IN (SELECT s FROM dbo.SplitString(@s_a_ID,','))
				 
				INSERT INTO Required_Documents (DomainID, Case_ID, DocumentType, ReminderDate, Created_by_user, Created_date)
				SELECT @s_a_DomainID, Case_ID, DocumentType, @dt_a_ReminderDate, @s_a_Created_By_User, GetDate() 
				FROM Required_Documents WHERE ID IN (select s FROM dbo.SplitString(@s_a_ID,','))
				

				--Declare @notes_Desc VARCHAR (500) ='Missing- ' +  @s_a_RequiredDocument;
				--exec LCJ_AddNotes @DomainId = @s_a_DomainID,@case_id = @s_a_Case_ID,@Notes_Type='PopUp',@Ndesc = @notes_Desc,@user_Id=@s_a_Created_By_User,@ApplyToGroup = 0

			COMMIT TRAN 
			SET @s_l_message	=  'Details saved successfully'
		END
	SELECT @s_l_message AS [MESSAGE]	
END
