CREATE PROCEDURE DomainEmailSettings_Insert
    @i_a_Domain_Email_Id int,
	@s_a_Domain_Id varchar(50),
	@s_a_EnailFrom varchar(max),
	@s_a_Password varchar(max),
	@i_a_PortNo int,
	@s_a_Server_Name varchar(max),
	@b_a_SSLEnabled bit,
	@s_a_ReplyToEmail varchar(max)
AS
BEGIN
	
	IF @i_a_Domain_Email_Id = 0
		BEGIN
			Insert into tblDomainEmailSettings(Domain_Id, EmailFrom, Password, SMTP_Port_Number, SMTP_Server_Name, isSSLEnabled, ReplyToEmailId)
			Values (@s_a_Domain_Id, @s_a_EnailFrom, @s_a_Password, @i_a_PortNo, @s_a_Server_Name, @b_a_SSLEnabled, @s_a_ReplyToEmail)

			Select 'Email settings saved successfully.'
		END
	ELSE
		BEGIN
			Update tblDomainEmailSettings Set 
				EmailFrom = @s_a_EnailFrom,
				Password = @s_a_Password,
				SMTP_Port_Number = @i_a_PortNo,
				SMTP_Server_Name = @s_a_Server_Name,
				isSSLEnabled = @b_a_SSLEnabled,
				ReplyToEmailId = @s_a_ReplyToEmail
			Where 
			  pk_domain_email_id = @i_a_Domain_Email_Id and Domain_Id = @s_a_Domain_Id
			
			Select 'Email settings updated successfully.'
		END

END
