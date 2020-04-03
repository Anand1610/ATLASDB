CREATE PROCEDURE [dbo].[ErrorLogCasesWithoutEmailAndFax] 
	@CaseId varchar(250),
	@DomainId varchar(250),
	@EmailTo varchar(100),
	@EmailBody varchar(max),
	@QueueSourceId INT,
	@EmailErrorMessage varchar(max)
AS
BEGIN
			Insert into tblTriggerTypeErrorLog
			(CaseId, DomainId, QueueSourceId, EmailTo, Subject, EmailBody, SentOn, UnknownTags, ReplacementValueMissingTags, IsResolved, QueueType,EmailErrorMessage)
			Values
			(@CaseId, @DomainId, @QueueSourceId, @EmailTo, 'Cases Without Email Or Fax', @EmailBody, GETDATE(), '', '', 1, 2,@EmailErrorMessage)
END