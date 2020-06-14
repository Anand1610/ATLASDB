CREATE PROCEDURE [dbo].[display_column_retrieve_Case_Search]        
 @i_a_user_id int =1,      
 @s_a_DomainId varchar(50)=''      
AS        
BEGIN        
         
 Declare @CompanyType varchar(150)=''      
 Select TOP 1 @CompanyType =  LOWER(LTRIM(RTRIM(CompanyType))) from tbl_Client(NOLOCK) Where DomainId=@s_a_DomainId      
  --Retrieve Unmapped columns        
           
  select         
   *           
  from         
   tbl_display_column_Case_Search         
  where        
   ISNULL(is_default,0)=0        
   --and (CompanyType is null or CompanyType=@CompanyType )    
  ORDER BY         
   display_name,column_order     
        
        
  --Retrieve mapped columns        
        
  select         
   *           
  from         
   tbl_display_column_Case_Search         
  where        
   ISNULL(is_default,0)=1        
  ORDER BY         
   column_order , display_name        
END 



