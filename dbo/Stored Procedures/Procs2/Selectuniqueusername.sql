CREATE PROCEDURE [dbo].[Selectuniqueusername]    
@DomainId NVARCHAR(50)    
as    
begin    
select distinct a.user_id,b.UserName,b.UserPassword as 'Password' from TXN_PROVIDER_LOGIN a inner join IssueTracker_Users b on a.user_id=b.UserId where b.IsActive='True' and b.DomainId=@DomainId order by b.UserName    
end    
