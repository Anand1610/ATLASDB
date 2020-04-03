CREATE PROCEDURE [dbo].[get_batch_entity_type]
	@DomainID	varchar(50)
AS
BEGIN	
    
	Declare @CompanyType varchar(150)=''
    Select TOP 1 @CompanyType =  LOWER(LTRIM(RTRIM(CompanyType))) from tbl_Client(NOLOCK) Where DomainId=@DomainID

	SELECT
		ID,
		Name
	from 
		tbl_batch_entity_type 
	Where
	(@CompanyType = 'funding' and Lower(Name) != 'defendant' and Lower(Name)!='adversary attorney')
	OR
	(@CompanyType != 'funding' and Lower(Name) != 'opposing counsel')
	order by
		Name ASC
END

