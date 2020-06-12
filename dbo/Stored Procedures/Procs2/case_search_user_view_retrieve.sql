CREATE PROCEDURE [dbo].[case_search_user_view_retrieve] -- [case_search_user_view_retrieve] 'localhost',1111
(
	@DomainID		VARCHAR(100),
	@i_a_fk_user_id	INT = 1
)
AS
BEGIN
	SELECT
		ROW_NUMBER() OVER (ORDER BY pk_search_query_id) As s_no,
		pk_search_query_id,
		query.domainid,
		column_value,
		column_name,
		query_name,
		userid,
		modified_userid,
		create_date=CONVERT(VARCHAR,create_date,101),
		modified_date=CONVERT(VARCHAR,modified_date,101)
	
	FROM
		case_search_User_View query

		--left join tbl_portfolio PF (NOLOCK)on query.PortfolioId=PF.id
	WHERE 
		query.domainid	=	@DomainID AND 
		UserID		=	@i_a_fk_user_id
	ORDER BY
		pk_search_query_id ASC
END