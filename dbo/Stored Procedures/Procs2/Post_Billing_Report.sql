-- =============================================
-- Author:		<Priyanka Shende>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[Post_Billing_Report] 'localhost','23','','2017-03-17','2019-03-17','251'

CREATE PROCEDURE [dbo].[Post_Billing_Report] 
	@domainId					nvarchar(50),
	@s_a_ProviderId				int,
	@s_a_ProviderGroup			varchar(100)='',
	@s_a_Treatment_Date_From	datetime=null,
	@s_a_Treatment_Date_To		datetime=null,
	@s_a_DenialReasons_ID		VARCHAR(MAX)=''
	
AS
BEGIN
		
	
	 SELECT distinct
			tre.Treatment_Id, 
			max(tre.Case_Id) AS Case_Id,
			max(tre.BILL_NUMBER) AS BILL_NUMBER,
			CONVERT(VARCHAR(10),max(tre.DateOfService_Start),101) AS DateOfService_Start,
			CONVERT(VARCHAR(10),max(tre.DateOfService_End),101) AS DateOfService_End,
			max(pro.Provider_Name) AS Provider_Name,
			max(cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName) as InjuredParty_Name,
			max(ins.InsuranceCompany_Name) AS InsuranceCompany_Name, 
			max(pro.Provider_Local_Address) AS Provider_Local_Address,
			CONVERT(VARCHAR(10),max(tre.Date_BillSent), 101) AS BillDate_submitted,   
			max(tre.SERVICE_TYPE) AS SERVICE_TYPE,
			convert(decimal(38,2),(convert(money,convert(float,max(cas.Claim_Amount))))) as Claim_Amount,
			convert(decimal(38,2),(convert(money,convert(float,max(cas.Paid_Amount))))) as Paid_Amount,
			convert(decimal(38,2),(convert(money,convert(float,max(cas.Claim_Amount)) - convert(float,max(cas.Paid_Amount))))) as Claim_Balance,
			convert(decimal(38,2),(convert(money,convert(float,max(cas.Fee_Schedule))))) as Fee_Schedule,
			convert(decimal(38,2),(convert(money,convert(float,max(cas.Fee_Schedule)) - convert(float,max(cas.Paid_Amount))))) as FS_Balance,
			max(cas.Initial_Status) AS Initial_Status,
			max(cas.Status) AS Status,
			max(pro.Provider_GroupName) AS Provider_GroupName,
			max(doc.DOCTOR_NAME) AS DOCTOR_NAME
		FROM  dbo.tblCase cas
		INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT OUTER JOIN dbo.tblTreatment tre on tre.Case_Id= cas.Case_Id
		LEFT JOIN tblOperatingDoctor doc on  doc.Doctor_Id =tre.Doctor_Id 
		LEFT OUTER JOIN TXN_tblTreatment t_tre  WITH (NOLOCK) on tre.treatment_id = t_tre.Treatment_Id 

		WHERE
			cas.DomainId =@domainId
			AND (@s_a_Treatment_Date_From='' OR (tre.DateOfService_Start>=CONVERT(datetime,@s_a_Treatment_Date_From)))	
			AND (@s_a_Treatment_Date_To='' OR (tre.DateOfService_End<=CONVERT(datetime,@s_a_Treatment_Date_To)))
			AND (@s_a_ProviderId = '0' OR cas.Provider_Id = @s_a_ProviderId)
			AND (@s_a_ProviderGroup = '' OR pro.Provider_GroupName = @s_a_ProviderGroup)
			AND (@s_a_DenialReasons_ID = '' 
			OR	tre.DenialReason_ID IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenialReasons_ID,','))
			OR	t_tre.DenialReasons_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenialReasons_ID,',')))
			
		group by
		tre.Treatment_Id, 
		cas.DomainId,
		cas.Case_Id
			
END
