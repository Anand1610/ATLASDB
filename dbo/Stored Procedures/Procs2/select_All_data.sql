CREATE PROCEDURE [dbo].[select_All_data]--45
(
	@DomainId NVARCHAR(50),
  @UserId nvarchar(55)
)
as
begin
select UserName,UserPassword,DisplayName,Email,bit_for_reports_case_search,bit_for_Provider_Cases from IssueTracker_Users where UserId=@UserId
select Provider_id from TXN_PROVIDER_LOGIN where user_id=@UserId and DomainId=@DomainId
end

