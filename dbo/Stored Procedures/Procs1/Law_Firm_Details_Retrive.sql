  
--- DROP PROCEDURE Client_Details  
CREATE PROCEDURE [dbo].[Law_Firm_Details_Retrive]  
(  
  
   @s_a_DomainID VARCHAR(50)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
           
   SELECT * 
   FROM tbl_Client
  --LEFT OUTER JOIN tblcase c on ci.case_id = c.case_id and ci.domainid = c.DomainId 
  WHERE  DomainID = @s_a_DomainID  
    
  
END  
  
  
  
