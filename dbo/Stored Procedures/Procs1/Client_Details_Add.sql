  
--- DROP PROCEDURE Client_Details  
CREATE PROCEDURE [dbo].[Client_Details_Add]  
(  
   @s_a_LawFirmName     VARCHAR(100),      
   @s_a_DomainID           VARCHAR(50),     
   @s_a_CompanyType     VARCHAR(50),  
   @s_a_Client_First_Name           varchar(100),  
   @s_a_Client_Last_Name            varchar(100),  
   @s_a_Client_Billing_Address     NVARCHAR(200),  
   @s_a_Client_Billing_City         NVARCHAR(200),  
   @s_a_Client_Billing_State        VARCHAR(200),  
   @s_a_Client_Billing_Zip         NVARCHAR(200),  
   @s_a_Client_Billing_Phone        NVARCHAR(200),  
   @s_a_Client_Billing_Fax   NVARCHAR(200),  
   @s_a_Client_Contact       NVARCHAR(200),  
   @s_a_Client_Email                NVARCHAR(200),  
   @s_a_CLIENT_ATTORNEY_NAME_1  VARCHAR(200),     
   @s_a_CLIENT_ATTORNEY_NAME_2      VARCHAR(200),  
   @s_a_CLIENT_ATTORNEY_NAME_3     VARCHAR(200),     
   @s_a_CLIENT_ATTORNEY_NAME_4     VARCHAR(200),  
   @s_a_CLIENT_ATTORNEY_NAME_5     VARCHAR(200),     
   @s_a_POSTAGE_ADDRESS             VARCHAR(500),  
   @s_a_NOTARY_DETAILS             VARCHAR(1000),  
   @s_a_NOTARY_SIGNED_BY_NAME     VARCHAR(200),  
   @s_a_ADMINISTRATIVE_ASSISTANT      NVARCHAR(200),    
   @s_a_Created_By_User          VARCHAR(100)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @i_l_result    INT  
 DECLARE @s_l_message   NVARCHAR(500)  
 DECLARE @s_l_LawFirmName  VARCHAR(200)  
 DECLARE @s_l_notes_desc   NVARCHAR(MAX)  
   
  
     IF NOT EXISTS(SELECT DomainID FROM tbl_Client WHERE  DomainID = @s_a_DomainID)  
     BEGIN  
          BEGIN TRAN  
        INSERT INTO tbl_Client  
        (  
         LawFirmName,  
      DomainID,  
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
      Client_Email  
             
        )  
        VALUES  
        (  
                  @s_a_LawFirmName,  
      @s_a_DomainID,  
      @s_a_CompanyType ,  
      @s_a_Client_First_Name ,  
      @s_a_Client_Last_Name,  
      @s_a_Client_Billing_Address ,  
      @s_a_Client_Billing_City ,  
                  @s_a_Client_Billing_State ,  
                  @s_a_Client_Billing_Zip,  
                  @s_a_Client_Billing_Phone,  
                  @s_a_Client_Billing_Fax,  
      @s_a_Client_Contact,                   
      @s_a_Client_Email   
       
        )  
  
    COMMIT TRAN   
     END   
  ELSE  
  BEGIN  
  
   UPDATE tbl_Client  
   SET   
     LawFirmName   = @s_a_LawFirmName,                      
     CompanyType      = @s_a_CompanyType,  
     Client_First_Name  = @s_a_Client_First_Name,  
     Client_Last_Name  = @s_a_Client_Last_Name,  
     Client_Billing_Address = @s_a_Client_Billing_Address,  
     Client_Billing_City = @s_a_Client_Billing_City,  
     Client_Billing_State = @s_a_Client_Billing_State,  
     Client_Billing_Zip  = @s_a_Client_Billing_Zip,  
     Client_Billing_Phone = @s_a_Client_Billing_Phone,  
     Client_Billing_Fax  = @s_a_Client_Billing_Fax,  
     Client_Contact   = @s_a_Client_Contact,  
     Client_Email   = @s_a_Client_Email  
    WHERE DomainId = @s_a_DomainID  
  END   
  
   
   
  IF NOT EXISTS(SELECT DomainID FROM tbl_client_other_details WHERE  DomainID = @s_a_DomainID)  
  BEGIN  
          BEGIN TRAN  
    INSERT INTO tbl_client_other_details  
      (  
       CLIENT_ATTORNEY_NAME_1,  
       CLIENT_ATTORNEY_NAME_2,      
       CLIENT_ATTORNEY_NAME_3,  
       CLIENT_ATTORNEY_NAME_4,  
       CLIENT_ATTORNEY_NAME_5,  
       POSTAGE_ADDRESS,  
       NOTARY_DETAILS,  
       NOTARY_SIGNED_BY_NAME,  
       ADMINISTRATIVE_ASSISTANT,  
       DomainID             
      )  
      VALUES  
      (  
                    
       @s_a_CLIENT_ATTORNEY_NAME_1,     
       @s_a_CLIENT_ATTORNEY_NAME_2 ,  
       @s_a_CLIENT_ATTORNEY_NAME_3,     
       @s_a_CLIENT_ATTORNEY_NAME_4,  
       @s_a_CLIENT_ATTORNEY_NAME_5,     
       @s_a_POSTAGE_ADDRESS ,  
       @s_a_NOTARY_DETAILS ,  
       @s_a_NOTARY_SIGNED_BY_NAME,  
       @s_a_ADMINISTRATIVE_ASSISTANT,  
       @s_a_DomainID  
      )  
    COMMIT TRAN  
     
     END  
  ELSE  
  BEGIN  
   BEGIN TRAN  
    UPDATE tbl_client_other_details  
    SET   
      CLIENT_ATTORNEY_NAME_1 = @s_a_CLIENT_ATTORNEY_NAME_1,                      
      CLIENT_ATTORNEY_NAME_2 = @s_a_CLIENT_ATTORNEY_NAME_2,  
      CLIENT_ATTORNEY_NAME_3 = @s_a_CLIENT_ATTORNEY_NAME_3,  
      CLIENT_ATTORNEY_NAME_4 = @s_a_CLIENT_ATTORNEY_NAME_4,  
      CLIENT_ATTORNEY_NAME_5 = @s_a_CLIENT_ATTORNEY_NAME_5,  
      POSTAGE_ADDRESS  = @s_a_POSTAGE_ADDRESS,  
      NOTARY_DETAILS         = @s_a_NOTARY_DETAILS,  
      NOTARY_SIGNED_BY_NAME = @s_a_NOTARY_SIGNED_BY_NAME,  
      ADMINISTRATIVE_ASSISTANT = @s_a_ADMINISTRATIVE_ASSISTANT  
    WHERE   
      
       DomainID = @s_a_DomainID  
   COMMIT TRAN  
     
  END  
  
  
  SET @s_l_message  =  'Details saved successfully'  
  SET @i_l_result  =  0  
  SET @s_l_notes_desc = 'Client details Saved -'+  @s_a_LawFirmName   
  EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Client Details',@DomainID =@s_a_DomainID   
   
  SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]   
  
END  
  
  
  
