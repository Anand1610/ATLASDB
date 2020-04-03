CREATE PROCEDURE [dbo].[USP_GetLoggedProviderName]   
(
@DomainId varchar(50),
@UserName varchar(50)
 ) 
AS    
BEGIN  
    select Provider_Name, Provider_Id  from tblprovider (NOLOCK) where provider_id  in (select provider_id from TXN_PROVIDER_LOGIN (NOLOCK) 
     where user_id in(select userid from issuetracker_users (NOLOCK) where username=@UserName)) and DomainId= @DomainId  order by provider_name
    
END
