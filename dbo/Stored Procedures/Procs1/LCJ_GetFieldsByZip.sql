CREATE PROCEDURE [dbo].[LCJ_GetFieldsByZip] --[LCJ_GetFieldsByZip] 'test',''
(
	@DomainId NVARCHAR(50),
	@ZipCode nvarchar(255)
)
 AS

 select 'NY' as City, '' as ST
 UNION
select City,ST from ZipList where ZipCode=@Zipcode --and DomainId=@DomainId

