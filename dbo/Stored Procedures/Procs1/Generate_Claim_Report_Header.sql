
CREATE PROCEDURE [dbo].[Generate_Claim_Report_Header] 
	-- Add the parameters for the stored procedure here
	@DomainID      VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	;with cte as (
    -- Insert statements for procedure here
	SELECT top 500000    
     
  cas.Case_Id AS [File no.] ,      
  cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as Patient,      
  Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider,      
  ins.InsuranceCompany_Name AS [Insurance Carrier],      
  cas.IndexOrAAA_Number AS [AAA/Index #],      
  convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as [Billed Amt.],    
  convert(decimal(38,2),(convert(money,convert(float,cas.Paid_Amount)))) as Paid,    
  convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount) - ISNULL(cas.WriteOff,0)))) as [Claim Balance Billed],    
  convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as [Fee Schedule],    
  convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount) - ISNULL(cas.WriteOff,0)))) as [Fee Schedule Balance],     
  cas.Status AS [Current Status],   
   ISNULL(cas.StatusDisposition,'') AS [Status Disposition],    
 
    
  [Hearing/Trial Date] =(select isnull(convert(varchar(20),max(Event_Date),101),'') 
							from  tblevent t
							join tblEventStatus t2 on t.EventStatusId=t2.EventStatusId
							where t.case_id = cas.Case_Id
							--and t2.EventStatusName like'%Hearing%' 
							and t.DomainId=cas.domainId ),

  convert(decimal(38,2),(select sum(DISTINCT ISNULL(Settlement_Amount,0.00)) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [PRINCIPAL Collected],    
  --convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total,     
  convert(decimal(38,2),(select sum(DISTINCT ISNULL(Settlement_Int,0.00)) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [INTEREST Collected],    
  convert(decimal(38,2),(select sum(DISTINCT ISNULL(Settlement_AF,0.00)) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [ATTORNEY FEE Collected],    
  convert(decimal(38,2),(select sum(DISTINCT ISNULL(Settlement_FF,0.00)) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [FILING FEE Collected],
  -- Settlement_Date=CONVERT(varchar,max(DISTINCT Settlement_Date),101),
  [Settlement Date]=case when CONVERT(varchar,max(DISTINCT Settlement_Date),101) ='01/01/1900' then '' else CONVERT(varchar,max(DISTINCT Settlement_Date),101) end,
   ISNULL(tblSettlement_Type.Settlement_Type,'') AS [Settlement Type],
    [Voluntary Payment]=(select convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))) from tblTransactions (NOLOCK)  where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')),    
  [Collection Payment]=(select convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))) from tblTransactions (NOLOCK) where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),    
    --Date_Bill_Sent=convert(varchar, ISNULL(cas.Date_BillSent,''),101)  ,
	[Date Bill Sent]=case when convert(varchar, ISNULL(cas.Date_BillSent,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_BillSent,''),101) end,
    --Date_Opened=convert(varchar, ISNULL(cas.Date_Opened,''),101), 
	[Date Opened]=case when convert(varchar, ISNULL(cas.Date_Opened,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_Opened,''),101) end,
	--CONVERT(VARCHAR(10),Date_AAA_Arb_Filed,101) AS Dat_Arb_LIT_filed, 
	[Date Arb./LIT filed]=case when convert(varchar, ISNULL(cas.Date_AAA_Arb_Filed,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_AAA_Arb_Filed,''),101) end,
	ISNULL(cas.DenialReasons_Type,'') as [Denial Reason],
	ISNULL(dbo.fncGetServiceType(cas.Case_ID),'') AS [Service Type],
	 cas.Date_Status_Changed AS [Date Status Changed],
  CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as [Status Age],  
  CONVERT(VARCHAR(10),cas.DateOfService_Start,101) AS [Start DOS],    
  CONVERT(VARCHAR(10),cas.DateOfService_End,101) AS [End DOS],
   CONVERT(VARCHAR(10),Accident_Date,101) AS [DOA], 
    ISNULL(cas.Ins_Claim_Number,'') AS [Claim #],
	 ISNULL(Policy_Number,'') AS [Policy #], 
  [Bill #]=(select top 1 ISNULL(bill_number,'') from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId)
  ,PF.Name as PortFolio
  FROM    
  tblCase cas (NOLOCK)    
  --INNER JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id     
  --INNER JOIN tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id    
  --INNER JOIN dbo.tblStatus sta (NOLOCK) on cas.Status=sta.Status_Type AND cas.DomainId= sta.DomainId    
  --LEFT OUTER JOIN tblTreatment (NOLOCK) tre on tre.Case_Id= cas.Case_Id    
  --LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR (NOLOCK) prdoc on prdoc.TREATMENT_ID = tre.treatment_id    
  --LEFT OUTER JOIN TXN_tblTreatment t_tre (NOLOCK) on t_tre.Treatment_Id = tre.treatment_id    
  --LEFT JOIN tblPacket p (NOLOCK) on cas.FK_Packet_ID = p.Packet_Auto_ID    
  --LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id    
  --LEFT JOIN tblSettlement_Type on sett.Settled_Type = tblSettlement_Type.SettlementType_Id    
  --LEFT JOIN tblAdjusters adj ON adj.Adjuster_Id = cas.Adjuster_Id AND cas.DomainId= adj.DomainId    
  --LEFT JOIN tblTransactions T ON T.Case_Id = cas.Case_Id AND T.DomainId = cas.DomainId    
  --LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ  WITH (NOLOCK) ON p.FK_CaseType_Id = pkt_typ.PK_CaseType_Id     
  ----LEFT OUTER JOIN tblEvent E  WITH (NOLOCK) ON E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id   
  ----LEFT join tblEventStatus ES on E.EventStatusId=ES.EventStatusId
  --LEFT OUTER JOIN tbl_portfolio PF (NOLOCK)on cas.PortfolioId=PF.id      
  --LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id    
  --LEFT JOIN tbl_portFolio  po(NOLOCK) ON cas.PortfolioId=po.Id

  	LEFT JOIN tblprovider AS pro (NOLOCK) ON cas.provider_id = pro.provider_id
			LEFT JOIN tblinsurancecompany AS ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			LEFT JOIN tbl_portfolio PF(NOLOCK) ON cas.PortfolioId = PF.id
			LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON cas.AttorneyFirmId = AF.id
			LEFT JOIN dbo.tblStatus sta(NOLOCK) ON cas.STATUS = sta.Status_Type
				AND cas.DomainId = sta.DomainId
			LEFT JOIN tblPacket p(NOLOCK) ON cas.FK_Packet_ID = p.Packet_Auto_ID
			LEFT JOIN tblAttorney att(NOLOCK) ON cas.Attorney_Id = att.Attorney_Id
			LEFT JOIN tblAdjusters adj(NOLOCK) ON cas.Adjuster_Id = adj.Adjuster_Id
			LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON cas.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		    LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id    
            LEFT JOIN tblSettlement_Type on sett.Settled_Type = tblSettlement_Type.SettlementType_Id  
			LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id   
 WHERE    
  cas.DomainId = @DomainID   and  ISNULL(cas.IsDeleted, 0) = 0

  

  GROUP BY        
   cas.Case_Id,      
   cas.Case_AutoId,      
   cas.InjuredParty_FirstName,      
   cas.InjuredParty_LastName,      
   pro.Provider_Name,      
   ins.InsuranceCompany_Name,      
   cas.Indexoraaa_number,      
   cas.Claim_Amount,      
   cas.Status,      
   pro.Provider_GroupName,      
   cas.Paid_Amount,      
   cas.WriteOff,    
   cas.Ins_Claim_Number,      
   cas.Date_Opened,      
   cas.Date_Status_Changed,    
   cas.Fee_Schedule,    
   cas.Initial_Status,    
   cas.Accident_Date,    
   cas.DateOfService_Start,    
   cas.DateOfService_End,    
   cas.DenialReasons_Type,    
   ins.InsuranceCompany_GroupName,    
   sta.Final_Status,    
   sta.forum,    
   cas.StatusDisposition,    
   p.PacketID,    
   cas.Rebuttal_Status,    
   cas.Policy_Number,    
   cas.DomainId,    
   cas.Provider_Id,    
   cas.Attorney_Id,    
   cas.Case_Code,    
   cas.Assigned_Attorney,    
   cas.Opened_By,    
   --cas.PortfolioId    
    cas.Date_BillSent,     
    PF.Name ,    
    cas.Date_AAA_Arb_Filed,    
    adj.Adjuster_FirstName,    
    adj.Adjuster_LastName,    
    d.Defendant_Name,    
    adj.Adjuster_Email,    
    tblSettlement_Type.Settlement_Type,
	pF.Name
 ORDER BY     
  Provider    )

  select * from cte where [Current Status]<>'IN ARB OR LIT' and PortFolio='RDL-FV4'
  union
  select * from cte where   (PortFolio<>'RDL-FV4'  or PortFolio iS NULL or PortFolio='0') 






END
