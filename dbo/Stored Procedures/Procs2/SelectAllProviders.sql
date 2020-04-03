CREATE PROCEDURE [dbo].[SelectAllProviders]
(
    @UserId nvarchar(50)
)
as
begin
select Provider_Name from tblProvider where Provider_Id in(select Provider_Id from TXN_PROVIDER_LOGIN where user_id=@UserId) order by Provider_Name
end

