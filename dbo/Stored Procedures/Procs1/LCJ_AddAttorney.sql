CREATE PROCEDURE [dbo].[LCJ_AddAttorney]    
(    
    
--ClaimRep_Id nvarchar no 100    
@DomainId nvarchar(50),  
@Defendant_Id   nvarchar(50),    
@Attorney_LastName  nvarchar(100),    
@Attorney_FirstName  nvarchar(100),   
@Attorney_Address nvarchar(255),   
@Attorney_City   nvarchar(50),    
@Attorney_State  nvarchar(50),    
@Attorney_Zip   nvarchar(50),    
@Attorney_Phone  nvarchar(50),    
@Attorney_Fax   nvarchar(50),    
@Attorney_Email  nvarchar(50)    
    
    
--@OperationResult INTEGER OUT    
)    
AS    
BEGIN    
 DECLARE @AttorneyID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME    
    
 DECLARE @MaxAttorney_Id_IDENTITY AS INTEGER    
     
 SET @CurrentDate = Convert(Varchar(15), GetDate(),102)    
    
     
 BEGIN    
      
  -- Insert the records    
  BEGIN TRAN    
   -- Insert Claim Details    
  INSERT INTO tblAttorney     
  (    
  DomainId,  
  Attorney_Id,     
  Defendant_Id,    
  Attorney_LastName,    
  Attorney_FirstName,    
  Attorney_Address,  
  Attorney_City,    
  Attorney_State,    
  Attorney_Zip,    
  Attorney_Phone,    
  Attorney_Fax,    
  Attorney_Email    
  )    
    
  VALUES(    
  @DomainId,  
  '',    
  @Defendant_Id,    
  @Attorney_LastName,    
  @Attorney_FirstName,  
  @Attorney_Address,  
  @Attorney_City,    
  @Attorney_State,    
  @Attorney_Zip,    
  @Attorney_Phone,    
  @Attorney_Fax,    
  @Attorney_Email    
  )         
    
  COMMIT TRAN    
     
  SET @MaxAttorney_Id_IDENTITY = @@IDENTITY    
       
  SET @AttorneyID  = 'A' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxAttorney_Id_IDENTITY AS NVARCHAR)    
       
  UPDATE tblAttorney  SET Attorney_Id = @AttorneyID where Attorney_AutoId = @MaxAttorney_Id_IDENTITY  AND DomainId = @DomainId  
    
 END -- END of ELSE     
    
END  
  
