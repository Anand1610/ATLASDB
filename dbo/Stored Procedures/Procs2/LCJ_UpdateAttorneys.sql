CREATE PROCEDURE [dbo].[LCJ_UpdateAttorneys]  
(  
@DomainId varchar(40),  
@Attorney_Id  varchar(40),  
@Attorney_LastName varchar(100),  
@Attorney_FirstName varchar(100),  
@Attorney_Address VARCHAR(200),  
@Attorney_City  varchar(150),  
@Attorney_State varchar(50),  
@Attorney_Zip  varchar(50),  
@Attorney_Phone varchar(20),  
@Attorney_Fax  varchar(20),  
@Attorney_Email varchar(40),  
@Defendant_Id  nvarchar(100)  
  
)  
AS  
BEGIN  
 BEGIN  
  BEGIN TRAN  
  
  UPDATE  tblAttorney   
    
  SET   
  DomainId = @DomainId,  
  Attorney_LastName=@Attorney_LastName,  
  Attorney_FirstName=@Attorney_FirstName,  
  Attorney_City=@Attorney_City,  
  Attorney_Address=@Attorney_Address,  
  Attorney_State=@Attorney_State,  
  Attorney_Zip=@Attorney_Zip,  
  Attorney_Phone=@Attorney_Phone,  
  Attorney_Fax=@Attorney_Fax,  
  Attorney_Email=@Attorney_Email,  
  Defendant_Id=@Defendant_Id  
  
  WHERE  
  
  Attorney_Id = @Attorney_Id  
   
  COMMIT TRAN  
  
 END  
  
END  
  
