CREATE PROCEDURE [dbo].[LCJ_GETCLIENTDETAILS]
(
@DomainId NVARCHAR(50),
@clientid varchar(50)
)
AS

select Provider_Id,
Provider_Code,
Provider_Name,
Provider_Suitname,
Provider_Type,
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
Provider_Billing,
Provider_Contact2,
Provider_IntBilling,
Invoice_Type,
ISNULL(cost_balance,0.00) as cost_balance,
Provider_Notes,
Provider_ReferredBy,
Provider_President,
Provider_TaxID,
Provider_FF,
Provider_ReturnFF,
Provider_SeesFF,
Provider_SeesRFF,
Provider_InvoicedFF,
provider_Rfunds,
Provider_GroupName,
Provider_Collection_Agent,
Provider_attachChecks,
Temp_Tag,
Active,
SZ_SHORT_NAME,
BX_SERV,
BX_SHR_FEE,
BX_PSTG,
SD_CODE,
BX_FEE_SCHEDULE,
isFromNassau,
BitVerification,
FH_ACTIVE,
FileReturn,
Position,
Practice,
Billing_Manager,
Email_For_Arb_Awards,
Email_For_Invoices,
Email_For_Closing_Reports,
Email_For_Monthly_Report,
LawFirm_Attorney,
tblProvider.DomainId,
Funding_Company,
Provider_Initial_Billing,
Provider_Initial_IntBilling,
Provider_Contact3,
Provider_Rebuttal,
Settlement_Principal,
Settlement_Interest,
packet_type,
Vendor_Service,
Vendor_Fee_Type,
Vendor_Fee,
Vendor_Name,
 ISNULL(LawFirmName,'') AS LawFirmName
,ISNULL(Client_Billing_Address,'') AS Client_Billing_Address
,ISNULL(Client_Billing_City,'') AS Client_Billing_City
,ISNULL(Client_Billing_State,'') AS Client_Billing_State
,ISNULL(Client_Billing_Zip ,'') AS Client_Billing_Zip
,ISNULL(Client_Billing_Phone,'') AS Client_Billing_Phone
,ISNULL(Client_Billing_Fax,'') AS Client_Billing_Fax
,ISNULL(client_header,'') AS client_header
 from tblprovider (NOLOCK)
left outer join tbl_Client (NOLOCK) ON tbl_Client.DomainId = tblprovider.DomainId 
where PROVIDER_ID=@clientid and tblprovider.DomainId=@DomainId

