CREATE PROCEDURE [dbo].[GetAllInvetorsName]        
(    
@DomainId VARCHAR(50)   
 )     
AS        
BEGIN      
    
   SELECT   Name as Name,  
   InvestorId AS InvestorId   
   FROM tbl_Investor    
   WHERE DomainId =@DomainId     
      
    
END
