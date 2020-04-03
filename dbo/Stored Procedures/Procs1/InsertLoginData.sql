CREATE PROCEDURE [dbo].[InsertLoginData]
(
@DomainId NVARCHAR(50),
  @UserName nvarchar(255),
  @userid nvarchar(55),
  @UserPassword nvarchar(50),
  @Email nvarchar(255),
  @DisplayName nvarchar(50),
  @UserTypeLogin nvarchar(100),
  @UserType nvarchar(10),
  @bit_for_reports_case_search bit,
  @bit_for_Provider_Cases bit,
  @ProviderId int = NULL
)
as
declare @RoleID int
begin
set @RoleID=(select RoleId from IssueTracker_Roles where RoleName='Provider' and DomainId=@DomainId)
if(@userid='0')
begin
	insert into IssueTracker_Users(UserName,UserPassword,RoleId,Email,DisplayName,UserTypeLogin,UserType,IsActive,bit_for_reports_case_search,bit_for_Provider_Cases,DomainId,ProviderId)
	values(@UserName,@UserPassword,@RoleID,@Email,@DisplayName,@UserTypeLogin,@UserType,'True',@bit_for_reports_case_search,@bit_for_Provider_Cases,@DomainId,@ProviderId)
end
else
begin
	update IssueTracker_Users 
	set UserName=@UserName,
		UserPassword=@UserPassword,
		Email=@Email,
		DisplayName=@DisplayName,
		bit_for_reports_case_search=@bit_for_reports_case_search,
		bit_for_Provider_Cases =@bit_for_Provider_Cases,
		DomainId=@DomainId
	where UserId=@userid
end
end



