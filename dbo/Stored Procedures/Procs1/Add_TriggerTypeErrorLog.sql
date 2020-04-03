CREATE PROCEDURE [dbo].[Add_TriggerTypeErrorLog] 
	@CaseId varchar(250),
	@DomainId varchar(250),
	@QueueSourceId int,
	@EmailTo varchar(max),
	@Subject varchar(max),
	@EmailBody varchar(max),
	@UnknownTags varchar(max),
	@ReplacementValueMissingTags varchar(max),
	@QueueType int,
	@EmailErrorMessage varchar(max) = null
AS
BEGIN
	
	SET NOCOUNT ON;
	IF Not Exists(Select TOP 1 AutoID from tblTriggerTypeErrorLog Where CaseId = @CaseId and DomainId = @DomainId and QueueSourceId = @QueueSourceId and QueueType = @QueueType and ISNULL(IsResolved,0)=0)
		BEGIN
			Insert into tblTriggerTypeErrorLog
			(CaseId, DomainId, QueueSourceId, EmailTo, Subject, EmailBody, SentOn, UnknownTags, ReplacementValueMissingTags, IsResolved, QueueType,EmailErrorMessage)
			Values
			(@CaseId, @DomainId, @QueueSourceId, @EmailTo, @Subject, @EmailBody, GETDATE(), @UnknownTags, @ReplacementValueMissingTags, 0, @QueueType,@EmailErrorMessage)
		    
			Select 'notification not sent'
		END
	Else
		BEGIN
		    Update tblTriggerTypeErrorLog Set
			UnknownTags = @UnknownTags,
			ReplacementValueMissingTags = @ReplacementValueMissingTags,
			IsResolved = 0
			Where CaseId = @CaseId and DomainId = @DomainId and QueueSourceId = @QueueSourceId and QueueType = @QueueType

			Select 'notification sent'
		END
END