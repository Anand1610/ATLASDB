CREATE PROCEDURE [dbo].[DiscConfNote](    
@DomainId NVARCHAR(50),
@cid varchar(50)    
)    
as    
begin    
update tblcase set date_disc_conf_letter_printed=getdate() where case_id=@cid and DomainId=@DomainId    
end

