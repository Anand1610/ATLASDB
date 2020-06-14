CREATE PROCEDURE [dbo].[case_search_user_view_Delete] 
(
	@DomainID		VARCHAR(100),
	@user_id	INT = 0
)
AS
BEGIN
	If EXISTS(select * from case_search_user_view where domainid=@DomainID and userid=@user_id)
	BEGIN
	delete top(1) from case_search_user_view where domainid=@DomainID and userid=@user_id
	END
END