CREATE PROCEDURE [dbo].[procLoginValidate](
@DomainID varchar(50),
@uid varchar(50),
@pwd varchar(50)
)
as
begin

	select * from issuetracker_users a where UserName=@uid and UserPassword = @pwd and DomainID =@DomainID
end

