CREATE PROCEDURE [dbo].[case_search_saved_query_delete]
(	
	@i_a_search_query_id		INT,
	@i_a_fk_user_id	INT
)
AS
BEGIN
	DECLARE @s_l_message VARCHAR(MAX)   	

	IF EXISTS(SELECT * FROM case_search_saved_query WHERE UserID = @i_a_fk_user_id AND pk_search_query_id = @i_a_search_query_id)	
	BEGIN
		DELETE FROM case_search_saved_query WHERE pk_search_query_id = @i_a_search_query_id
		SET @s_l_message = 'Saved search deleted successfully...!!'
	END
	ELSE
	BEGIN
		SET @s_l_message = 'Delete Operation Failed, Only created user can delete the Qyery...!!'
	END
	
	SELECT @s_l_message AS [Message]
END
