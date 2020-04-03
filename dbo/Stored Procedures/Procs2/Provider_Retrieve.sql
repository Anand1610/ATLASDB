CREATE PROCEDURE [dbo].[Provider_Retrieve]	
	(
		@DomainId nvarchar(50),
		@i_a_Provider_Id INT		
	)

AS
BEGIN

	SELECT  
		ISNULL(Provider_Id,'') AS Provider_Id,
		ISNULL(Provider_Name,'') AS Provider_Name,
		ISNULL(Provider_Suitname,'') AS Provider_Suitname,
		ISNULL(Funding_Company,'') AS Funding_Company,
		ISNULL(Provider_President,'') AS Provider_President,
		ISNULL(Provider_TaxID,'') AS Provider_TaxID,
		ISNULL(Provider_FF,'') AS Provider_FF,
		ISNULL(Provider_RETURNFF,'') AS Provider_RETURNFF,
		ISNULL(Provider_Rebuttal,'') AS Provider_Rebuttal,

		ISNULL(Settlement_Principal,'0.00') AS Settlement_Principal,
		ISNULL(Settlement_Interest,'0.00') AS Settlement_Interest,

		ISNULL(Provider_Type,'') AS Provider_Type,
		CONVERT(FLOAT,ISNULL(Provider_Billing,'0.00')) AS Provider_Billing,
		CONVERT(FLOAT,ISNULL(Provider_Initial_Billing,'0.00')) AS Provider_Initial_Billing,
		ISNULL(Provider_Local_Address,'') AS Provider_Local_Address,
		ISNULL(Provider_Local_City,'') AS Provider_Local_City,
		ISNULL(Provider_Local_State,'') AS Provider_Local_State,
		ISNULL(Provider_Local_Zip,'') AS Provider_Local_Zip,
		ISNULL(Provider_Local_Phone,'') AS Provider_Local_Phone,
		ISNULL(Provider_Local_Fax,'') AS Provider_Local_Fax, 
		ISNULL(Provider_Perm_Address,'') AS Provider_Perm_Address,
		ISNULL(Provider_Perm_City,'') AS Provider_Perm_City,
		ISNULL(Provider_Perm_State,'') AS Provider_Perm_State,
		ISNULL(Provider_Perm_Zip,'') AS Provider_Perm_Zip,
		ISNULL(Provider_Perm_Phone,'') AS Provider_Perm_Phone,
		ISNULL(Provider_Perm_Fax,'') AS Provider_Perm_Fax,   
		ISNULL(Provider_Contact,'') AS Provider_Contact,   
		ISNULL(Provider_Email,'') AS Provider_Email,
		ISNULL(Provider_ReferredBy,'') AS Provider_ReferredBy,
		ISNULL(Provider_Notes,'') AS Provider_Notes,
		ISNULL(Packet_Type,'') AS Packet_Type,
		ISNULL(Provider_Contact2,'') AS Provider_Contact2,
		ISNULL(Provider_Contact3,'') AS Provider_Contact3,
		CONVERT(FLOAT,ISNULL(Provider_INTBilling,'0.00')) AS Provider_INTBilling,
		CONVERT(FLOAT,ISNULL(Provider_Initial_IntBilling,'0.00')) AS Provider_Initial_IntBilling,
		ISNULL(cost_balance,'0.00') AS cost_balance,
		ISNULL(Invoice_Type,'') AS Invoice_Type,
		ISNULL(provider_Rfunds,'') AS provider_Rfunds,
		ISNULL(Provider_GroupName,'') AS Provider_GroupName,
		ISNULL(Provider_Group_ID,'0') AS Provider_Group_ID,
		ISNULL(LawFirm_Attorney ,'') AS LawFirm_Attorney ,		
		ISNULL(Provider_Collection_Agent,'') AS Provider_Collection_Agent,
		ISNULL(Billing_Manager,'') AS Billing_Manager,
		ISNULL(Provider_SeesFF,'')as Provider_SeesFF,
		ISNULL(Provider_SeesRFF,'') AS Provider_SeesRFF,
		ISNULL(Provider_InvoicedFF,'')as Provider_InvoicedFF,
		ISNULL(SZ_SHORT_NAME,'') AS SZ_SHORT_NAME,
		ISNULL(BX_SERV,'') AS BX_SERV,
		ISNULL(BX_SHR_FEE,'') AS BX_SHR_FEE,   
		ISNULL(BX_PSTG,'0.00')as BX_PSTG,
		ISNULL(P.SD_CODE,'') AS SD_CODE,
		ISNULL(BX_FEE_SCHEDULE,'')as BX_FEE_SCHEDULE, 
		ISNULL(isFromNassau,'') AS  isFromNassau,
		ISNULL(BitVerification,'') AS  BitVerification,
		ISNULL(active,'') AS active,
		ISNULL(fileRETURN, NULL) AS fileRETURN,
		ISNULL(Position,'') AS Position,
		ISNULL(Practice,'') AS Practice,
		ISNULL(P.Email_For_Arb_Awards,'') AS Email_For_Arb_Awards,
		ISNULL(P.Email_For_Invoices,'') AS Email_For_Invoices,
		ISNULL(P.Email_For_Closing_Reports,'') AS Email_For_Closing_Reports,
		ISNULL(P.Email_For_Monthly_Report,'') AS Email_For_Monthly_Report,
		ISNULL(Vendor_Service,'') AS Vendor_Service,
		ISNULL(Vendor_Fee_Type,'') AS Vendor_Fee_Type,
		ISNULL(Vendor_Fee,0) AS Vendor_Fee,
		ISNULL(Vendor_Name,'') AS Vendor_Name
	FROM        
		tblProvider P
		LEFT OUTER JOIN TblProvider_Groups PG on P.Provider_GroupName= PG.Provider_Group_Name
	WHERE
		Provider_Id = @i_a_Provider_Id
		and P.DomainId = @DomainId
END

