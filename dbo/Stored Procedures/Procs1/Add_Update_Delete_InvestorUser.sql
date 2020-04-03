CREATE PROCEDURE [dbo].[Add_Update_Delete_InvestorUser]            
(        
@Id int = 0,        
@Name varchar(50) = NULL,       
@ContactNo varchar(50) = NULL,        
@Email varchar(50) = NULL,        
@Role varchar(255) = NULL,         
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
 insert into  [dbo].[tbl_Investor](Name,Email,ContactNo,UserId,Address,City,State,Country,Zip,DomainId)   
 values       (@Name,@Email,@ContactNo,@UserId,@Address,@City,@State,@Country,@Zip,@DomainId)   
        
 select InvestorId   
 from   tbl_Investor   
 where UserId=@UserId and DomainId=@DomainId  
  
 end         
 if(@Action ='Delete')        
  Begin        
    Delete from [dbo].[tbl_Investor] where UserId = @UserId and DomainId =@DomainId           
 end         
        
-- if(@Action ='Select')        
--  Begin        
--   Select au.UserId,af.Name as AttorneyFirmName,af.Id as AttorneyFirmId,au.Name as AttorneyName,au.Role,itu.UserName,itu.UserPassword,au.Email,au.Address,au.City,au.State,au.Country,au.Zip,itu.IsActive from [dbo].[tbl_AttorneyUser] au join [dbo].[tbl_At
  
    
--rneyFirm] af on au.AttorneyFirmId = af.Id join [dbo].[IssueTracker_Users] itu on itu.UserId =au.UserId   where au.DomainId =@DomainId         
          
-- end         
        
 if(@Action ='Update')        
  Begin        
   Update [dbo].[tbl_Investor]  
    set   Name=@Name ,Email=@Email,ContactNo=@ContactNo,  
       Address =@Address,City=@City,State=@State,     
    Country=@Country,Zip=@Zip where  DomainId =@DomainId and UserId=@UserId      
    
            
   select InvestorId   
   from   tbl_Investor   
   where UserId=@UserId and DomainId=@DomainId      
 end         
        
END
