CREATE PROCEDURE [dbo].[checkIdForBatchMailSend]--[checkIdForBatchMailSend] 'FH07-42372',''
(  
	@DomainId nvarchar(100),
	@Case_ID varchar(50),
	@Output INT OUTPUT 
)  
AS
BEGIN 
SET NOCOUNT ON

DECLARE @Count INT --OUTPUT 


	IF EXISTS(SELECT CASE_ID FROM tblcase WHERE Case_Id= @Case_ID AND DomainId=@DomainId)
	BEGIN
		IF EXISTS(select Case_Id from dbo.tblBatchMailSend where ISNULL(MailSendDate,'') <> '' AND LTRIM(RTRIM(Case_Id)) = @Case_ID AND Domainid=@DomainId)
		BEGIN
			set @Count = 1
		END
		ELSE
		BEGIN
			set @Count = 0
		END
	END
	ELSE
	BEGIN
		set @Count = 1
	END
	
	SET @Output=@Count 
	select @Output
END

