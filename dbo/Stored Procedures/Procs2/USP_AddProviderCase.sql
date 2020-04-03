CREATE PROCEDURE [dbo].[USP_AddProviderCase]  
  
(  
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
      @Status    nvarchar(40),       
      @Memo    nvarchar(255),    
      @Case_code varchar(100)=null ,
      @OperationResult INTEGER OUTPUT,  
      @NewCaseOutputResult VARCHAR(100) OUTPUT,
      @batchcode  nvarchar(50)=null,
      @Location_Id int,
      @insurancecompany_initial_address nvarchar(200),
	  @Representetive nvarchar(200),
	  @Representative_Contact_Number nvarchar(100),
	  @Assigned_Attorney nvarchar(200) OUTPUT,
	  @DateOpened Date OUTPUT,
	  @s_a_case_InitialStatus_old	NVARCHAR(200) Output,
	  @opened_by NVARCHAR(50)
	--  @DateOfService_Start DATETIME =NULL,
 --  	@DateOfService_End DATETIME =NULL,
	--@Claim_Amount MONEY=NULL,
	--@Paid_Amount MONEY=NULL,
	--@Date_BillSent	nvarchar(100)=NULL
)  
AS  
BEGIN  
 DECLARE @Case_Id AS NVARCHAR(50) , @CurrentDate AS SMALLDATETIME    
 SET @InjuredParty_LastName = RTRIM(LTRIM(@InjuredParty_LastName))  
 SET @InjuredParty_FirstName = RTRIM(LTRIM(@InjuredParty_FirstName))  
 SET @CurrentDate = Convert(Varchar(15), GetDate(),102)  

if(@Location_Id='' or @Location_Id=0)
	set @Location_Id=null;
		
		 DECLARE @MaxCase_ID VARCHAR(100)
		 DECLARE @MaxCaseAuto_ID INTEGER
		   
		SET @MaxCase_ID=ISNULL((SELECT top 1 tblProviderCase.Case_ID FROM tblProviderCase  WHERE DomainId=@DomainID ORDER BY Case_AUTOID DESC),'100000')
 
		SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)

		SET @Case_Id  = UPPER(@DomainID) + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)

	        Insert INTO tblProviderCase    
            (  
			 DomainId,
             Case_Id,
	         Case_Code,  
             Provider_Id,  
             InsuranceCompany_Id,  
            ClaimantParty_LastName,
			ClaimantParty_FirstName,
			ClaimantParty_Address,
			ClaimantParty_City,
			ClaimantParty_State,
			ClaimantParty_Zip,
			InsuredParty_LastName,  
             InsuredParty_FirstName,
             InsuredParty_Address, 
			 InsuredParty_City, 
             InsuredParty_State, 
             InsuredParty_Zip,   
             Incident_Date,  
             Policy_Number,  
             Ins_Claim_Number,            
             Status,  
             Date_Opened,   
             Memo,     
			 batchcode,
             Location_Id,
             INSURANCECOMPANY_INITIAL_ADDRESS,
             Representetive,
             Representative_Contact_Number,
             opened_by  
			--DateOfService_Start,
			--DateOfService_End,
			--Claim_Amount,
			--Paid_Amount,
			--Date_BillSent      
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
                         'Pending',  
             Convert(nvarchar(15), getdate(),101),   
             @Memo,  
          	 @batchcode,
             @Location_Id,
             @insurancecompany_initial_address,
             @Representetive,
             @Representative_Contact_Number,
             @opened_by
			 			--@DateOfService_Start,
			--@DateOfService_End ,
			--@Claim_Amount ,
			--@Paid_Amount ,
			--@Date_BillSent	
            )  

	  SET @DateOpened=Convert(nvarchar(15), getdate(),101)

     -----------------------------------------------------------------------------------------
      SET @NewCaseOutputResult = @Case_Id  
     
END

