
CREATE PROCEDURE [dbo].[CLIENT_DETAILS]  
(  
 @DomainId NVARCHAR(20)  
)  
AS  
BEGIN  
 SELECT   
		LawFirmName AS [LawFirmName],  
		isnull(Client_Billing_Address,'') [SZ_ADDRESS1],  
		isnull(Client_Billing_City,'') + ', '+ISNULL(Client_Billing_State,'') + ' ' + isnull(Client_Billing_Zip,'') [SZ_ADDRESS2]  
    
 FROM tbl_Client  
 WHERE   
  DomainId = @DomainId  
    
END

