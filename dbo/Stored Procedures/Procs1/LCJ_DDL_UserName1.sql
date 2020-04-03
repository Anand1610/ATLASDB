CREATE PROCEDURE [dbo].[LCJ_DDL_UserName1]
  @DomainId nvarchar(50)
As
 
Begin
	select '...Select user to assign...' [userid], '' [userName]
	union
	select username ,USERID  from issuetracker_users where (userName not in('')) and DomainId=@DomainId order by USERID
end

