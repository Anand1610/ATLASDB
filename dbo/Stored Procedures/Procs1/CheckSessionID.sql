
CREATE PROCEDURE [dbo].[CheckSessionID]
@SessionID varchar(500),
@domainID  varchar(50),
@UserId int = NULL
as
BEGIN
select top 1 SessionID from  UserSession where SessionID=@SessionID and domainId=@domainID and (@UserId is null or UserId=@UserId )
order by CreateDate Desc
END
