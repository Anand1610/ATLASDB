
CREATE PROCEDURE [dbo].[SaveSessionID]  
@SessionID varchar(500),  
@domainID  varchar(50) ,
@UserId int= NULL
as  
  
Insert into UserSession(SessionID,domainID, CreateDate, UserId)  
values(@SessionID,@domainID, getdate(), @UserId)



