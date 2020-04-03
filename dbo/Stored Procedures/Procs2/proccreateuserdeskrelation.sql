CREATE PROCEDURE [dbo].[proccreateuserdeskrelation]
(
@DomainID NVARCHAR(50),
@UserName varchar(20)
)
as
begin
declare
@cnt int
select @cnt = count(*) from tbldesk where desk_name =@UserName and DomainId=@DomainID
if @cnt = 0
begin
	insert into tbldesk values (@UserName,@DomainID)
end
end

