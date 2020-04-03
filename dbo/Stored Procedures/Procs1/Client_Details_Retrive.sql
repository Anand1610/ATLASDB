  
--- DROP PROCEDURE Client_Details  
CREATE PROCEDURE [dbo].[Client_Details_Retrive]  
(  
   @s_a_DomainID VARCHAR(50)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
           
   SELECT   
    LawFirmName,  
    CL.DomainID,  
    CompanyType,  
    Client_First_Name,  
    Client_Last_Name,  
    Client_Billing_Address,  
    Client_Billing_City,  
    Client_Billing_State,  
    Client_Billing_Zip,  
    Client_Billing_Phone,  
    Client_Billing_Fax,  
    Client_Contact,  
    Client_Email,  
    CLIENT_ATTORNEY_NAME_1,  
    CLIENT_ATTORNEY_NAME_2,      
    CLIENT_ATTORNEY_NAME_3,  
    CLIENT_ATTORNEY_NAME_4,  
    CLIENT_ATTORNEY_NAME_5,  
    POSTAGE_ADDRESS,  
    NOTARY_DETAILS,  
    NOTARY_SIGNED_BY_NAME,  
    ADMINISTRATIVE_ASSISTANT  
  FROM tbl_Client cl  
  LEFT OUTER JOIN tbl_client_other_details cld on cl.DomainId = cld.DomainID  
  WHERE   
   cl.DomainID = @s_a_DomainID  
    
  
END  
  
  
  
