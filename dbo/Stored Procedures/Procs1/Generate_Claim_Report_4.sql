
CREATE PROCEDURE [dbo].[Generate_Claim_Report_4]  -- Generate_Claim_Report_4 'af', 1,50,1,50 -- Generate_Claim_Report_4 'af', 0,0,0,50
	-- Add the parameters for the stored procedure here
	@DomainID      VARCHAR(50),
	@startIndex int =0,
	@EndIndex int=0,
	@pageIndex int =1,
	@pageSize int = 50
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @caseData Table
			(
			[Case_Id] varchar(50) index IDX_CLUST Clustered,
		    [Accident_Date] datetime NULL,
			[Case_AutoId] int,
			[Case_Code] varchar(100) NULL,
			[Claim_Amount] float NULL,
			[Date_BillSent] varchar(50),
			[Date_Opened] datetime NULL,
			[Date_Status_Changed] datetime NULL,
			[DenialReasons_Type] varchar(2000) NULL,
			[DomainId] varchar(50) NULL,
			[Fee_Schedule] float NULL,
			[Initial_Status] varchar(50) NULL,
			[InjuredParty_FirstName] varchar(100) NULL,
			[InjuredParty_LastName] varchar(100) NULL,
			[Ins_Claim_Number] nvarchar(100) NULL,
			[InsuranceCompany_Id] int NULL,
			[InsuredParty_FirstName] varchar(100) NULL,
			[InsuredParty_LastName] varchar(100) NULL,
			[Paid_Amount] float NULL,
			[Policy_Number] varchar(40) NULL,
			[PortfolioId] int NULL,
			[Provider_Id] int NULL,
			[Status] varchar(50) NULL,
			[WriteOff] float NULL,
			[IsDeleted] bit NULL,
			[InsuranceCompany_Name] varchar(250) NULL,
			[AttorneyFirmId] int null,
			[FK_Packet_ID] int null,
			[Attorney_Id] int null,
			[Adjuster_Id] int null,
			[Assigned_Attorney] int null,
			[Defendant_Id] int null,
			[Court_Id] int null,
			[Indexoraaa_number] varchar(100) null,
			[DateOfService_Start] datetime null,
			[DateOfService_End] datetime null,
			[StatusDisposition] varchar(200) null,
			[Rebuttal_Status] varchar(200) null,
			[Opened_By] varchar(200),
			[Date_AAA_Arb_Filed] datetime


			)

			INSERT INTO @caseData
			(   
			    Accident_Date,
				Case_AutoId,
				Case_Code,
				Case_Id,
				Claim_Amount,
				Date_BillSent,
				Date_Opened,
				Date_Status_Changed,
				DenialReasons_Type,
				DomainId,
				Fee_Schedule,
				Initial_Status,
				InjuredParty_FirstName,
				InjuredParty_LastName,
				Ins_Claim_Number,
				InsuranceCompany_Id,
				InsuredParty_FirstName,
				InsuredParty_LastName,
				Paid_Amount,
				Policy_Number,
				PortfolioId,
				Provider_Id,
				Status,
				WriteOff,
				IsDeleted,
				InsuranceCompany_Name,
				AttorneyFirmId,
				FK_Packet_ID,
				Attorney_Id,
				Adjuster_Id,
				Assigned_Attorney,
				Defendant_Id,
				Court_Id,
				Indexoraaa_number,
				DateOfService_Start,
				DateOfService_End,
				StatusDisposition,
				Rebuttal_Status,
				Opened_By,
				Date_AAA_Arb_Filed
			)

			SELECT 
				Accident_Date,
				Case_AutoId,
				Case_Code,
				Case_Id,
				Claim_Amount,
				Date_BillSent,
				Date_Opened,
				date_status_Changed,
				DenialReasons_Type,
				cas.DomainId,
				Fee_Schedule,
				Initial_Status,
				InjuredParty_FirstName,
				InjuredParty_LastName,
				Ins_Claim_Number,
				ins.InsuranceCompany_Id,
				InsuredParty_FirstName,
				InsuredParty_LastName,
				Paid_Amount,
				Policy_Number,
				PortfolioId,
				cas.Provider_Id,
				Status,
				WriteOff,
				IsDeleted,
				ins.InsuranceCompany_Name,
				AttorneyFirmId,
				FK_Packet_ID,
				Attorney_Id,
				Adjuster_Id,
				Assigned_Attorney,
				Defendant_Id,
				Court_Id,
				Indexoraaa_number,
				DateOfService_Start,
				DateOfService_End,
				StatusDisposition,
				Rebuttal_Status,
				Opened_By,
				Date_AAA_Arb_Filed
			from tblcase cas with(nolock) 
			INNER JOIN dbo.tblprovider pro(NOLOCK) ON cas.provider_id = pro.provider_id
			INNER JOIN dbo.tblinsurancecompany ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			WHERE    
			cas.DomainId = @DomainID   and  ISNULL(cas.IsDeleted, 0) = 0
			and cas.Status<>'IN ARB OR LIT' and pro.Provider_Name  not in ('ACP','Testing')

			DECLARE @TransactionsData TABLE
	(
	 [Case_Id] varchar(50) ,
	 [Transactions_Id] [int]   INDEX IDX_TRANS clustered,
	 [Transactions_Type] [varchar](20) NOT NULL,
	 [Transactions_Amount] [money] NOT NULL,
	 [Transactions_Description] [varchar](255) NULL,
	 [Transactions_status] [varchar](50) NULL,
	 [Transactions_Date] [smalldatetime] NOT NULL,
	 [ChequeNo] varchar(100) NULL,
	 [CheckDate] datetime NULL
	
	)
	
	INSERT INTO @TransactionsData(Case_Id, Transactions_Id, Transactions_Type, Transactions_Amount, Transactions_Description,
	Transactions_status, Transactions_Date, ChequeNo, CheckDate)
	SELECT tr.Case_id, Transactions_Id, Transactions_Type, Transactions_Amount, Transactions_Description,Transactions_status, Transactions_Date,
	ChequeNo, CheckDate FROM tbltransactions tr with(nolock) 
	INNER JOIN @caseData cas ON  tr.case_id = cas.Case_Id


			DECLARE @Settlements TABLE
								(   
								    [Case_Id] nvarchar(100),
									[DomainId] varchar(40),
									[Settlement_Af] money NULL,
									[Settlement_Amount] money NULL,
									[Settlement_Ff] money NULL,
									[Settlement_Int] money NULL,
									[Settlement_Total] money NULL,
									[Settlement_Date] datetime NULL,
									[Settled_Type] varchar(300) NULL
									
								)

								INSERT INTO @Settlements(Case_Id,
											DomainId,
											Settled_Type,
											Settlement_Af,
											Settlement_Amount,
											Settlement_Ff,
											Settlement_Int,
											Settlement_Total,
											Settlement_Date
											
											) 
											SELECT Case_Id,
											DomainId,
											Settled_Type,
											SUM(ISNULL(Settlement_Af,0.00)),
											SUM(ISNULL(Settlement_Amount,0.00)),
											SUM(ISNULL(Settlement_Ff,0.00)),
											SUM(ISNULL(Settlement_Int,0.00)),
											SUM(ISNULL(Settlement_Total,0.00)),
										    max(DISTINCT Settlement_Date)
											FROM tblSettlements WITH(NOLOCK)
											GROUP BY Case_Id,DomainId, Settled_Type
					
					    DECLARE @treatmentTbl Table
			(
			[Case_Id] varchar(50) index IDX_CLUSTtbl Clustered,
			[Date_BillSent] datetime NULL,
			[DateOfService_End] datetime NULL,
			[DateOfService_Start] datetime NULL,
			[DeductibleAmount] numeric(9,2),
			[bill_number] varchar(200) null
			)

			INSERT INTO @treatmentTbl
			(
			    Case_Id,
				Date_BillSent,
				DateOfService_End,
				DateOfService_Start,
				DeductibleAmount,
				bill_number
				)
			    SELECT  tr.Case_Id,
				CONVERT(varchar(10), tr.DateOfService_Start, 101) AS DateOfService_Start, 
				CONVERT(varchar(12), tr.DateOfService_End, 1) AS DateOfService_End,
				CONVERT(varchar(10), tr.Date_BillSent, 101) AS Date_BillSent,
				DeductibleAmount , bill_number
				from  Tbltreatment tr with(nolock) 
				INNER JOIN  @caseData cas ON tr.case_id=cas.case_id 
				where tr.domainid=@domainid  



	IF @startIndex >0  and @EndIndex >0 
	BEGIN
	;with cte as (
    -- Insert statements for procedure here
	SELECT 
	TotalRowCount =count(1) over(),
	dense_rank() Over(order by cas.case_id) as rownumber  ,
    cas.Case_Id AS [File No.]  ,   
    Concat(cas.InjuredParty_LastName, ', ' , cas.InjuredParty_FirstName)
    as Patient,      

	ISNULL( pro.Provider_Groupname ,'') as ProviderGroup,
	ins.InsuranceCompany_Name AS [Insurance Carrier],      
    ISNULL(cas.IndexOrAAA_Number,'') AS [AAA Index No],      
    convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Claim_Amount,0.00))))) as [Billed Amount],    
    convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Paid_Amount,0.00))))) as Paid,    
 
     convert(decimal(38,2),(convert(money,convert(float,ISNULl(cas.Claim_Amount,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) 
     - ISNULL(cas.WriteOff,0)))) as [Claim Balance Billed],    
     convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00))))) as [Fee Schedule],    
     convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) 
     - ISNULL(cas.WriteOff,0)))) as [Fee Schedule Balance],     
     cas.Status AS [Current Status],   
     ISNULL(cas.StatusDisposition,'') AS [Status Disposition],    
 
    
 [Hearing/Trial Date]   =(select isnull(convert(varchar(20),max(Event_Date),101),'') 
							from  tblevent t
							join tblEventStatus t2 on t.EventStatusId=t2.EventStatusId
							where t.case_id = cas.Case_Id
							 
							and t.DomainId=cas.domainId ),

  convert(decimal(38,2), ISNULL(Settlement_Amount,0.00)) as  [PRINCIPAL Collected],  
       
  convert(decimal(38,2), ISNULL(Settlement_Int,0.00) )  
    as [INTEREST Collected],        
  convert(decimal(38,2), ISNULL(Settlement_AF,0.00) )   as  [ATTORNEY FEE Collected],  
  convert(decimal(38,2),  ISNULL(Settlement_FF,0.00) )   as [FILING FEE Collected],
  (
					SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) 
					case when convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) end
					FROM @TransactionsData tblTransactions
					WHERE tblTransactions.case_id = cas.Case_Id
						 
						AND Transactions_Type IN (
							'C'
							,'I'
							)
					) [Arb Payment Date]

					,
  -- Settlement_Date=CONVERT(varchar,max(DISTINCT Settlement_Date),101),
  [Settlement Date]=case when CONVERT(varchar,ISNULL(Settlement_Date,''),101) ='01/01/1900' then '' 
  else CONVERT(varchar, Settlement_Date,101) end,
   ISNULL(tblSettlement_Type.Settlement_Type,'') AS [Settlement Type],
    [Voluntary Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))),0.00) 
	from @TransactionsData tblTransactions  
	where tblTransactions.case_id=cas.Case_Id  and Transactions_Type in ('PreC','PreCToP')),    
  
  (
					SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101)
					case when convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) end
					FROM @TransactionsData tblTransactions 
					WHERE tblTransactions.case_id = cas.Case_Id
					 
						AND Transactions_Type IN (
							'PreC'
							,'PreCToP'
							)
					) [Voluntary Payment Date],

   [Collection Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))),0.00) 
   from @TransactionsData tblTransactions 
   where tblTransactions.case_id=cas.Case_Id and  Transactions_Type in ('C','I')),    
    --Date_Bill_Sent=convert(varchar, ISNULL(cas.Date_BillSent,''),101)  ,
	[Date Bill Sent]=case when convert(varchar, ISNULL(cas.Date_BillSent,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_BillSent,''),101) end,
    --Date_Opened=convert(varchar, ISNULL(cas.Date_Opened,''),101), 
	[Date Opened]=case when convert(varchar, ISNULL(cas.Date_Opened,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_Opened,''),101) end,
	--CONVERT(VARCHAR(10),Date_AAA_Arb_Filed,101) AS Dat_Arb_LIT_filed, 
	[Date Arb./LIT filed]=case when convert(varchar, ISNULL(cas.Date_AAA_Arb_Filed,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_AAA_Arb_Filed,''),101) end,
	ISNULL(tCrt.Court_Name,'N/A') as [Court Name],
	ISNULL(cas.DenialReasons_Type,'') as[Denial Reason],
	ISNULL(dbo.fncGetServiceType(cas.Case_ID),'') AS [Service Type],
	 cas.Date_Status_Changed AS [Date Status Changed],
  CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as  [Status Age],
  --CONVERT(VARCHAR(10),cas.DateOfService_Start,101) AS [Start DOS],
  case when convert(varchar, ISNULL(cas.DateOfService_Start,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.DateOfService_Start,''),101) end AS [Start DOS],
  --CONVERT(VARCHAR(10),cas.DateOfService_End,101) AS [End DOS],
  case when convert(varchar, ISNULL(cas.DateOfService_End,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.DateOfService_End,''),101) end AS [End DOS],
  -- CONVERT(VARCHAR(10),Accident_Date,101) AS DOA, 
  case when convert(varchar, ISNULL(cas.Accident_Date,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Accident_Date,''),101) end AS DOA, 
    ISNULL(cas.Ins_Claim_Number,'') AS [Claim #],
	 ISNULL(Policy_Number,'') AS [Policy #], 
   [Bill #]=(select top 1 ISNULL(bill_number,'') from @treatmentTbl tblTreatment   where ISNULL(bill_number,'') <> '' and case_id = cas.case_id ),


				ISNULL(
					(SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(ISNULL(transactions_amount,0.00))))))
					FROM @TransactionsData tblTransactions 
					WHERE tblTransactions.case_id = cas.Case_Id
						 
						AND Transactions_Type IN (
							'C'
							,'I'
							,'PreC'
							,'PreCToP'
							)),0.00
					) [Payment Received]

					
				

				
  ,ISNULL(PF.Name,'N/A') as PortFolio
 
  FROM    
  @caseData cas   

  	        LEFT JOIN tblprovider AS pro (NOLOCK) ON cas.provider_id = pro.provider_id
			LEFT JOIN tblinsurancecompany AS ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			LEFT JOIN tbl_portfolio PF(NOLOCK) ON cas.PortfolioId = PF.id
			LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON cas.AttorneyFirmId = AF.id
			LEFT JOIN dbo.tblStatus sta(NOLOCK) ON cas.STATUS = sta.Status_Type AND cas.DomainId = sta.DomainId
			LEFT JOIN tblPacket p(NOLOCK) ON cas.FK_Packet_ID = p.Packet_Auto_ID
			LEFT JOIN tblAttorney att(NOLOCK) ON cas.Attorney_Id = att.Attorney_Id
			LEFT JOIN tblAdjusters adj(NOLOCK) ON cas.Adjuster_Id = adj.Adjuster_Id
			LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON cas.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		    LEFT OUTER JOIN @Settlements sett    ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id    
            LEFT JOIN tblSettlement_Type on sett.Settled_Type = tblSettlement_Type.SettlementType_Id  
			LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id  
			LEFT JOIN tblCourt tCrt(NOLOCK) ON cas.Court_Id = tCrt.Court_Id 
			
  WHERE    
  cas.DomainId = @DomainID   and  ISNULL(cas.IsDeleted, 0) = 0
  and cas.Status<>'IN ARB OR LIT' and pro.Provider_Name  not in ('ACP','Testing')
  

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
	pF.Name,
	tCrt.Court_Name,
	sett.Settlement_Amount,
	sett.Settlement_Int,
	sett.Settlement_Af,
	sett.Settlement_Ff,
	Sett.Settlement_Date
    )

  --select * from cte where [Current_Status]<>'IN ARB OR LIT' and PortFolio='RDL-FV4'
  --union
  --select * from cte where   (PortFolio<>'RDL-FV4'  or PortFolio iS NULL or PortFolio='0') 
  , ct2 as 
  (
  select * from cte where [Current Status]<>'IN ARB OR LIT' and PortFolio='RDL-FV4'
  union
  select * from cte where   (PortFolio<>'RDL-FV4'  or PortFolio iS NULL or PortFolio='0')  and [Current Status]<>'IN ARB OR LIT'
  )
 
  select top(@pageSize) * from ct2 where  (rownumber >= @startIndex and rownumber<= @EndIndex)
  ORDER BY     
  ProviderGroup 
  END
  ELSE
  BEGIN

  ;with cte as (
   
	SELECT 
	 
	TotalRowCount =count(1) over(),
	
	dense_rank() Over(order by cas.case_id) as rownumber 
     ,
  cas.Case_Id AS [File No.]  ,   
    Concat(cas.InjuredParty_LastName, ', ' , cas.InjuredParty_FirstName)
    as Patient,      

	ISNULL( pro.Provider_Groupname ,'') as ProviderGroup,
	ins.InsuranceCompany_Name AS [Insurance Carrier],      
    ISNULL(cas.IndexOrAAA_Number,'') AS [AAA Index No],      
    convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Claim_Amount,0.00))))) as [Billed Amount],    
    convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Paid_Amount,0.00))))) as Paid,    
 
     convert(decimal(38,2),(convert(money,convert(float,ISNULl(cas.Claim_Amount,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) 
     - ISNULL(cas.WriteOff,0)))) as [Claim Balance Billed],    
     convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00))))) as [Fee Schedule],    
     convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) 
     - ISNULL(cas.WriteOff,0)))) as [Fee Schedule Balance],     
     cas.Status AS [Current Status],   
     ISNULL(cas.StatusDisposition,'') AS [Status Disposition],    
 
    
 [Hearing/Trial Date]   =(select isnull(convert(varchar(20),max(Event_Date),101),'') 
							from  tblevent t
							join tblEventStatus t2 on t.EventStatusId=t2.EventStatusId
							where t.case_id = cas.Case_Id
							 
							and t.DomainId=cas.domainId ),

  convert(decimal(38,2), ISNULL(Settlement_Amount,0.00)) as  [PRINCIPAL Collected],  
       
  convert(decimal(38,2), ISNULL(Settlement_Int,0.00) )  
    as [INTEREST Collected],        
  convert(decimal(38,2), ISNULL(Settlement_AF,0.00) )   as  [ATTORNEY FEE Collected],  
  convert(decimal(38,2),  ISNULL(Settlement_FF,0.00) )   as [FILING FEE Collected],
  (
					SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) 
					case when convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) end
					FROM @TransactionsData tblTransactions
					WHERE tblTransactions.case_id = cas.Case_Id
						 
						AND Transactions_Type IN (
							'C'
							,'I'
							)
					) [Arb Payment Date]

					,
  -- Settlement_Date=CONVERT(varchar,max(DISTINCT Settlement_Date),101),
  [Settlement Date]=case when CONVERT(varchar,ISNULL(Settlement_Date,''),101) ='01/01/1900' then '' 
  else CONVERT(varchar, Settlement_Date,101) end,
   ISNULL(tblSettlement_Type.Settlement_Type,'') AS [Settlement Type],
    [Voluntary Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))),0.00) 
	from @TransactionsData tblTransactions  
	where tblTransactions.case_id=cas.Case_Id  and Transactions_Type in ('PreC','PreCToP')),    
  
  (
					SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101)
					case when convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) end
					FROM @TransactionsData tblTransactions 
					WHERE tblTransactions.case_id = cas.Case_Id
					 
						AND Transactions_Type IN (
							'PreC'
							,'PreCToP'
							)
					) [Voluntary Payment Date],

   [Collection Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))),0.00) 
   from @TransactionsData tblTransactions 
   where tblTransactions.case_id=cas.Case_Id and  Transactions_Type in ('C','I')),    
    --Date_Bill_Sent=convert(varchar, ISNULL(cas.Date_BillSent,''),101)  ,
	[Date Bill Sent]=case when convert(varchar, ISNULL(cas.Date_BillSent,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_BillSent,''),101) end,
    --Date_Opened=convert(varchar, ISNULL(cas.Date_Opened,''),101), 
	[Date Opened]=case when convert(varchar, ISNULL(cas.Date_Opened,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_Opened,''),101) end,
	--CONVERT(VARCHAR(10),Date_AAA_Arb_Filed,101) AS Dat_Arb_LIT_filed, 
	[Date Arb./LIT filed]=case when convert(varchar, ISNULL(cas.Date_AAA_Arb_Filed,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Date_AAA_Arb_Filed,''),101) end,
	ISNULL(tCrt.Court_Name,'N/A') as [Court Name],
	ISNULL(cas.DenialReasons_Type,'') as[Denial Reason],
	ISNULL(dbo.fncGetServiceType(cas.Case_ID),'') AS [Service Type],
	 cas.Date_Status_Changed AS [Date Status Changed],
  CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as  [Status Age],
  --CONVERT(VARCHAR(10),cas.DateOfService_Start,101) AS [Start DOS],
  case when convert(varchar, ISNULL(cas.DateOfService_Start,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.DateOfService_Start,''),101) end AS [Start DOS],
  --CONVERT(VARCHAR(10),cas.DateOfService_End,101) AS [End DOS],
  case when convert(varchar, ISNULL(cas.DateOfService_End,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.DateOfService_End,''),101) end AS [End DOS],
  -- CONVERT(VARCHAR(10),Accident_Date,101) AS DOA, 
  case when convert(varchar, ISNULL(cas.Accident_Date,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Accident_Date,''),101) end AS DOA, 
    ISNULL(cas.Ins_Claim_Number,'') AS [Claim #],
	 ISNULL(Policy_Number,'') AS [Policy #], 
   [Bill #]=(select top 1 ISNULL(bill_number,'') from @treatmentTbl tblTreatment   where ISNULL(bill_number,'') <> '' and case_id = cas.case_id ),


				ISNULL(
					(SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(ISNULL(transactions_amount,0.00))))))
					FROM @TransactionsData tblTransactions 
					WHERE tblTransactions.case_id = cas.Case_Id
						 
						AND Transactions_Type IN (
							'C'
							,'I'
							,'PreC'
							,'PreCToP'
							)),0.00
					) [Payment Received]

					
				

				
  ,ISNULL(PF.Name,'N/A') as PortFolio
  FROM    
  @caseData cas   


  	        LEFT JOIN tblprovider AS pro (NOLOCK) ON cas.provider_id = pro.provider_id
			LEFT JOIN tblinsurancecompany AS ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			LEFT JOIN tbl_portfolio PF(NOLOCK) ON cas.PortfolioId = PF.id
			LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON cas.AttorneyFirmId = AF.id
			LEFT JOIN dbo.tblStatus sta(NOLOCK) ON cas.STATUS = sta.Status_Type AND cas.DomainId = sta.DomainId
			LEFT JOIN tblPacket p(NOLOCK) ON cas.FK_Packet_ID = p.Packet_Auto_ID
			LEFT JOIN tblAttorney att(NOLOCK) ON cas.Attorney_Id = att.Attorney_Id
			LEFT JOIN tblAdjusters adj(NOLOCK) ON cas.Adjuster_Id = adj.Adjuster_Id
			LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON cas.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		    LEFT OUTER JOIN @Settlements sett    ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id    
            LEFT JOIN tblSettlement_Type on sett.Settled_Type = tblSettlement_Type.SettlementType_Id  
			LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id  
			LEFT JOIN tblCourt tCrt(NOLOCK) ON cas.Court_Id = tCrt.Court_Id 
			
  WHERE    
  cas.DomainId = @DomainID   and  ISNULL(cas.IsDeleted, 0) = 0
  and cas.Status<>'IN ARB OR LIT' and pro.Provider_Name  not in ('ACP','Testing') 
  

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
	pF.Name,
	tCrt.Court_Name,
	sett.Settlement_Amount,
	sett.Settlement_Int,
	sett.Settlement_Af,
	sett.Settlement_Ff,
	Sett.Settlement_Date
    )

  --select * from cte where [Current_Status]<>'IN ARB OR LIT' and PortFolio='RDL-FV4'
  --union
  --select * from cte where   (PortFolio<>'RDL-FV4'  or PortFolio iS NULL or PortFolio='0') 
  , ct2 as 
  (
  select * from cte where [Current Status]<>'IN ARB OR LIT' and PortFolio='RDL-FV4'
  union
  select * from cte where   (PortFolio<>'RDL-FV4'  or PortFolio iS NULL or PortFolio='0')  and [Current Status]<>'IN ARB OR LIT'
  )
 
  select [rownumber] AS [SR NO],
[File No.],
[Patient],
[ProviderGroup],
[Insurance Carrier],
[AAA Index No],
[Billed Amount],
[Paid],
[Claim Balance Billed],
[Fee Schedule],
[Fee Schedule Balance],
[Current Status],
[Status Disposition],
[Hearing/Trial Date],
[PRINCIPAL Collected],
[INTEREST Collected],
[ATTORNEY FEE Collected],
[FILING FEE Collected],
[Arb Payment Date],
[Settlement Date],
[Settlement Type],
[Voluntary Payment],
[Voluntary Payment Date],
[Collection Payment],
[Date Bill Sent],
[Date Opened],
[Date Arb./LIT filed],
[Court Name],
[Denial Reason],
[Service Type],
[Date Status Changed],
[Status Age],
[Start DOS],
[End DOS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio]
 from ct2 
 ORDER BY     
  ProviderGroup 
 SET NOCOUNT OFF;

  END
  END







