CREATE PROC Proc_get_email_configuration
@SearchKeyword VARCHAR(128),
@DomainId VARCHAR(64)
AS
BEGIN
	 SELECT 
			EmailID,
			EmailKey,
			EmailServer,
			PortNo,
			ServerType,
			FolderName,
			EmailFrom,
			EmailTO,
			EmailCC,
			SmtpServer ,
			SmtpPort,
			EmailPassword,
			EnableSSL,
			DomainId,
			SearchKeyword,
			EmailFromDays,
			EmailToDays,
			convert(varchar(20),LastReadDate,101)[LastReadDate]

	FROM	tblMailConfigartion
	where	SearchKeyword=@SearchKeyword and
			DomainId =@DomainId

END