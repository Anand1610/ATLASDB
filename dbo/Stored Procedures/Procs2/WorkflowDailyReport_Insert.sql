CREATE PROCEDURE WorkflowDailyReport_Insert
	@s_a_DomainId varchar(50),
	@s_a_Email_To varchar(max),
	@s_a_Email_CC varchar(max),
	@s_a_Email_BCC varchar(max)
AS
BEGIN
		Insert into tblWorkflowDailyReport
		(DomainId, Email_To, Email_CC, Email_BCC, Sent_Date)
		Values
		(@s_a_DomainId,@s_a_Email_To,@s_a_Email_CC,@s_a_Email_BCC, GETDATE())
END
