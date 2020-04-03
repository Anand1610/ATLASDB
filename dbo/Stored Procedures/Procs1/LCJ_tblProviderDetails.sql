CREATE PROCEDURE [dbo].[LCJ_tblProviderDetails]
	
	(
		@Provider_Id NVARCHAR(100)
		
	)

AS
BEGIN

	SELECT  
    isnull(Provider_Name,'') as Provider_Name,
	isnull(Provider_Suitname,'') as Provider_Suitname,
    isnull(Provider_President,'') as Provider_President,
    isnull(Provider_TaxID,'') as Provider_TaxID,
    isnull(Provider_FF,'') as Provider_FF,
    isnull(Provider_ReturnFF,'') as Provider_ReturnFF,
	isnull(Provider_Type,'') as Provider_Type,
	isnull(Provider_Billing,'0.00') as Provider_Billing,
	isnull(Provider_Local_Address,'') as Provider_Local_Address,
	isnull(Provider_Local_City,'') as Provider_Local_City,
	isnull(Provider_Local_State,'') as Provider_Local_State,
    isnull(Provider_Local_Zip,'') as Provider_Local_Zip,
	isnull(Provider_Local_Phone,'') as Provider_Local_Phone,
    isnull(Provider_Local_Fax,'') as Provider_Local_Fax, 
	isnull(Provider_Perm_Address,'') as Provider_Perm_Address,
    isnull(Provider_Perm_City,'') as Provider_Perm_City,
	isnull(Provider_Perm_State,'') as Provider_Perm_State,
	isnull(Provider_Perm_Zip,'') as Provider_Perm_Zip,
    isnull(Provider_Perm_Phone,'') as Provider_Perm_Phone,
	isnull(Provider_Perm_Fax,'') as Provider_Perm_Fax,   
	isnull(Provider_Contact,'') as Provider_Contact,   
	isnull(Provider_Email,'') as Provider_Email,
	isnull(Provider_ReferredBy,'') as Provider_ReferredBy,

    isnull(Provider_Notes,'') as Provider_Notes,
	isnull(Provider_Contact2,'') as Provider_Contact2,
	isnull(Provider_IntBilling,'') as Provider_IntBilling,
	isnull(cost_balance,'0.00') as cost_balance,
    isnull(Invoice_Type,'') as Invoice_Type,
	isnull(provider_Rfunds,'') as provider_Rfunds,
    isnull(Provider_GroupName,'') as Provider_GroupName,
	isnull(Provider_Collection_Agent,'') as Provider_Collection_Agent,
	isnull(Billing_Manager,'') as Billing_Manager,
    isnull(Provider_SeesFF,'')as Provider_SeesFF,
    isnull(Provider_SeesRFF,'') as Provider_SeesRFF,
    isnull(Provider_InvoicedFF,'')as Provider_InvoicedFF,
	isnull(SZ_SHORT_NAME,'') as SZ_SHORT_NAME,
    isnull(BX_SERV,'') as BX_SERV,
	isnull(BX_SHR_FEE,'') as BX_SHR_FEE,   
    isnull(BX_PSTG,'0.00')as BX_PSTG,
	isnull(SD_CODE,'') as SD_CODE,
    isnull(BX_FEE_SCHEDULE,'')as BX_FEE_SCHEDULE, 
	isnull(isFromNassau,'') as  isFromNassau,
	isnull(BitVerification,'') as  BitVerification,
	isnull(active,'') as active,
	isnull(filereturn, NULL) as filereturn,
	isnull(Position,'') as Position,
	isnull(Practice,'') as Practice

	FROM        tblProvider
	WHERE    Provider_Id = @Provider_Id

END

