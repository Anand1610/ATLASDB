
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- DROP PROCEDURE [dbo].[DomainEmailMaster_Insert] 
CREATE PROCEDURE [dbo].[Email_Server_Save] 
(
	@DomainID nvarchar(100),
	@s_a_type nvarchar(150),
	@s_a_From_Email_ID nvarchar(100),
	@s_a_Password nvarchar(100),
	@s_a_smtp_server nvarchar(50),
	@i_a_smtp_port int,
	@s_a_cc nvarchar(100),
	@s_a_bcc nvarchar(100),
	@s_a_email_subject nvarchar(300),
	@s_a_email_body nvarchar(MAX),
	@s_a_status varchar(200),
	@i_a_node_id int,
	@s_a_to_email_id nvarchar(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
    -- Insert statements for procedure here
	IF NOT EXISTS(SELECT type from Email_Server WHERE type= @s_a_type and DomainID = @DomainID)
	BEGIN
		BEGIN TRAN
			insert into Email_Server(DomainID,from_email_id,Password,smtp_server,type,smtp_port,CC,BCC,mail_subject,mail_body,status,node_id, to_email_id)
			values(@DomainID,@s_a_From_Email_ID,@s_a_Password,@s_a_smtp_server,@s_a_type,@i_a_smtp_port,@s_a_cc,@s_a_bcc,@s_a_email_subject,@s_a_email_body,@s_a_status,@i_a_node_id,@s_a_to_email_id)
		COMMIT TRAN
		SET @s_l_message	=  'Details saved successfully'
	    SET @i_l_result		=  SCOPE_IDENTITY()

	END
	ELSE
	BEGIN
		BEGIN TRAN
			UPDATE   Email_Server
			SET
				 from_email_id=@s_a_From_Email_ID
				 , Password=@s_a_Password
				 , smtp_server=@s_a_smtp_server
				 , smtp_port=@i_a_smtp_port
				 ,  CC=@s_a_cc
				 , BCC=@s_a_bcc
				 , mail_subject = @s_a_email_subject
				 , mail_body = @s_a_email_body
				 , status = @s_a_status
				 , node_id = @i_a_node_id
				 , to_email_id =@s_a_to_email_id
			WHERE DomainID=@DomainID AND Type=@s_a_type
		COMMIT TRAN


		SET @s_l_message	=  'Details saved successfully'
	    SET @i_l_result		=  SCOPE_IDENTITY()
	END
	
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	
END

