-- drop PROCEDURE Required_Documents_Insert  
CREATE PROCEDURE [dbo].[Required_Documents_Insert]  
(
	@i_a_ID int,
	@s_a_DomainID varchar(50),
	@s_a_Case_ID varchar(50),
	--@Documents DocumentType READONLY,
	@s_a_RequiredDocument varchar(2000),
	--@s_a_ReminderType varchar(50),
	@dt_a_ReminderDate Datetime = null,
	@s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
    DECLARE @s_l_message NVARCHAR(500)=''
	DECLARE @s_l_DocumentType varchar(150)
	DECLARE @Success bit = 1
	SET NOCOUNT ON;


	--SET @s_l_DocumentType =  STUFF(
	--(SELECT ',' + DocumentType FROM Required_Documents WHERE ReminderType = @s_a_ReminderType and Case_ID = @s_a_Case_ID and DomainID = @s_a_DomainID
	--DocumentType IN (SELECT s FROM dbo.SplitString(@s_a_RequiredDocument,','))
	--FOR XML PATH('')), 1, 1, '')


	IF(@i_a_ID = 0)
	BEGIN
		SELECT  @s_l_DocumentType= COALESCE(@s_l_DocumentType+', ' ,'') +  DocumentType FROM Required_Documents WHERE ReminderDate IS null and Case_ID = @s_a_Case_ID and DocumentType IN (SELECT s FROM dbo.SplitString(@s_a_RequiredDocument,','))

		IF (ISNuLL(@s_l_DocumentType,'') <> '')
		BEGIN
			SET @s_l_message	=  'Document type ' + @s_l_DocumentType + ' already exists please update the reminder date..!!!'
			SET @Success = 0
		END
		ELSE
		BEGIN
			BEGIN TRAN
				UPDATE Required_Documents 
				SET isCompleted = 1
				WHERE ReminderDate IS NOT NULL and Case_ID = @s_a_Case_ID and DocumentType IN (SELECT s FROM dbo.SplitString(@s_a_RequiredDocument,','))
				 
				INSERT INTO Required_Documents (DomainID, Case_ID, DocumentType, ReminderDate, Created_by_user, Created_date)
				SELECT @s_a_DomainID, @s_a_Case_ID, s AS DocumentType, @dt_a_ReminderDate, @s_a_Created_By_User, GetDate() 
				FROM dbo.SplitString(@s_a_RequiredDocument,',')

				Declare @notes_Desc VARCHAR (500) ='Missing- ' +  @s_a_RequiredDocument;
				exec LCJ_AddNotes @DomainId = @s_a_DomainID,@case_id = @s_a_Case_ID,@Notes_Type='General',@Ndesc = @notes_Desc,@user_Id=@s_a_Created_By_User,@ApplyToGroup = 0

			COMMIT TRAN 
			SET @s_l_message	=  'Details saved successfully'
		END
		  
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT ID FROM Required_Documents WHERE ReminderDate IS null  and Case_ID = @s_a_Case_ID and DocumentType=@s_a_RequiredDocument and ID != @i_a_ID)
			BEGIN
			   SET @s_l_message	=  'Document type already exists please update the reminder date ..!!!'
			   SET @Success = 0
			END
		 ELSE
		 BEGIN
			BEGIN TRAN
				UPDATE Required_Documents
				SET
				   ReminderDate = @dt_a_ReminderDate,
				   modified_by_user = @s_a_Created_By_User,
				   modified_date =GETDATE()
				WHERE ID = @i_a_ID
			COMMIT TRAN 
		   SET @s_l_message	=  'Record updated successfully'
		 END
	END
	
	SELECT @s_l_message AS [MESSAGE]	
END
