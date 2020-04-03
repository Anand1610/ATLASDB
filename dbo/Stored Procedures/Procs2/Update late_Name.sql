CREATE PROCEDURE [dbo].[Update late_Name]
	@DomainId varchar(50),
	@templatename varchar(200),
	@templateid int
AS
BEGIN
	update MST_TEMPLATES 
	set SZ_TEMPLATE_NAME = @templatename
	where I_TEMPLATE_ID = @templateid
	AND DomainId = @DomainId
END

