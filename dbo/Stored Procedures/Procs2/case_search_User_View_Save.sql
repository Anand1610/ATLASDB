CREATE PROCEDURE [dbo].[case_search_User_View_Save]  
(   
 @i_a_query_id     INT,  
 @s_a_query_name     NVARCHAR  (MAX),  
 @i_a_UserId      INT,  
 @DomainID      VARCHAR(50),  
 @s_column_value     VARCHAR(MAX) = '',  
 @s_a_column_name    VARCHAR(MAX) = ''

)  
AS  
BEGIN   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 DECLARE @s_l_message NVARCHAR(MAX)  
 DECLARE @i_l_result int  
 IF not exists(select * from case_search_User_View where userid=@i_a_UserId)  
 BEGIN  
  INSERT INTO case_search_User_View
  (  
   domainid,  
   column_value,  
   column_name,  
   query_name,  
   userid,  
   create_date
  
  )  
  VALUES  
  (  
   @DomainID, 
    @s_column_value,  
    @s_a_column_name,  
    @s_a_query_name,  
    @i_a_UserId,  
     
   
    getdate()
    
  )    
    
  set @i_l_result=@@IDENTITY        
 END  
 ELSE  
 BEGIN  
  UPDATE  
   case_search_User_View  
  SET  
   query_name     = @s_a_query_name,  
   modified_userid    = @i_a_UserId,  
   column_value    = @s_column_value,  
   column_name     = @s_a_column_name,  
   modified_date    = getdate()
  
  WHERE  
   userid   = @i_a_UserId and  
   domainid     = @DomainID   
      
  set @i_l_result=@i_a_query_id  
 END   
   
 SET @s_l_message = 'Search query details saved successfully'  
 SELECT @s_l_message AS [Message],@i_l_result as Result  
END  