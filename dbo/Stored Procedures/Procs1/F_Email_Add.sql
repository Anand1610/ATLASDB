CREATE PROCEDURE [dbo].[F_Email_Add]
	 @s_a_case_id  VARCHAR(100),
	 @dt_Message_Date DATETIME,
	 @s_a_Subject TEXT,
	 @s_a_Body TEXT,
	 @s_a_Message_To VARCHAR(8000),
	 @s_a_Message_From VARCHAR(8000),
	 @s_a_Message_FromName VARCHAR(8000),
	 @i_a_user_id int=1
AS
BEGIN

INSERT INTO tbl_Email
(
	case_id,
	Message_Date,
	Subject,
	Body,
	Message_To,
	Message_From,
	Message_FromName,
	user_id
)
VALUES
(
	@s_a_case_id,
	@dt_Message_Date,
	@s_a_Subject,
	@s_a_Body,
	@s_a_Message_To,
	@s_a_Message_From,
	@s_a_Message_FromName,
	@i_a_user_id	
)
  SELECT @@IDENTITY AS Email_Id
END

