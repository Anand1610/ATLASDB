CREATE PROCEDURE [dbo].[AddDelete_AttorneyRole]    
(
@id int =0,
@RoleName nvarchar(50) = null,
@DomainId nvarchar(50),
@Action varchar(10)
	) 
AS    
BEGIN  
  if( @Action ='Insert')
 Begin
 insert into  [dbo].[tbl_AttorneyRoles] values(@RoleName,@DomainId)
 end 
 if(@Action ='Delete')
  Begin
   Delete from [dbo].[tbl_AttorneyRoles] where Id = @Id and DomainId =@DomainId  
 end 
 if(@Action ='View')
  Begin
   Select Id,RoleName  from [dbo].[tbl_AttorneyRoles] where  DomainId =@DomainId  
 end
END
