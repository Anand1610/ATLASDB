CREATE PROCEDURE [dbo].[F_advanced_search_saved_query_retrieve]
(
	@i_a_fk_user_id	INT = 1
)
AS
BEGIN

	SELECT
		ROW_NUMBER() OVER (ORDER BY query_name) As s_no,
		*
	FROM
		tbl_advanced_search_saved_query query
	WHERE 
			UserID = @i_a_fk_user_id
	ORDER BY
			query_name ASC	  
END

