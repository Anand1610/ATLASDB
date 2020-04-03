CREATE PROCEDURE [dbo].[LCJ_GETCOSTBALANCE]
(@DomainId NVARCHAR(50),
@var varchar(50))
as
begin
if @var <> 'all'
select * from tblprovider where provider_name like ''+@var + '%' and DomainId=@DomainId order by provider_name
else
select * from tblprovider WHERE DomainId=@DomainId  order by provider_name
end

