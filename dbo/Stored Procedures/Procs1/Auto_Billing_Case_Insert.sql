
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Auto_Billing_Case_Insert] 
	-- Add the parameters for the stored procedure here
	@DomainID nvarchar(50),
	@s_a_MultipleCase_ID VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Auto_Billing_Packet (DomainId,Case_Id)
	SELECT @DomainID, s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')

	INSERT INTO Auto_Billing_Packet_Info
	SELECT distinct
				@DomainID,				
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code AS Case_Code,
				pck.Packeted_Case_ID as Packeted_Case_ID,
				cas.InjuredParty_LastName,
				cas.InjuredParty_FirstName,  
				cas.InsuredParty_LastName,
				cas.InsuredParty_FirstName,
				Provider_Name,  
				ins.InsuranceCompany_Name,  
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
				
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Balance,
				convert(decimal(38,2),cas.Paid_Amount) AS Paid_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as Fee_Schedule,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)))) as FS_Balance,
				cas.Status,  
				cas.Initial_Status,
				cas.Accident_Date,		
				cas.Ins_Claim_Number,
				cas.Policy_Number, 
				pro.Provider_GroupName,
				CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as Status_Age,
				CONVERT(varchar(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start, 
				CONVERT(varchar(12), min(tre.DateOfService_End), 1) AS DateOfService_End,
				CONVERT(varchar(12), min(tre.Date_BillSent), 1) AS Date_BillSent,
				cas.DenialReasons_Type as  DenialReasons,
				--dbo.fncGetDenialReasons(cas.Case_Id) AS DenialReasons,
				dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
				cas.Provider_Id,
				cas.InsuranceCompany_Id,
				cas.Date_Opened,
				cas.Date_Status_Changed,
				pro.packet_type
			FROM dbo.tblCase cas With(Nolock)
				INNER JOIN dbo.tblprovider pro With(Nolock) on cas.provider_id=pro.provider_id 
				INNER JOIN dbo.tblinsurancecompany ins With(Nolock) on cas.insurancecompany_id=ins.insurancecompany_id
				INNER JOIN Auto_Billing_Packet abp With(Nolock) ON  cas.Case_Id = abp.Case_Id and cas.DomainId= abp.DomainId
				LEFT OUTER JOIN dbo.tblTreatment tre With(Nolock) on tre.Case_Id= cas.Case_Id
				LEFT OUTER JOIN dbo.Billing_Packet pck With(Nolock) on cas.case_id = pck.Case_ID
				AND ISNULL(pck.case_id,'') =''
				Where cas.Case_ID IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) AND cas.DomainId=@DomainID
				Group by 	
				cas.DomainId,
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code,
				pck.Packeted_Case_ID,
				cas.InjuredParty_FirstName,
				cas.InjuredParty_LastName,
				cas.InsuredParty_LastName,
				cas.InsuredParty_FirstName,
				pro.Provider_Name,
				ins.InsuranceCompany_Name,
				cas.Claim_Amount,
				cas.Fee_Schedule,
				cas.Status,
				cas.Accident_Date,		
				cas.Initial_Status,
				pro.Provider_GroupName,
				cas.Paid_Amount,
				cas.Ins_Claim_Number,
				cas.Policy_Number,
				Cas.Date_Opened,
				Cas.Date_Status_Changed,
				cas.DenialReasons_Type,
				cas.Provider_Id,
				cas.InsuranceCompany_Id,
				cas.Date_Opened,
				pro.packet_type
END
