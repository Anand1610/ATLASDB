CREATE PROCEDURE [dbo].[Get_DomainEmailSettings] 
	@s_a_Domain_Id varchar(50)
AS
BEGIN
	 SET NOCOUNT ON;
	 
	 Select pk_domain_email_id
			,EmailFrom
			,Password
			,SMTP_Port_Number
			,SMTP_Server_Name
			,isSSLEnabled
			,ReplyToEmailId
			, ISNULL(EmailCC,'') AS EmailCC
			, ISNULL(EmailBCC,'') AS EmailBCC
			from tblDomainEmailSettings Where Domain_Id = @s_a_Domain_Id

END
