
CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchCase] -- [LCJ_WorkArea_SearchCase] @domainId ='amt', @PortfolioId = 44
(
	@domainId nvarchar(50),
	@s_a_ProviderNameGroupSel	VARCHAR(MAX)=''	,
	@s_a_InsuranceGroupSel	VARCHAR(MAX)=''	,
	@s_a_CaseTypeGroupSel	VARCHAR(MAX)=''	,
	@s_a_CourtGroupSel	VARCHAR(MAX)=''	,
	@s_a_DefendantGroupSel	VARCHAR(MAX)=''	,
	--@s_a_PreparationStatusGroupSel	VARCHAR(MAX)=''	,
	@s_a_ProviderGroupSel	VARCHAR(MAX)=''	,
	@s_a_InitialStatusGroupSel	VARCHAR(MAX)=''	,
	@s_a_CurrentStatusGroupSel	VARCHAR(MAX)=''	,
	@s_a_DenailReasonGroupSel	VARCHAR(MAX)=''	,
	@s_a_Case_ID	VARCHAR(100)=''	,
	@s_a_OldCaseId	VARCHAR(100)=''	,
	@s_a_PacketID	VARCHAR(100)=''	,
	@s_a_InjuredName	VARCHAR(200)=''	,
	@s_a_InsuredName	VARCHAR(200)=''	,
	@s_a_IndexOrAAANo	VARCHAR(100)=''	,
	--@s_a_StatusDisposition  VARCHAR(100)=''	,
	@s_a_PolicyNo	VARCHAR(100)=''	,
	@s_a_ClaimNo	VARCHAR(100)=''	,
	@s_a_AccountNo	VARCHAR(100)=''	,
	@i_a_SRL	INT=0	,
	@i_a_ReviewingDoctor	INT=0	,
	@s_a_DOSFROM	VARCHAR(20)=''	,
	@s_a_DOSTo	VARCHAR(20)=''	,
	@s_a_date_opened_FROM	VARCHAR(20)=''	,
	@s_a_date_Opened_To	VARCHAR(20)='',
	@s_a_AccidentDate	VARCHAR(20)='',
	@s_a_strBill_No			nvarchar(100)='',
	@s_a_date_Status_Changed_FROM	VARCHAR(20)=''	,
	@s_a_date_Status_Changed_To	VARCHAR(20)='',
	@PortfolioId int =0 ,
	@AdjusterID VARCHAR(MAX)='',
	@Speciality VARCHAR(MAX)='',
	@FinalStatus VARCHAR(MAX)='',
	@Forum VARCHAR(MAX)='',
	@Filed VARCHAR(MAX)=''

  )
AS  
DECLARE @strsql as varchar(8000)  
begin  
		
