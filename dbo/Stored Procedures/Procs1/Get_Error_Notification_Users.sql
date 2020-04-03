CREATE PROCEDURE Get_Error_Notification_Users
	@s_a_DomainId varchar(50)
AS
BEGIN

		SET NOCOUNT ON;

			Select	SUBSTRING(ISNULL(STUFF((
					SELECT COALESCE(ISNULL(first_name,'') + ' ' + ISNULL(last_name, '')+', ',' - ')
						FROM tblTriggerTypeErrorNotificationUsers TE(NOLOCK) INNER JOIN IssueTracker_Users U (NOLOCK) 
						ON TE.UserId = U.UserId
						Where TE.DomainId = @s_a_DomainId and TE.IsActive = 1 and isnull(Email,'') != ''
				for xml path('')
			),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
				SELECT COALESCE(ISNULL(first_name,'') + ' ' + ISNULL(last_name, '')+', ',' - ')
						FROM tblTriggerTypeErrorNotificationUsers TE(NOLOCK) INNER JOIN  IssueTracker_Users U (NOLOCK) 
						ON TE.UserId = U.UserId
						Where  TE.DomainId = @s_a_DomainId and TE.IsActive = 1 and isnull(Email,'') != '' 
				for xml path('')
			),1,0,''),',')))-1) As ReceiverName,

			SUBSTRING(ISNULL(STUFF((
					SELECT COALESCE(isnull(Email,'')+',',' - ')
						FROM tblTriggerTypeErrorNotificationUsers TE(NOLOCK) INNER JOIN IssueTracker_Users U (NOLOCK) 
						ON TE.UserId = U.UserId
						Where TE.DomainId = @s_a_DomainId and TE.IsActive = 1 and isnull(Email,'') != ''
				for xml path('')
			),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
				SELECT COALESCE(isnull(Email,'')+',',' - ')
						FROM tblTriggerTypeErrorNotificationUsers TE(NOLOCK) INNER JOIN  IssueTracker_Users U (NOLOCK) 
						ON TE.UserId = U.UserId
						Where  TE.DomainId = @s_a_DomainId and TE.IsActive = 1 and isnull(Email,'') != '' 
				for xml path('')
			),1,0,''),',')))-1) As EmailTo
			,EmailFrom
			,Password
			,SMTP_Port_Number
			,SMTP_Server_Name
			,isSSLEnabled
			,ReplyToEmailId
			From tblDomainEmailSettings ems where ems.Domain_Id = @s_a_DomainId

END
