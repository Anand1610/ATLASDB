CREATE PROCEDURE [dbo].[LCJ_DDL_Assign_To_Work_Desk]    
AS        
begin        
	SELECT tbldesk.Desk_Id,tbldesk.Desk_Name from tbldesk inner join issuetracker_users  
	on tbldesk.desk_name=issuetracker_users.username  
	order by username  
end

