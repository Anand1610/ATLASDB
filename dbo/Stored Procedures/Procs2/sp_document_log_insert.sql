CREATE PROCEDURE [dbo].[sp_document_log_insert] (
	@DomainId NVARCHAR(50)
	,@i_a_user_id INT
	,@i_a_node_id INT
	,@s_a_document_name VARCHAR(100)
	,@s_a_operation VARCHAR(3000)
	,@dt_a_log_date_time DATETIME = NULL
	,@s_a_log_action VARCHAR(MAX)
	,@i_a_Case_id VARCHAR(100)
	)
AS
BEGIN
	DECLARE @filePath VARCHAR(255)
	DECLARE @s_l_message VARCHAR(MAX)
	DECLARE @i_l_result INT

	SELECT @filePath = doc.FilePath
	FROM tblDocImages doc
	WHERE doc.ImageID = @i_a_node_id

	INSERT INTO dbo.tbl_document_log (
		fk_user_id
		,fk_node_id
		,document_name
		,operation
		,log_date_time
		,log_action
		,pk_case_id
		,DomainId
		,FilePath
		)
	VALUES (
		@i_a_user_id
		,@i_a_node_id
		,@s_a_document_name
		,@s_a_operation
		,GETDATE()
		,@s_a_log_action
		,@i_a_Case_id
		,@DomainId
		,@filePath
		)

	DECLARE @User_Name VARCHAR(50)

	SELECT @User_Name = UserName
	FROM IssueTracker_Users
	WHERE UserId = @i_a_user_id
		AND DomainId = @DomainId

	DECLARE @Description VARCHAR(100) = @s_a_log_action

	EXEC LCJ_AddNotes @DomainId = @DomainId
		,@Case_Id = @i_a_Case_id
		,@Notes_Type = 'ACTIVITY'
		,@NDesc = @Description
		,@User_Id = @User_Name
		,@ApplyToGroup = 0

	SET @s_l_message = 'document log details inserted successfully'
	SET @i_l_result = 1

	SELECT @s_l_message AS [MESSAGE]
		,@i_l_result AS [RESULT]
END