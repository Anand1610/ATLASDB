

CREATE PROCEDURE [dbo].[LCJ_AddDataEntry1]  
  
(  
--Case_AutoId int 4  
--@Case_Id    nvarchar(100),  
	  @DomainID nvarchar(50),
      @Provider_Id    nvarchar(100),  
      @InsuranceCompany_Id   nvarchar(100),  
      @InjuredParty_LastName  nvarchar(200),  
      @InjuredParty_FirstName  nvarchar(200),
      @InjuredParty_Address nvarchar(200),
      @InjuredParty_City nvarchar(100),
      @InjuredParty_State nvarchar(100),
      @InjuredParty_Zip nvarchar(100),
      @InsuredParty_LastName  nvarchar(200),  
      @InsuredParty_FirstName  nvarchar(200), 
      @InsuredParty_Address nvarchar(200),
      @InsuredParty_City nvarchar(100),
      @InsuredParty_State nvarchar(100),
      @InsuredParty_Zip nvarchar(100),
      @Accident_Date   DATETIME,  
      @Policy_Number   nvarchar(50),  
      @Ins_Claim_Number   nvarchar(50),  
      @IndexOrAAA_Number   nvarchar(50),  
      @Status    nvarchar(40),  
      @Initial_Status    nvarchar(20),  
      @Memo    nvarchar(255),  
      @Court_Id    int=null,  
      @Case_code varchar(100)=null ,
      @OperationResult INTEGER OUTPUT,  
      @NewCaseOutputResult VARCHAR(100) OUTPUT,
      @batchcode  nvarchar(50)=null,
      @Location_Id int,
      --@insurancecompany_initial_address nvarchar(200),
	  @Representetive nvarchar(200),
	  @Representative_Contact_Number nvarchar(100),
	  @Assigned_Attorney nvarchar(200) OUTPUT,
	  @DateOpened Date OUTPUT,
	  @s_a_case_InitialStatus_old	NVARCHAR(200) Output,
	  @opened_by NVARCHAR(50),
	  @PortfolioId int =null,
	  @AttorneyFirmId int= null

)  
AS  
BEGIN  
 DECLARE @Case_Id AS NVARCHAR(50) , @CurrentDate AS SMALLDATETIME  
 --DECLARE @Date_Opened AS DATETIME  

 -- Remove Leading and ending spaces from the input parameters  
 SET @InjuredParty_LastName = RTRIM(LTRIM(@InjuredParty_LastName))  
 SET @InjuredParty_FirstName = RTRIM(LTRIM(@InjuredParty_FirstName))  
 SET @CurrentDate = Convert(Varchar(15), GetDate(),102)  

if(@Location_Id='' or @Location_Id=0)
	set @Location_Id=null;
 
		
		 DECLARE @MaxCase_ID VARCHAR(100)
		 DECLARE @MaxCaseAuto_ID INTEGER
		
		IF(@Initial_Status = 'ACTIVE' AND @DOMAINID = 'GLF' )
		BEGIN
			SET @MaxCase_ID=ISNULL((SELECT top 1 tblCase.Case_ID FROM tblCase  WHERE DomainId=@DomainID and Case_ID like 'ACT%' ORDER BY Case_AUTOID DESC),'100000')
			SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
			SET @Case_Id  = 'ACT' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)
		END
		ELSE IF(@Initial_Status = 'ACTIVE')
		BEGIN
			SET @MaxCase_ID=ISNULL((SELECT top 1 tblCase.Case_ID FROM tblCase  WHERE DomainId=@DomainID and Case_ID like 'ACT%' ORDER BY Case_AUTOID DESC),'100000')
			SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
			SET @Case_Id  = 'ACT-'+ @DomainID + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)
		END
		ELSE
		BEGIN
			SET @MaxCase_ID =ISNULL((SELECT top 1 tblCase.Case_ID FROM tblCase  WHERE DomainId=@DomainID And Case_Id not like  'ACT%' ORDER BY Case_AUTOID DESC),'100000')
			SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
			SET @Case_Id  = UPPER(@DomainID) + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)
		END
	
	

            Insert INTO tblcase    
            (  
			DomainId,
             Case_Id,
	         Case_Code,  
             Provider_Id,  
             InsuranceCompany_Id,  
             InjuredParty_LastName,  
             InjuredParty_FirstName,  
             InjuredParty_Address, 
		     InjuredParty_City, 
		     InjuredParty_State, 
		     InjuredParty_Zip, 
             InsuredParty_LastName,  
             InsuredParty_FirstName,
             InsuredParty_Address, 
			 InsuredParty_City, 
             InsuredParty_State, 
             InsuredParty_Zip,   
             Accident_Date,  
             Policy_Number,  
             Ins_Claim_Number,  
             IndexOrAAA_Number,  
             Status,  
             Date_Opened,  
             --Last_Status,  
             Initial_Status,  
             Memo,  
             Court_Id,
	         batchcode,
             Location_Id,
             --INSURANCECOMPANY_INITIAL_ADDRESS,
             Representetive,
             Representative_Contact_Number,
             opened_by,
			 PortfolioId,
			 AttorneyFirmId             
            )  
               
            VALUES  
            (  
			@DomainID,
             @Case_Id,  
	         @Case_Code,
             @Provider_Id,  
             @InsuranceCompany_Id,  
             @InjuredParty_LastName,  
             @InjuredParty_FirstName,  
             @InjuredParty_Address,
             @InjuredParty_City,
             @InjuredParty_State,
             @InjuredParty_Zip,
             @InsuredParty_LastName,  
             @InsuredParty_FirstName, 
             @InsuredParty_Address,
             @InsuredParty_City,
             @InsuredParty_State,
             @InsuredParty_Zip,    
             Convert(nvarchar(15), @Accident_Date, 101),  
             @Policy_Number,  
             @Ins_Claim_Number,  
             @IndexOrAAA_Number,  
             @Status,  
             Convert(nvarchar(15), getdate(),101),       
             --@Last_Status,  
             @Initial_Status,  
             @Memo,  
             @Court_Id,
	         @batchcode,
             @Location_Id,
             --@insurancecompany_initial_address,
             @Representetive,
             @Representative_Contact_Number,
             @opened_by,
			  @PortfolioId,
			 @AttorneyFirmId
            )  

	  SET @DateOpened=Convert(nvarchar(15), getdate(),101)
	  	  
	  INSERT INTO tblCase_Date_Details(DomainId, Case_Id, CreatedBy, CreatedDate)
	  VALUES (@DomainID, @Case_Id, @opened_by, GETDATE())

	  INSERT INTO tblCase_additional_info(DomainId, Case_Id)
	  VALUES ( @DomainID, @Case_Id)

	  EXEC sp_createDefaultDocTypesForTree  @DomainId,  @Case_Id, @Case_Id

     -----------------------------------------------------------------------------------------
      SET @NewCaseOutputResult = @Case_Id  
      SET @s_a_case_InitialStatus_old=@Initial_Status 
  

  
  --END -- END of ELSE   
   
END

