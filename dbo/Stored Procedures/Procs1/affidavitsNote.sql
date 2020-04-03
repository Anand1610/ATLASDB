CREATE PROCEDURE [dbo].[affidavitsNote](  
@cid varchar(50)  
)  
as  
begin  
update tbltobeprinted_aff set printed=1 where case_id=@cid  
end

