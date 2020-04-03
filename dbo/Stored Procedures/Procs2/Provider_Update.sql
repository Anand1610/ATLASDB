CREATE PROCEDURE [dbo].[Provider_Update]      
(      
    @DomainId						 nvarchar(50), 
	@i_a_Provider_Id				 INT,      
	@s_a_Provider_Name				 NVARCHAR(200),
	@s_a_Provider_SuitName			 NVARCHAR(200),
	@s_a_Funding_Company			 VARCHAR(100),
	@s_a_Provider_President			 VARCHAR(100),   
	@s_a_Provider_Type				 VARCHAR(40),      
	@s_a_Provider_TaxID				 VARCHAR(100),     
	@s_a_Provider_FF				 VARCHAR(10),   
	@s_a_Provider_RETURNFF			 VARCHAR(10),	  
	@s_a_Provider_Rebuttal			 VARCHAR(10),	
	@s_a_Settlement_Principal		FLOAT,
	@s_a_Settlement_Interest		FLOAT, 
	@f_a_Provider_Billing			 float,
	@f_a_Provider_Initial_Billing	 FLOAT, 
	@f_a_Provider_INTBilling		 FLOAT,
	@f_a_Provider_Initial_IntBilling FLOAT,    
	@s_a_Provider_Local_Address		 VARCHAR(255),      
	@s_a_Provider_Local_City		 VARCHAR(100),      
	@s_a_Provider_Local_State		 VARCHAR(100),      
	@s_a_Provider_Local_Zip			 VARCHAR(50),      
	@s_a_Provider_Local_Phone		 VARCHAR(100),      
	@s_a_Provider_Local_Fax			 VARCHAR(100),   
	@s_a_Provider_Contact			 VARCHAR(100),      
	@s_a_Provider_Email				 VARCHAR(100),      
	@s_a_Provider_Perm_Address		 VARCHAR(255),      
	@s_a_Provider_Perm_City			 VARCHAR(100),      
	@s_a_Provider_Perm_State		 VARCHAR(100),      
	@s_a_Provider_Perm_Zip			 VARCHAR(50),      
	@s_a_Provider_Perm_Phone		 VARCHAR(100),      
	@s_a_Provider_Perm_Fax			 VARCHAR(100),      
	@s_a_Provider_Notes				 NVARCHAR(4000),   
	@s_a_Provider_GroupName			 NVARCHAR(50)= null, 
	@s_a_LawFirm_Attorney		     NVARCHAR(50),       
	@s_a_Contact2					 VARCHAR(100), 
	@s_a_Contact3					 VARCHAR(100),      
	@s_a_Refered_By					 VARCHAR(100),  
	@m_a_Cost_balance				 money,      
	@s_a_Invoice_Type				 VARCHAR(100),      	  
	@s_a_Provider_Collection_Agent	 NVARCHAR(100)=null,
	@s_a_Billing_Manager			 NVARCHAR(200)=null, 
	@s_a_Provider_SeesFF			 NVARCHAR(10)=null,  
	@s_a_Provider_SeesRFF			 NVARCHAR(10)=null,  
	@s_a_Provider_InvoicedFF		 NVARCHAR(50)=null,  
	@s_a_SZ_SHORT_NAME				 NVARCHAR(100)=null,  
	@b_a_BX_SERV					 bit=null,  
	@f_a_BX_SHR_FEE					 float=null,  
	@s_a_BX_PSTG					 money=null,  
	@s_a_SD_CODE					 VARCHAR(5)=null,  
	@i_a_BX_FEE_SCHEDULE			 INT = null,
	@b_a_is_from_nassau				 BIT = NULL,
	@s_a_BitVerification			 INT=null,
	@i_a_active						 BIT = NULL ,
	@i_a_filereturn					 bit = null,	
	@s_a_Email_For_Arb_Awards		 NVARCHAR(200),
	@s_a_Email_For_Invoices			 NVARCHAR(200),
	@s_a_Email_For_Closing_Reports	 NVARCHAR(200),
	@s_a_Email_For_Monthly_Report	 NVARCHAR(200),
	@s_a_Packet_Type				 VARCHAR(10),
	@s_a_Vendor_Service              BIT,
	@s_a_Vendor_Service_Type         VARCHAR(50) = NULL,
	@s_a_Vendor_Fee                  FLOAT = NULL,
	@s_a_Vendor_Name                 VARCHAR(200) = NULL,
	@AmountType varchar(50) = NULL,      
    @ProviderSlabs ProviderSlabs readonly        
)      
      
