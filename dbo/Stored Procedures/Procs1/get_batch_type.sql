CREATE PROCEDURE [dbo].[get_batch_type]
	 @DomainID	varchar(50)
AS
BEGIN	
	SELECT
		ID,
		Name
	from 
		tbl_batch_type
	order by
		Name ASC
END
