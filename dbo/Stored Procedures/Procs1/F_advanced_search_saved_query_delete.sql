CREATE PROCEDURE [dbo].[F_advanced_search_saved_query_delete]
(	
	@i_a_advanced_search_query_id		INT,
	@i_a_fk_user_id	INT
)
AS
BEGIN
	DECLARE @s_l_message VARCHAR(MAX)   	

	IF EXISTS(SELECT * FROM tbl_advanced_search_saved_query WHERE UserID = @i_a_fk_user_id AND pk_advanced_search_query_id = @i_a_advanced_search_query_id)	
	BEGIN
		DELETE FROM tbl_advanced_search_saved_query WHERE pk_advanced_search_query_id = @i_a_advanced_search_query_id
		SET @s_l_message = 'Advanced search query details deleted successfully...!!'
	END
	ELSE
	BEGIN
		SET @s_l_message = 'Delete Operation Failed, Only created user can delete the Qyery...!!'
	END
	
	SELECT @s_l_message AS [Message]
END

