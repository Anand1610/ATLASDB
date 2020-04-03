CREATE PROCEDURE [dbo].[LCJ_DDL_Assign_Work_Desk]  
AS  
begin  
 
SELECT UserID,UserName from issuetracker_users
order by username

end

