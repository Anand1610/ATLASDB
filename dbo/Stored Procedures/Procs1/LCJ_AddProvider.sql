CREATE PROCEDURE [dbo].[LCJ_AddProvider] 
(  
  
--Provider_Id nvarchar no 100  
@DomainID NVARCHAR(50),
@Provider_Name  nvarchar(200),  
@Provider_Type  varchar(40),  
@Provider_Billing  float,  
@Provider_Local_Address varchar( 255),  
@Provider_Local_City  varchar(100),  
@Provider_Local_State  varchar(100),  
@Provider_Local_Zip  varchar(50),  
@Provider_Local_Phone  varchar(100),  
@Provider_Local_Fax  varchar(100),  
@Provider_Contact  varchar(100),  
@Provider_Perm_Address varchar(255),  
@Provider_Perm_City  varchar(100),  
@Provider_Perm_State  varchar(100),  
@Provider_Perm_Zip  varchar(50),  
@Provider_Perm_Phone  varchar(100),  
@Provider_Perm_Fax  varchar(100),  
@Provider_Email  varchar(100),  
@Refered_By                              nvarchar(100),  
@Provider_President varchar(100),  
@Provider_taxID varchar(100),  
@Provider_FF varchar(10),  
@Provider_ReturnFF varchar(10),  
@Provider_Notes                         varchar(4000),  
@Provider_GroupName                        nvarchar(50),
@Contact2                                   varchar(100),  
@Provider_IntBilling                     varchar(100),  
@Cost_balance                            money,  
@Invoice_Type                           varchar(100),  
@Security   varchar(10),  
@UserName   Nvarchar(40),  
@UserPassword   nvarchar(40),  
@OperationResult   INT OUTPUT,  
@NewUserError   INT OUTPUT,
@Provider_Rfunds tinyint  ,
@is_from_nassau bit = null,
@filereturn bit = null,
@Position nvarchar(4000),
@Practice nvarchar(4000)
 
)  
AS  
BEGIN  
 DECLARE @ProviderID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME       
  
 SET @CurrentDate = Convert(Varchar(15), GetDate(),102)  
   
 IF EXISTS(Select Provider_Name from tblProvider where Provider_Name = @Provider_Name)   
  BEGIN  
   SET @OperationResult = 1  
   Return 1  
  END  
 Else  
  
  BEGIN  
   
   
   DECLARE @MaxProvider_Id_IDENTITY INTEGER  
   -- Insert the records  
   BEGIN TRAN  
    -- Insert Claim Details  
   INSERT INTO tblProvider   
   (  
     
   Provider_Name,  
   Provider_Suitname,
   Provider_Type,  
   Provider_Billing,  
   Provider_Local_Address,  
   Provider_Local_City,  
   Provider_Local_State,  
   Provider_Local_Zip,  
   Provider_Local_Phone,  
   Provider_Local_Fax,  
   Provider_Contact,  
   Provider_Perm_Address,  
   Provider_Perm_City,  
   Provider_Perm_State,  
   Provider_Perm_Zip,  
   Provider_Perm_Phone,  
   Provider_Perm_Fax,  
   Provider_Email,  
   Provider_Contact2,  
   Provider_IntBilling,  
   Invoice_Type,  
   cost_balance,  
   Provider_Notes,  
   Provider_ReferredBy,  
   Provider_President,  
   Provider_TaxID,  
   Provider_FF,  
   Provider_ReturnFF,
   Provider_Rfunds,
   Provider_GroupName,
   isFromNassau,
   FileReturn,
   Position,
   Practice,
   DomainId
   )  
   
   VALUES(  
   
     
   @Provider_Name, 
   @Provider_Name, 
   @Provider_Type,  
   @Provider_Billing,  
   @Provider_Local_Address,  
   @Provider_Local_City,  
   @Provider_Local_State,  
   @Provider_Local_Zip,  
   @Provider_Local_Phone,  
   @Provider_Local_Fax,  
   @Provider_Contact,  
   @Provider_Perm_Address,  
   @Provider_Perm_City,  
   @Provider_Perm_State,  
   @Provider_Perm_Zip,  
   @Provider_Perm_Phone,  
   @Provider_Perm_Fax,  
   @Provider_Email,  
   @Contact2 ,  
   @Provider_IntBilling,  
   'E',  
   @Cost_balance,  
   @Provider_Notes,  
   @Refered_By,  
   @Provider_President,  
   @Provider_TaxID,  
   @Provider_FF,  
   @Provider_ReturnFF,
   @Provider_Rfunds,
   @Provider_GroupName,
   @is_from_nassau,
   @filereturn,
   @Position,
   @Practice,
   @DomainID
   )       
   
   
   COMMIT TRAN  
   
   SELECT @MaxProvider_Id_IDENTITY = MAX(Provider_Id) from tblProvider  
   
   SET @ProviderID  = 'PR' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxProvider_Id_IDENTITY AS NVARCHAR)  
   
   --UPDATE tblProvider SET Provider_Id =@MaxProvider_Id_IDENTITY  
   
     
   IF @Security = 'True'  
    BEGIN  
       
     IF (EXISTS(SELECT UserId FROM IssueTracker_Users WHERE Username = @Username and DomainId=@DomainID) OR EXISTS(SELECT UserId FROM IssueTracker_Users WHERE UserTypeLogin = @ProviderID and DomainId=@DomainID))  
  
     --IF EXISTS(SELECT Username FROM IssueTracker_Users WHERE Username = @Username)  
        
      BEGIN  
  
       SET @NewUserError = 1  
   
       RETURN 1  
  
      END  
     Else  
        
      BEGIN  
  
        INSERT IssueTracker_Users  
        (  
         Username,  
         RoleId,  
         Email,  
         DisplayName,  
         UserPassword,  
         UserTypeLogin,  
         UserType,
		 DomainId  
        )   
        VALUES   
        (  
         @Username,  
         '2',  
         @Provider_Email,  
         @Username,  
         @UserPassword,  
         Rtrim(Ltrim(@ProviderID)),  
         'P'  ,
		 @DomainID
        )  
    
        SET @NewUserError = 0  
     
        RETURN 0  
      END  
        
    END  
   /* TRIGGER to insert provider name in tblDesk*/  
   declare  
   @cnt int,  
   @pname varchar(100)  
   select @pname = provider_name from tblprovider where provider_Id = @MaxProvider_Id_IDENTITY  
   select @cnt = count(*) from tbldesk where desk_name = @pname  and DomainId=@DomainID
   if @cnt =0  
   begin  
    insert into tbldesk values (@pname,@DomainID)  
   end  
     
   SET @OperationResult = 0  
   SET @NewUserError = 0  
   RETURN 0  
  
  END -- END of ELSE   
  
END

