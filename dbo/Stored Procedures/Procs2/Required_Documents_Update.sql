-- drop PROCEDURE Required_Documents_Insert  
CREATE PROCEDURE [dbo].[Required_Documents_Update]  
(
	@s_a_DomainID varchar(50),
	@s_a_ID varchar(2000),
	@dt_a_ReminderDate Datetime = null,
	@b_a_Completed bit=null,
	@s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
    DECLARE @s_l_message NVARCHAR(500)=''
	DECLARE @s_l_DocumentType varchar(150)
	DECLARE @dt_Complted_Date Datetime = null
	SET NOCOUNT ON;
	IF(@b_a_Completed = 1)
		SET @dt_Complted_Date = GETDATE()

	BEGIN
		BEGIN TRAN
		 IF (@dt_a_ReminderDate IS NULL)
		 BEGIN
			UPDATE Required_Documents
			SET
				isCompleted = @b_a_Completed,
				Complted_Date =  @dt_Complted_Date,
				modified_by_user = @s_a_Created_By_User,
				modified_date =GETDATE()
			WHERE ID IN (SELECT s FROM dbo.SplitString(@s_a_ID,','))
		 END
		 ELSE
		 BEGIN
			UPDATE Required_Documents
			SET
				ReminderDate = @dt_a_ReminderDate,
				isCompleted = @b_a_Completed,
				Complted_Date =  @dt_Complted_Date,
				modified_by_user = @s_a_Created_By_User,
				modified_date =GETDATE()
			WHERE ID IN (SELECT s FROM dbo.SplitString(@s_a_ID,','))
		 END
			
		COMMIT TRAN 
		SET @s_l_message	=  'Saved successfully'
	END
	
	SELECT @s_l_message AS [MESSAGE]	
END