SELECT distinct
		cas.Case_Id,
		cas.Case_AutoId,
		cas.Case_Code,
		pkt.PacketID AS PacketID,
		pkt_typ.CaseType,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName AS InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') AS Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.Indexoraaa_number,
		cas.StatusDisposition , 
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,  
		convert(decimal(38,2),(convert(money,convert(float,cas.Paid_Amount)))) as Paid_Amount, 
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Balance,  
		convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as FS_Amount,  
		convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)))) as FS_Balance, 
		court.Court_Name,
		cas.Status, 
		Convert(varchar(10),cas.date_status_Changed,101) AS date_status_Changed,
		Cas.Date_Opened, 
		cas.Initial_Status,
		cas.Ins_Claim_Number, 
		cas.Accident_Date, 
		CONVERT(varchar,min(tre.DateOfService_Start),101)+ ' - ' + CONVERT(varchar,max(tre.DateOfService_End),101) AS DateOfService, 
		pro.Provider_GroupName,
		pkt_typ.CaseType,
		CONVERT(INT, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) AS Status_Age,
		isnull((SELECT DISTINCT location_address FROM mst_service_rendered_location WHERE location_id=cas.location_id),'') AS Location_Address,
		(SELECT dbo.[fncGetPeerReviewDoctor](@domainId , cas.case_id)) AS Doctor_Name,
		cas.Old_Status AS Last_Status,
		--cas.Assigned_Attorney AS Assigned_Attorney,
		Assigned_Attorney.Assigned_Attorney AS Assigned_Attorney,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Amount) FROM tblsettlements WHERE Case_Id = cas.case_id)) as Settlement_Amount,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements WHERE Case_Id = cas.case_id)) as Settlement_Total, 
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Int) FROM tblsettlements WHERE Case_Id = cas.case_id)) as Settlement_Int,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_AF) FROM tblsettlements WHERE Case_Id = cas.case_id)) as Settlement_AF,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_FF) FROM tblsettlements WHERE Case_Id = cas.case_id)) as Settlement_FF,
		CONVERT(DECIMAL(38,2),SUM(DISTINCT Settlement_Amount)) AS Settlement_Amount,
		CONVERT(DECIMAL(38,2),SUM(DISTINCT Settlement_AF)) AS Settlement_AF,
		CONVERT(DECIMAL(38,2),SUM(DISTINCT Settlement_FF)) AS Settlement_FF, 
		CONVERT(DECIMAL(38,2),SUM(DISTINCT Settlement_Int)) AS Settlement_Int, 
		CONVERT(DECIMAL(38,2),SUM(DISTINCT Settlement_Total)) AS Settlement_Total, 
		CONVERT(varchar,max(DISTINCT Settlement_Date),101) AS Settlement_Date, 
		max(User_Id )AS Settled_By, 
		(CONVERT(DECIMAL(38,2),SUM(DISTINCT Settlement_Total)) - CONVERT(DECIMAL(38,2),(SELECT SUM(transactions_amount) FROM tblTransactions tt WHERE tt.Case_Id=cas.Case_Id and transactions_type in ('C','I','AF','FFC','PreCToP','FFC-FIRM')))) AS Settlement_Outstanding_Amt,
		cas.Opened_By,
		(SELECT top 1 a.Case_Id FROM  tblCase a WHERE a.DomainId = cas.DomainId and a.Provider_Id =cas.Provider_Id  and a.InjuredParty_LastName =cas.InjuredParty_LastName
		and a.InjuredParty_FirstName = cas.InjuredParty_FirstName and  a.Accident_Date =cas.Accident_Date  and a.Case_Id <> cas.case_id) AS Similar_To_Case_ID,
		CAST(ISNULL(ISNULL(Date_Index_Number_Purchased,Date_AAA_Arb_Filed),Date_NAM_ARB_Filed) AS Date)Date_Filed,
		DateDiff(dd,ISNULL(ISNULL(Date_Index_Number_Purchased,Date_AAA_Arb_Filed),Date_NAM_ARB_Filed),GETDATE())Days_Filed,
	--	(SELECT CaseType FROM MST_PacketCaseType m WHERE m.PK_CaseType_Id=cas.FK_Packet_ID) AS CaseType,
		CONVERT(DECIMAL(38,2),(SELECT SUM(Transactions_Amount) FROM dbo.tblTransactions WHERE Case_id = cas.case_id and transactions_type in ('C','I','AF','FFC','PreCToP','FFC-FIRM') )) AS Transactions_Amount,
		cas.DenialReasons_Type AS DenialReasons
		--,t_tre.DenialReasons_Id
		,(SELECT Defendant_Name FROM tblDefendant def WHERE def.Defendant_id=cas.defendant_Id) AS Defendant_Name
		,dbo.fncGetAccountNumber(cas.case_id) AS account_number 
		,dbo.fncGetBillNumber(cas.case_id) AS bill_number
		
	FROM tblCase cas  WITH (NOLOCK)
	INNER JOIN tblprovider pro  WITH (NOLOCK) on pro.DomainId= cas.Domainid and cas.provider_id=pro.provider_id
	INNER JOIN tblinsurancecompany ins  WITH (NOLOCK) on ins.DomainId= cas.Domainid and cas.insurancecompany_id=ins.insurancecompany_id
	LEFT OUTER JOIN tblCourt Court  WITH (NOLOCK) ON cas.court_id = court.court_id
	LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id 
	LEFT OUTER JOIN tblTreatment tre  WITH (NOLOCK) on tre.DomainId= cas.Domainid and cas.Case_Id = tre.Case_Id 
	LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR prdoc  WITH (NOLOCK) on tre.treatment_id = prdoc.TREATMENT_ID 
	LEFT OUTER JOIN TXN_tblTreatment t_tre  WITH (NOLOCK) on tre.treatment_id = t_tre.Treatment_Id 
	LEFT OUTER JOIN dbo.tblPacket pkt  WITH (NOLOCK) ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
	LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ  WITH (NOLOCK) ON pkt.FK_CaseType_Id = pkt_typ.PK_CaseType_Id
	LEFT OUTER JOIN dbo.Adjusters ADJ WITH (NOLOCK) ON cas.Adjuster_Id=ADJ.Adjuster_Id
	LEFT OUTER JOIN dbo.tblStatus Sts WITH (NOLOCK) ON cas.Status=Sts.Status_Type
	LEFT OUTER JOIN dbo.Assigned_Attorney (NOLOCK) ON cas.Assigned_Attorney = dbo.Assigned_Attorney.PK_Assigned_Attorney_ID
	WHERE
		cas.domainId = @domainId and status <> 'IN ARB OR LIT'
		AND (@s_a_ProviderNameGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
		AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
		AND (@s_a_CaseTypeGroupSel  ='' OR pkt.FK_CaseType_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_CaseTypeGroupSel,',')))
		AND (@s_a_CourtGroupSel = '' OR cas.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_CourtGroupSel,',')))
		AND (@s_a_DefendantGroupSel ='' OR cas.defendant_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_DefendantGroupSel,',')))
		AND (@s_a_ProviderGroupSel ='' OR pro.Provider_GroupName IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_ProviderGroupSel,',')))	
		AND (@s_a_InitialStatusGroupSel ='' OR cas.Initial_Status IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_InitialStatusGroupSel,',')))
		AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_CurrentStatusGroupSel,',')))
		AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%') 
		AND (@s_a_OldCaseId ='' OR cas.old_Case_id like '%'+ @s_a_OldCaseId + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')
	
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
		AND (@s_a_DenailReasonGroupSel = '' 
			OR	tre.DenialReason_ID IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenailReasonGroupSel,','))
			OR	t_tre.DenialReasons_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenailReasonGroupSel,',')))
		
		AND (@i_a_SRL = 0 OR cas.location_id = @i_a_SRL)
		AND (@i_a_ReviewingDoctor = 0 OR prdoc.DOCTOR_ID = @i_a_ReviewingDoctor)
		AND (@s_a_date_opened_FROM='' OR (Date_Opened Between CONVERT(datetime,@s_a_date_opened_FROM) And CONVERT(datetime,@s_a_date_Opened_To)+1))
		AND (@s_a_date_Status_Changed_FROM='' OR (Date_Status_Changed Between CONVERT(datetime,@s_a_date_Status_Changed_FROM) And CONVERT(datetime,@s_a_date_Status_Changed_To)+1))
		

		AND (@s_a_AccidentDate='' OR Convert(VARCHAR,Accident_Date,101) = @s_a_AccidentDate )

		AND (@s_a_strBill_No ='' or cas.Case_Id in (select Case_Id from tbltreatment where BILL_NUMBER  Like '%' + @s_a_strBill_No + '%')) 
		AND (@s_a_DOSFROM ='' or (CONVERT(DATETIME,cas.DateOfService_Start) >=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSFROM,101))  and cas.DateOfService_Start IS NOT NULL))
		AND (@s_a_DOSTo ='' or (CONVERT(DATETIME,cas.DateOfService_End) <=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSTo,101))  and cas.DateOfService_End IS NOT NULL))

		--AND (@i_a_AgeFROM	IS NULL	OR CONVERT(VARCHAR,DATEDIFF(dd,cas.Date_Status_Changed,GETDATE())) >= @i_a_AgeFROM)
		--AND (@i_a_AgeTo	IS NULL OR CONVERT(VARCHAR,DATEDIFF(dd,cas.Date_Status_Changed,GETDATE())) <= @i_a_AgeTo)
		AND (@s_a_AccountNo = '' OR tre.account_number like '%' + @s_a_AccountNo +'%' OR tre.bill_number like '%' + @s_a_AccountNo +'%')
		
		AND (@s_a_PacketID ='' OR pkt.PacketID like '%'+ @s_a_PacketID + '%')
		AND (@PortfolioId=0 OR cas.PortfolioId= @PortfolioId)  
		AND (@AdjusterID  ='' OR cas.Adjuster_Id IN (SELECT items FROM dbo.SplitStringInt(@AdjusterID,',')))
		AND (@Speciality  ='' OR tre.SERVICE_TYPE IN (SELECT items FROM dbo.STRING_SPLIT(@Speciality,',')))
		AND (@FinalStatus  ='' OR Sts.Final_Status IN (SELECT items FROM dbo.STRING_SPLIT(@FinalStatus,',')))
		AND (@Forum  ='' OR Sts.forum IN (SELECT items FROM dbo.STRING_SPLIT(@Forum,',')))
		AND (@Filed  ='' OR Sts.Filed_Unfiled IN (SELECT items FROM dbo.STRING_SPLIT(@Filed,',')))
			--AND (@s_a_StatusDisposition ='' OR cas.StatusDisposition like '%'+ @s_a_StatusDisposition + '%')
	Group by 
		cas.DomainId,
		cas.Case_Id,
		cas.Case_AutoId,
		cas.Case_Code,
		pkt.PacketID,
		pkt_typ.CaseType,
		cas.Fee_Schedule,
		cas.InjuredParty_FirstName,
		cas.InjuredParty_LastName,
		pro.Provider_Name,
		ins.InsuranceCompany_Name,
		cas.Indexoraaa_number,
		cas.StatusDisposition ,
		cas.Claim_Amount,
		cas.Status,
		pro.Provider_GroupName,
		cas.Paid_Amount,
		cas.Ins_Claim_Number,
		Cas.Date_Opened,
		Cas.Date_Status_Changed,
		court.Court_Name,
		cas.Initial_Status,
		cas.Accident_Date,
		cas.location_id,
		cas.Old_Status,
		cas.OPENED_BY,
		cas.Provider_Id,
		Assigned_Attorney.Assigned_Attorney,
		--tblPreparationStatus.Preparation_Status,
		cas.Date_Index_Number_Purchased,
		cas.Date_AAA_Arb_Filed,
		cas.Date_NAM_ARB_Filed,
		cas.DenialReasons_Type,
		--CPL.CLIENTPRIORITY_LEVEL_NAME,
		--sett.Settlement_Amount,
		--sett.Settlement_Ff,
		--sett.Settlement_af,
		--sett.Settlement_Int,
		--sett.Settlement_Total,
		--sett.Settlement_Date,
		--sett.User_Id,	 
		--t_tre.DenialReasons_Id,
		cas.defendant_Id --,
		--tre.account_number,
		--tre.bill_number
	ORDER BY Case_AutoId	desc
End
