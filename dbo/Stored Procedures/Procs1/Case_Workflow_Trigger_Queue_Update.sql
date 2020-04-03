CREATE PROCEDURE Case_Workflow_Trigger_Queue_Update 
	@i_Queue_Id int,
	@s_a_DomainId VARCHAR(50),
	@s_Email_To varchar(250),
	@s_Email_CC varchar(500),
	@s_Email_BCC varchar(500),
	@s_Email_Subject varchar(500),
	@s_Email_Body varchar(max),
	@s_a_ImageIds xml,
	@s_a_TriggerType varchar(500)

AS
BEGIN
	SET NOCOUNT ON;

	--IF @i_ImageId = 0
	 --SET @i_ImageId = null;

    UPDATE tblCaseWorkflowTriggerQueue 
	SET
		IsProcessed		=	1, 
		InProgress		=   0,
		ProcessedDate	=	GETDATE(),
		EmailTo			=	@s_Email_To,
		EmailCC			=	@s_Email_CC,
		EmailBCC		=   @s_Email_BCC,
        EmailSubject	=   @s_Email_Subject,
        EmailBody		=   @s_Email_Body
        --AttachmentImageID = @i_ImageId
	WHERE
		 Id = @i_Queue_Id AND  DomainId =	@s_a_DomainId

	IF Convert(Varchar(max), ISNULL(@s_a_ImageIds,'')) != ''
		 BEGIN
			Insert into tblCaseWorkflowAttachments(WorkflowQueue_Id, AttachmentImageID,DomainId)
			Select @i_Queue_Id, img.detail.value('(text())[1]','int') AS ImageId, @s_a_DomainId
			From @s_a_ImageIds.nodes('ImageId')AS img(detail)
		 END

		 Declare @Case_Id varchar(50);

		 Select @Case_Id = Case_Id From tblCaseWorkflowTriggerQueue Where Id = @i_Queue_Id AND  DomainId =	@s_a_DomainId

		 Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,WorkflowQueueID, User_Id, DomainId)
		 Values('Notification Email Sent : ' + @s_Email_Subject, 'Workflow', 1, @Case_Id, GETDATE(), @i_Queue_Id, 'admin', @s_a_DomainId)

		 IF @s_a_TriggerType = 'Release F/U'
			 BEGIN
			   Update tblCase_Date_Details set Release_FU_Date = GetDate() where Case_Id = @Case_Id and DomainId = @s_a_DomainId
			 END
		 ELSE IF @s_a_TriggerType = 'Settlement F/U Letter'
			 BEGIN
			   Update tblCase_Date_Details set Settlement_FU_letter_Date_1 = GetDate() where Case_Id = @Case_Id and DomainId = @s_a_DomainId
			 END
         ELSE IF @s_a_TriggerType = '2nd Settlement F/U Letter'
			 BEGIN
			   Update tblCase_Date_Details set Settlement_FU_letter_Date_2 = GetDate() where Case_Id = @Case_Id and DomainId = @s_a_DomainId
			 END
	     ELSE IF @s_a_TriggerType = 'Case Evaluation Summary Due'
			 BEGIN
			   Update tblCase_Date_Details set Case_Evaluation_Summary_Due_Date = GetDate() where Case_Id = @Case_Id and DomainId = @s_a_DomainId
			 END
	     ELSE IF @s_a_TriggerType = 'Facilitation Summary Due'
			 BEGIN
			   Update tblCase_Date_Details set Facilitation_Summary_Due_Date = GetDate() where Case_Id = @Case_Id and DomainId = @s_a_DomainId
			 END
	     ELSE IF @s_a_TriggerType = 'Final Trial Notebook'
			 BEGIN
			   Update tblCase_Date_Details set Final_Pretrial_Statement_Trial_Notebook_Sent_Date = GetDate() where Case_Id = @Case_Id and DomainId = @s_a_DomainId
			 END
END
