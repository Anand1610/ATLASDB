CREATE PROCEDURE [dbo].[procInsCaseDesk] (  
@DomainId nvarchar(50),
@Case_Id varchar(40),  
@did int  
) as  
begin  
declare @cnt int  
select @cnt = count(*) from tblCaseDesk where Case_Id=@Case_Id and desk_id=@did  and DomainId=@DomainId
print @cnt  
if @cnt = 0   
begin  
Insert into tblCaseDesk (Case_Id,Desk_Id,DomainId)values (@Case_Id,@did,@DomainId)  
end  
end

