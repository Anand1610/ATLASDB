CREATE PROCEDURE [dbo].[Provider_Add] 
(  
	@DomainId							nvarchar(50),
	@s_a_Provider_Name					NVARCHAR(200),  
	@s_a_Provider_SuitName				NVARCHAR(200),  
	@s_a_Provider_President				VARCHAR(100),  
	@s_a_Provider_taxID					VARCHAR(100),  
	@s_a_Provider_Type					VARCHAR(40),  
	@s_a_Funding_Company				VARCHAR(100),
	@f_a_Provider_Billing				FLOAT,
	@f_a_Provider_IntBilling			FLOAT, 
	@f_a_Provider_Initial_Billing		FLOAT,
	@f_a_Provider_Initial_IntBilling	FLOAT,
	@s_a_Provider_FF					VARCHAR(10),  
	@s_a_Provider_ReturnFF				VARCHAR(10),	
	@s_a_Provider_Rebuttal				VARCHAR(10), 
	@s_a_Packet_Type					VARCHAR(10), 
	@s_a_Settlement_Principal			FLOAT,
	@s_a_Settlement_Interest			FLOAT,
	@s_a_Provider_Notes					VARCHAR(4000),  
	@s_a_Provider_GroupName				NVARCHAR(50) = null,
	@s_a_LawFirm_Attorney				NVARCHAR(50),
	@s_a_Contact2						VARCHAR(100),
	@s_a_Contact3						VARCHAR(100),
	@m_a_Cost_balance					MONEY,  
	@s_a_Invoice_Type					VARCHAR(100), 
	@s_a_Refered_By						NVARCHAR(100),  	
	@s_a_Provider_Local_Address			VARCHAR( 255),  
	@s_a_Provider_Local_City			VARCHAR(100),  
	@s_a_Provider_Local_State			VARCHAR(100),  
	@s_a_Provider_Local_Zip				VARCHAR(50),  
	@s_a_Provider_Local_Phone			VARCHAR(100),  
	@s_a_Provider_Local_Fax				VARCHAR(100),  
	@s_a_Provider_Contact				VARCHAR(100),  
	@s_a_Provider_Perm_Address			VARCHAR(255),  
	@s_a_Provider_Perm_City				VARCHAR(100),  
	@s_a_Provider_Perm_State			VARCHAR(100),  
	@s_a_Provider_Perm_Zip				VARCHAR(50),  
	@s_a_Provider_Perm_Phone			VARCHAR(100),  
	@s_a_Provider_Perm_Fax				VARCHAR(100),  
	@s_a_Provider_Email					VARCHAR(100), 
	@b_a_filereturn						BIT = null,	
	@b_a_is_FROM_nassau					BIT = null,	
	@s_a_Email_For_Arb_Awards			NVARCHAR(200),
	@s_a_Email_For_Invoices				NVARCHAR(200),
	@s_a_Email_For_Closing_Reports		NVARCHAR(200),
	@s_a_Email_For_Monthly_Report		NVARCHAR(200),	
	@s_a_Vendor_Service                 BIT,
	@s_a_Vendor_Service_Type            VARCHAR(50) = NULL,
	@s_a_Vendor_Fee                     FLOAT = NULL,
	@s_a_Vendor_Name                    VARCHAR(200) = NULL,
	@s_a_OperationResult    INT OUTPUT ,  
	@AmountType varchar(50) = NULL,        
    @ProviderSlabs ProviderSlabs readonly  
)  
AS  
BEGIN
	IF EXISTS(SELECT Provider_Name FROM tblProvider  WHERE Provider_Name = @s_a_Provider_Name AND @DomainId = DomainId)   
	BEGIN  
		SET @s_a_OperationResult = 1  
		Return 1  
	END  
	ELSE  
	BEGIN  
		DECLARE @i_l_MaxProvider_Id_IDENTITY INTEGER  
		-- Insert the records  
		BEGIN TRAN  
		
			INSERT INTO tblProvider    
			(  
				Provider_Name,  
				Provider_Suitname,
				Provider_Type,  
				Funding_Company,
				Provider_Billing, 
				Provider_Initial_Billing,
				Provider_Initial_IntBilling, 
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
				Provider_Contact3,    
				Provider_IntBilling,  
				Invoice_Type,  
				cost_balance,  
				Provider_Notes,  
				Provider_ReferredBy,  
				Provider_President,  
				Provider_TaxID,  
				Provider_FF,  
				Provider_ReturnFF,
				Provider_Rebuttal,
				Packet_Type,
				Settlement_Interest,
				Settlement_Principal,						
				Provider_GroupName,
				LawFirm_Attorney ,
				isFROMNassau,
				FileReturn,
				Email_For_Arb_Awards,
				Email_For_Invoices,
				Email_For_Closing_Reports,
				Email_For_Monthly_Report,DomainId,
				Vendor_Service,
				Vendor_Fee_Type,
				Vendor_Fee,
				Vendor_Name
			)  

			VALUES
			(  
				@s_a_Provider_Name, 
				@s_a_Provider_SuitName, 
				@s_a_Provider_Type, 				
				@s_a_Funding_Company, 
				@f_a_Provider_Billing,	
				@f_a_Provider_Initial_Billing ,
				@f_a_Provider_Initial_IntBilling ,
				@s_a_Provider_Local_Address,  
				@s_a_Provider_Local_City, 				 
				@s_a_Provider_Local_State,  
				@s_a_Provider_Local_Zip,  
				@s_a_Provider_Local_Phone,  
				@s_a_Provider_Local_Fax,  
				@s_a_Provider_Contact,  
				@s_a_Provider_Perm_Address, 				 
				@s_a_Provider_Perm_City,  
				@s_a_Provider_Perm_State,  
				@s_a_Provider_Perm_Zip,  
				@s_a_Provider_Perm_Phone,  
				@s_a_Provider_Perm_Fax,  
				@s_a_Provider_Email,  
				@s_a_Contact2 , 
				@s_a_Contact3, 
				@f_a_Provider_IntBilling,  
				@s_a_Invoice_Type,  
				@m_a_Cost_balance,  
				@s_a_Provider_Notes,  
				@s_a_Refered_By,  
				@s_a_Provider_President,  
				@s_a_Provider_TaxID,  
				@s_a_Provider_FF,  
				@s_a_Provider_ReturnFF,
				@s_a_Provider_Rebuttal,
				@s_a_Packet_Type,
				@s_a_Settlement_Interest,	
				@s_a_Settlement_Principal,
				@s_a_Provider_GroupName,
				@s_a_LawFirm_Attorney,
				@b_a_is_FROM_nassau,
				@b_a_filereturn,
				@s_a_Email_For_Arb_Awards,
				@s_a_Email_For_Invoices,
				@s_a_Email_For_Closing_Reports,
				@s_a_Email_For_Monthly_Report,@DomainId,
				@s_a_Vendor_Service,
				@s_a_Vendor_Service_Type,
				@s_a_Vendor_Fee,
				@s_a_Vendor_Name
			)       


		COMMIT TRAN  

		SELECT @i_l_MaxProvider_Id_IDENTITY = MAX(Provider_Id) FROM tblProvider WHERE DomainId=@DomainId   
	    SELECT @i_l_MaxProvider_Id_IDENTITY 



  
	   IF EXISTS( SELECT top 1 SlabFrom FROM @ProviderSlabs)  
	   BEGIN  
	   INSERT INTO tblProvider_Slabs(ProviderId,SlabFrom,SlabTo,VendorFee,AmountType)  
	   SELECT @i_l_MaxProvider_Id_IDENTITY,SlabFrom,SlabTo,VendorFee,@AmountType FROM @ProviderSlabs  
	   END  

		/* TRIGGER to insert provider name in tblDesk*/  
		-------------------------------------------------------------------------------------------------
		--DECLARE	@i_l_cnt INT,  
		--		@s_l_pname VARCHAR(100)  
				
		--SELECT @s_l_pname = provider_name FROM tblprovider WHERE provider_Id = @i_l_MaxProvider_Id_IDENTITY  
		
		--SELECT @i_l_cnt = count(*) FROM tbldesk WHERE desk_name = @s_l_pname  
		
		--if @i_l_cnt =0  
		--begin  
		--	insert INTo tbldesk values (@s_l_pname)  
		--end  
		-------------------------------------------------------------------------------------------------
		
		SET @s_a_OperationResult = 0  
		
		RETURN 0  

	END -- END of ELSE   

END

