CREATE PROCEDURE [dbo].[DemandsNote](    
@cid varchar(50)    
)    
as    
begin    
update tblcase set date_demands_printed=getdate() where case_id=@cid    
end