AS      
BEGIN     
UPDATE tblProvider  SET      
	Provider_Name				= @s_a_Provider_Name,   
	Provider_Suitname			= @s_a_Provider_SuitName,
	Provider_Type				= @s_a_Provider_Type,  
	Funding_Company				= @s_a_Funding_Company ,   
	Provider_Billing			= @f_a_Provider_Billing,    
	Provider_Initial_Billing	= @f_a_Provider_Initial_Billing,
	Provider_Local_Address		= @s_a_Provider_Local_Address,      
	Provider_Local_City			= @s_a_Provider_Local_City,      
	Provider_Local_State		= @s_a_Provider_Local_State,      
	Provider_Local_Zip			= @s_a_Provider_Local_Zip,      
	Provider_Local_Phone		= @s_a_Provider_Local_Phone,      
	Provider_Local_Fax			= @s_a_Provider_Local_Fax,      
	Provider_Contact			= @s_a_Provider_Contact,      
	Provider_Perm_Address		= @s_a_Provider_Perm_Address,      
	Provider_Perm_City			= @s_a_Provider_Perm_City,      
	Provider_Perm_State			= @s_a_Provider_Perm_State,      
	Provider_Perm_Zip			= @s_a_Provider_Perm_Zip,      
	Provider_Perm_Phone			= @s_a_Provider_Perm_Phone,      
	Provider_Perm_Fax			= @s_a_Provider_Perm_Fax,      
	Provider_Email				= @s_a_Provider_Email,      
	Provider_Contact2			= @s_a_Contact2, 
	Provider_Contact3			= @s_a_Contact3,      
	Provider_Notes				= @s_a_Provider_Notes,
	Packet_Type                 = @s_a_Packet_Type,
	Provider_ReferredBy			= @s_a_Refered_By,   
	Provider_INTBilling			= @f_a_Provider_INTBilling,
	Provider_Initial_IntBilling	= @f_a_Provider_Initial_IntBilling,      
	Invoice_Type				= @s_a_Invoice_Type,       
	cost_balance				= @m_a_Cost_balance,      
	Provider_President			= @s_a_Provider_President,      
	Provider_TaxID				= @s_a_Provider_TaxID,      
	Provider_FF					= @s_a_Provider_FF,      
	Provider_RETURNFF			= @s_a_Provider_RETURNFF,	
	Provider_Rebuttal			= @s_a_Provider_Rebuttal,
	Settlement_Principal		= @s_a_Settlement_Principal,
	Settlement_Interest			= @s_a_Settlement_Interest,	
	Provider_GroupName			= @s_a_Provider_GroupName, 
	LawFirm_Attorney			= @s_a_LawFirm_Attorney,      
	Provider_Collection_Agent	= @s_a_Provider_Collection_Agent,
	Billing_Manager				= @s_a_Billing_Manager,  
	Provider_SeesFF				= @s_a_Provider_SeesFF,   
	Provider_SeesRFF			= @s_a_Provider_SeesRFF,  
	Provider_InvoicedFF			= @s_a_Provider_InvoicedFF,  
	SZ_SHORT_NAME				= @s_a_SZ_SHORT_NAME,  
	BX_SERV						= @b_a_BX_SERV,     
	BX_SHR_FEE					= @f_a_BX_SHR_FEE,     
	BX_PSTG						= @s_a_BX_PSTG,     
	SD_CODE						= @s_a_SD_CODE,     
	BX_FEE_SCHEDULE				= @i_a_BX_FEE_SCHEDULE, 
	isFromNassau				= @b_a_is_from_nassau ,
	active						= @i_a_active,
	BitVerification				= @s_a_BitVerification,
	FileRETURN					= @i_a_filereturn,	
	Email_For_Arb_Awards		= @s_a_Email_For_Arb_Awards,
	Email_For_Invoices			= @s_a_Email_For_Invoices,
	Email_For_Closing_Reports	= @s_a_Email_For_Closing_Reports,
	Email_For_Monthly_Report	= @s_a_Email_For_Monthly_Report,
	Vendor_Service           = @s_a_Vendor_Service,
	Vendor_Fee_Type          = @s_a_Vendor_Service_Type,
	Vendor_Fee               = @s_a_Vendor_Fee,
	Vendor_Name              = @s_a_Vendor_Name

	
WHERE       
  Provider_Id	= Rtrim(Ltrim(@i_a_Provider_Id))
  and DomainId	= @DomainId

  IF EXISTS(SELECT top 1 SlabFrom FROM @ProviderSlabs) and @s_a_Vendor_Service = 1          
   BEGIN          
   delete from tblProvider_Slabs where providerid = @i_a_Provider_Id        
   INSERT INTO tblProvider_Slabs(ProviderId,SlabFrom,SlabTo,VendorFee,AmountType)          
   SELECT @i_a_Provider_Id,SlabFrom,SlabTo,VendorFee,@AmountType FROM @ProviderSlabs    
   
   END  
   ELSE
   BEGIN
   delete from tblProvider_Slabs where providerid = @i_a_Provider_Id  
   END
    
   if @s_a_Vendor_Service = 0  OR @s_a_Vendor_Service_Type='Flat Fee'  
   BEGIN    
   delete from tblProvider_Slabs where providerid = @i_a_Provider_Id     
   END          

END

