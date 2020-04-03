

CREATE PROCEDURE [dbo].[checkIdForAAA]--[checkIdForAAA] 'RFAMUL15-1',''
(  
@DomainID nvarchar(100),
	@Case_ID varchar(50),
	@Output INT OUTPUT 
)  
AS
BEGIN 
SET NOCOUNT ON

DECLARE @Count INT --OUTPUT 


	IF EXISTS(SELECT CASE_ID FROM tblcase WITH(NOLOCK) WHERE Case_Id= @Case_ID AND DomainId=@DomainID)
	BEGIN
		IF EXISTS(select Case_Id from dbo.tblArbitrationCases WITH(NOLOCK) where ISNULL(MailSendDate,'') <> '' AND LTRIM(RTRIM(Case_Id)) = @Case_ID AND DomainId=@DomainID )
		BEGIN
			set @Count = 1
		END
		ELSE
		BEGIN
			set @Count = 0
		END
	END
	ELSE IF EXISTS(SELECT CASE_ID FROM tblCASE  WITH(NOLOCK)INNER JOIN dbo.tblCasePacket WITH(NOLOCK) on tblcase.case_id=tblCasePacket.CaseId WHERE  LTRIM(RTRIM(PacketID)) = @Case_ID AND tblcase.Doctor_id=@DomainID)
	BEGIN
		IF EXISTS(select Case_Id from dbo.tblArbitrationCases WITH(NOLOCK) where ISNULL(MailSendDate,'') <> '' AND DomainId=@DomainID AND LTRIM(RTRIM(Case_Id)) IN(SELECT CASE_ID FROM tblCASE WITH(NOLOCK) INNER JOIN dbo.tblCasePacket WITH(NOLOCK) on tblcase.case_id=tblCasePacket.CaseId WHERE  LTRIM(RTRIM(PacketID)) = @Case_ID AND tblcase.DomainId=@DomainID) )
		BEGIN
			print 'PKT 1'
			set @Count = 1
		END
		ELSE
		BEGIN
			print 'PKT 0'
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
