CREATE PROCEDURE [dbo].[LCJ_AddDenialReasons]    
(  
@DomainId NVARCHAR(50),
 @DenialReasons_Type  nvarchar(100),  
 @I_CATEGORY_ID int  
)    
AS    
BEGIN    
 BEGIN    
  BEGIN TRAN    
 INSERT INTO tblDenialReasons    
 (    
  DenialReasons_Type,  
  I_CATEGORY_ID  ,
  DomainId
 )    
    
 VALUES(    
   @DenialReasons_Type,  
   @I_CATEGORY_ID    ,
   @DomainId
 )  
  COMMIT TRAN  
 END -- END of ELSE  
END

