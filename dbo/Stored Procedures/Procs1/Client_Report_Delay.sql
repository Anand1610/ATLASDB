CREATE PROCEDURE Client_Report_Delay    
AS  
BEGIN  
  
 SET NOCOUNT ON;  
	Select * from tblClient_Shared_Report_Details 
	Where ISNULL(Is_DelayAlertSent,0) = 0 AND ISNULL(is_processed,0) = 0 AND DATEDIFF(MINUTE, Report_Date, GETDATE()) > 120 
END  
  