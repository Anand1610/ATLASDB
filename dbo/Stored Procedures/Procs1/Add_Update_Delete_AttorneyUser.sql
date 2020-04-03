CREATE PROCEDURE [dbo].[Add_Update_Delete_AttorneyUser]    
(
@Id int = 0,
@Name varchar(50) = NULL,
@Email varchar(50) = NULL,
@Role varchar(255) = NULL,
@AttorneyFirmId int = 0,
@UserId int = 0,
@Address varchar(255) = NULL,
@City varchar(50) = NULL,
@State varchar(50) = NULL,
@Country varchar(50) = NULL,
@Zip int = NULL,
@DomainId varchar(50),
@Action varchar(10)
	) 
AS    
BEGIN  
if( @Action ='Insert')
 Begin
 insert into  [dbo].[tbl_AttorneyUser](Name,Email,Role,AttorneyFirmId,UserId,Address,City,State,Country,Zip,DomainId) values(@Name,@Email,@Role,@AttorneyFirmId,@UserId,@Address,@City,@State,@Country,@Zip,@DomainId)
 end 
 if(@Action ='Delete')
  Begin
   Delete from [dbo].[tbl_AttorneyUser] where UserId = @UserId and DomainId =@DomainId  
 end 

 if(@Action ='Select')
  Begin
   Select au.UserId,af.Name as AttorneyFirmName,af.Id as AttorneyFirmId,au.Name as AttorneyName,au.Role,itu.UserName,itu.UserPassword,au.Email,au.Address,au.City,au.State,au.Country,au.Zip,itu.IsActive from [dbo].[tbl_AttorneyUser] au join [dbo].[tbl_AttorneyFirm] af on au.AttorneyFirmId = af.Id join [dbo].[IssueTracker_Users] itu on itu.UserId =au.UserId   where au.DomainId =@DomainId 
  
 end 

 if(@Action ='Update')
  Begin
   Update [dbo].[tbl_AttorneyUser] set AttorneyFirmId=@AttorneyFirmId,Name=@Name,Role=@Role,Email=@Email,Address =@Address,City=@City,State=@State,Country=@Country,Zip=@Zip where  DomainId =@DomainId and UserId=@UserId
  
 end 

END
