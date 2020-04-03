CREATE PROCEDURE [dbo].[Available_Country_State_City]    
(
@DomainId varchar(50),
@CountryId int = 0,
@StateId int = 0,
@DataFor varchar(10)
	) 
AS    
BEGIN  
if(@DataFor ='Country')
  Begin
   SELECT '0' as Id,' ---Select Country--- ' as CountryText
	UNION
    select Id,CountryText from  [dbo].[tbl_Country] where DomainId=@DomainId 
 end 

 if(@DataFor ='State')
  Begin
   SELECT '0' as Id,' ---Select State--- ' as StateText
	UNION
    select Id,StateText from  [dbo].[tbl_State] where DomainId=@DomainId and CountryId=@CountryId  
 end 

 if(@DataFor ='City')
  Begin
   SELECT '0' as Id,' ---Select City--- ' as StateText
	UNION
    select Id,CityText from  [dbo].[tbl_City] where DomainId=@DomainId and StateId=@StateId  
 end 
   
END
