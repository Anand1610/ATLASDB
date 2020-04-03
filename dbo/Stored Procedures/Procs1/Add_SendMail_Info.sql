CREATE PROCEDURE [dbo].[Add_SendMail_Info]
(  
	@DomainId nvarchar(50),
   @Case_ID nvarchar(50),  
   @UserName nvarchar(50),
   @EmailId nvarchar(50),  
   @Status nvarchar(50),
   @mail_To nvarchar(max),
   @mail_From nvarchar(max),
   @mail_Cc nvarchar(max),
   @mail_Subject nvarchar(max),
   @mail_Body nvarchar(max),
   @AttachCount int,
   @AttachFiles nvarchar(max)
)  
as  
declare @userID as nvarchar(50)
Declare @RowAffeced as integer 
begin  
set @userID=(select UserId from IssueTracker_Users where UserName=@UserName and DomainId=@DomainId)
insert into tblEmailSend_Info(UserId,Case_ID,EmailID,Send_Status,DomainId) values(@userID,@Case_ID,@EmailId,@Status,@DomainId)
insert into tblEmail(Email_Desc,Case_Id,User_Id,Date_Created,Subject,Message_From,Message_To,Message_CC,Message_Date,Attachments,Attachment_Files,UID,Headers,Body,Message_FromName,Message_FromIP,Message_BCC,Message_ReplyTo,MIMEText,ReturnPath,DomainId)
values(@Status,@case_id,@userID,getdate(),@mail_Subject,@mail_From ,@mail_To,@mail_Cc,getdate(),@AttachCount,@AttachFiles,'','',@mail_Body,@mail_From,'','','','','',@DomainId)
set @RowAffeced=(select @@ROWCOUNT)
IF @RowAffeced <> 0
Begin
select Top 1 Email_Id from tblEmail WHERE DomainId=@DomainId order by Date_Created Desc
End
end

