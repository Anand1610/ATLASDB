CREATE PROCEDURE [dbo].[Add_Communication_Document] 
(
	@DomainId nvarchar(50),
    @case_id nvarchar(50),
    @userName nvarchar(100),
	@Mail_Subject nvarchar(max),
	@Mail_From  nvarchar(max),
	@Mail_To nvarchar(max),
	@Mail_Cc nvarchar(max),
	@Mail_SendDate nvarchar(100),
    @AttachmentCount int,	
    @AttachmentFiles nvarchar(max)
)	
AS
Declare @user_id as nvarchar(50)
Declare @ID as integer 
Declare @RowAffeced as integer 
BEGIN
set @user_id=(select UserId from IssueTracker_Users where UserName=@userName and DomainId=@DomainId)
		
insert into tblEmail(Email_Desc,Case_Id,User_Id,Date_Created,Subject,Message_From,Message_To,Message_CC,Message_Date,Attachments,Attachment_Files,UID,Headers,Body,Message_FromName,Message_FromIP,Message_BCC,Message_ReplyTo,MIMEText,ReturnPath,DomainId)
values('Add Email',@case_id,@user_id,getdate(),@Mail_Subject,@Mail_From ,@Mail_To,@Mail_Cc,@Mail_SendDate,@AttachmentCount,@AttachmentFiles,'','','',@Mail_From,'','','','','',@DomainId)
set @RowAffeced=(select @@ROWCOUNT)
IF @RowAffeced <> 0
Begin
select Top 1 Email_Id from tblEmail WHERE DomainId=@DomainId order by Date_Created Desc
End
END

