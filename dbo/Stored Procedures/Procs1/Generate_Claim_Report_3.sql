
CREATE PROCEDURE [dbo].[Generate_Claim_Report_3]  -- Generate_Claim_Report_3 'AF', 0,0,10,50
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


			

				DECLARE @Settlements TABLE
								(   

								    [Case_Id] nvarchar(100) index id_setl clustered,
									[Settlement_Af] money NULL,
									[Settlement_Amount] money NULL,
									[Settlement_Ff] money NULL,
									[Settlement_Int] money NULL,
									[Settlement_Total] money NULL,
									[Settlement_Date] datetime
									--unique(Case_Id,Settlement_Af,Settlement_Amount, Settlement_Ff, Settlement_Int, Settlement_Total, Settlement_Date)
									
								)

								INSERT INTO @Settlements(Case_Id,
										
											Settlement_Af,
											Settlement_Amount,
											Settlement_Ff,
											Settlement_Int,
											Settlement_Total,
											Settlement_Date
											) 
											SELECT tblSettlements.Case_Id,
											
											SUM(ISNULL(Settlement_Af,0.00)),
											SUM(ISNULL(Settlement_Amount,0.00)),
											SUM(ISNULL(Settlement_Ff,0.00)),
											SUM(ISNULL(Settlement_Int,0.00)),
											SUM(ISNULL(Settlement_Total,0.00)),
											max(Settlement_Date)
											FROM tblSettlements WITH(NOLOCK)
											inner join tblcase cas on tblSettlements.Case_Id =cas.Case_Id
											where tblSettlements.DomainId=@DomainID
											GROUP BY tblSettlements.Case_Id
											



	Declare @VoluntaryPayment table
  (
 
  Transactions_Amount money,
  Transactions_Date smalldatetime,
  PacketID varchar(50) index idx_pid clustered 

  )

  Declare @BillingPacket table
  (
  
  Case_id varchar(50) index idx_cli clustered,
  PacketID varchar(50)
  )

insert into @BillingPacket(Case_id, PacketID)
Select  Case_id, Packeted_Case_ID from Billing_Packet with(nolock) where DomainID=@DomainID

insert into @VoluntaryPayment( Transactions_Amount, Transactions_Date, PacketID)

SELECT  T1.Transactions_Amount,
		  Transactions_Date  , Bpt.PacketID
FROM tblTransactions As T1 with(nolock)
inner JOIN @BillingPacket BPt  on T1.Case_Id = Bpt.Case_ID and T1.DomainId=@domainid
and (T1.Transactions_Type='PreC' or T1.Transactions_Type='PreCToP')

--39464

 Declare @VoluntaryPayment2 table
  (
 
  PacketID varchar(50)  index idx_packet clustered,
  Transactions_Date varchar(1000),
  transactions_amount money,
  unique(PacketID,Transactions_Date, transactions_amount)

  )

INSERT INTO @VoluntaryPayment2(PacketID,transactions_amount, Transactions_Date)
--SELECT    T1.PacketID, sum(transactions_amount),
--		Transactions_Date = STUFF(
--									(SELECT ',' + 	case when convert(varchar, ISNULL( T2.Transactions_Date,''),101) ='01/01/1900' then '' 
--					else convert(varchar, ISNULL(T2.Transactions_Date,''),101) end as Transactions_Date
--										FROM @VoluntaryPayment As T2  
--										WHERE T1.PacketID = T2.PacketID 
--										ORDER BY PacketID 
--										FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
--								, 1, 1, ''
--							)
--FROM @VoluntaryPayment As T1   
--group by T1.PacketID 
SELECT    T1.PacketID, sum(transactions_amount),
		Transactions_Date = STUFF(
									(SELECT ',' + 	case when convert(varchar, ISNULL((T2.Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL((T2.Transactions_Date),''),101) end as Transactions_Date
										FROM @VoluntaryPayment As T2  
										WHERE T1.PacketID = T2.PacketID 
										GROUP BY PacketID, T2.Transactions_Date
										ORDER BY PacketID 
										FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
								, 1, 1, ''
							)
FROM @VoluntaryPayment As T1   
group by T1.PacketID 


Declare @Trans table
  (
 
  Case_ID varchar(50),  --index idx_packet clustered,
  Transactions_Date smalldatetime,
  transactions_amount money,
  Transactions_Type varchar(100)
  )

  insert into @Trans(Case_ID, Transactions_Date, transactions_amount,Transactions_Type)
  select Case_ID, Transactions_Date, transactions_amount,Transactions_Type from tblTransactions with(nolock)
  where domainid=@DomainID and (transactions_type='C' OR transactions_type='I' or transactions_type='PreC' or transactions_type='PreCTOP')

	IF @startIndex >0  and @EndIndex >0 
	BEGIN
	;with cte as (
    -- Insert statements for procedure here
	SELECT 

	TotalRowCount =count(1) over(),
	--cas.case_AutoId,
	dense_rank() Over(order by cas.case_id) as rownumber 
     ,
  cas.Case_Id AS [File No.]  ,      
  cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as Patient,      
  --Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider, 
  ISNULL( pro.Provider_Groupname ,'') as ProviderGroup,
  ISNULL( pro.Provider_Name ,'') as Providername,
  ins.InsuranceCompany_Name AS [Insurance Carrier],      
  ISNULL(cas.IndexOrAAA_Number,'') AS [AAA Index No],      
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Claim_Amount,0.00))))) as [Billed Amount],    
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Paid_Amount,0.00))))) as Paid,    
  convert(decimal(38,2),(convert(money,convert(float,ISNULl(cas.Claim_Amount,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) - ISNULL(cas.WriteOff,0)))) as [Claim Balance Billed],    
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00))))) as [Fee Schedule],    
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) - ISNULL(cas.WriteOff,0)))) as [Fee Schedule Balance],     
  cas.Status AS [Current Status],   
   ISNULL(cas.StatusDisposition,'') AS [Status Disposition],    
 
    
 [Hearing/Trial Date]   =(select isnull(convert(varchar(20),max(Event_Date),101),'') 
							from  tblevent t
							join tblEventStatus t2 on t.EventStatusId=t2.EventStatusId
							where t.case_id = cas.Case_Id
							--and t2.EventStatusName like'%Hearing%' 
							and t.DomainId=cas.domainId ),

  --convert(decimal(38,2),(select ISNULL(sum(DISTINCT ISNULL(Settlement_Amount,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as  [PRINCIPAL Collected], 
  --convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total,     
  --convert(decimal(38,2),(select  ISNULL(sum(DISTINCT ISNULL(Settlement_Int,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [INTEREST Collected],        
  --convert(decimal(38,2),(select  ISNULL(sum(DISTINCT ISNULL(Settlement_AF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as  [ATTORNEY FEE Collected],  
  --convert(decimal(38,2),(select ISNULL(sum(DISTINCT ISNULL(Settlement_FF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [FILING FEE Collected],
  
   convert(decimal(38,2),setmnt.Settlement_Amount) as  [PRINCIPAL Collected], 
   convert(decimal(38,2),setmnt.Settlement_Int) as  [INTEREST Collected], 
   convert(decimal(38,2),setmnt.Settlement_AF) as  [ATTORNEY FEE Collected], 
   convert(decimal(38,2),setmnt.Settlement_FF) as  [FILING FEE Collected], 
  
  (
					SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) 
					case when convert(varchar, ISNULL(MIN( Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN( Transactions_Date),''),101) end
					FROM @Trans tr
					WHERE tr.case_id = cas.Case_Id
						 
						AND (Transactions_Type =
							'C' or Transactions_Type ='I'
							
							)
					) [Arb Payment Date]

					,
  -- Settlement_Date=CONVERT(varchar,max(DISTINCT Settlement_Date),101),
  --[Settlement Date]=case when CONVERT(varchar,max(DISTINCT ISNULL(Settlement_Date,'')),101) ='01/01/1900' then '' else CONVERT(varchar,max(DISTINCT Settlement_Date),101) end,
    setmnt.Settlement_Date as [Settlement Date],
   ISNULL(tblSettlement_Type.Settlement_Type,'') AS [Settlement Type],
 --   [Voluntary Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))),0.00) 
	--from tblTransactions (NOLOCK)  
	--where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP'))
	 
	
	--and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')
	--),    
	 [Voluntary Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))),0.00) 
	  from @Trans trans  where trans.case_id=cas.Case_Id  and (Transactions_Type ='PreC' or Transactions_Type='PreCToP')),
  
      (SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101)
					case when convert(varchar, ISNULL(MIN(Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN( Transactions_Date),''),101) end
					FROM @Trans tr
					WHERE tr.case_id = cas.Case_Id
						 	AND (Transactions_Type =
							'PreC' or 
							Transactions_Type ='PreCToP'
							)
							

					) [Voluntary Payment Date],

   --[Collection Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))),0.00) from tblTransactions (NOLOCK) 
   --where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),  
   
   
   [Collection Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))),0.00) from @trans tr
   where tr.case_id=cas.Case_Id   and (Transactions_Type ='C' or Transactions_Type ='I')),   

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
  case when convert(varchar, ISNULL(cas.DateOfService_End,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.DateOfService_End,''),101) end AS [End DOSs],
  -- CONVERT(VARCHAR(10),Accident_Date,101) AS DOA, 
  case when convert(varchar, ISNULL(cas.Accident_Date,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Accident_Date,''),101) end AS DOA, 
    ISNULL(cas.Ins_Claim_Number,'') AS [Claim #],
	 ISNULL(Policy_Number,'') AS [Policy #], 
   [Bill #]=(select top 1 ISNULL(bill_number,'') from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId),


				--ISNULL(
				--	(SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(ISNULL(transactions_amount,0.00))))))
				--	FROM tblTransactions(NOLOCK)
				--	WHERE tblTransactions.case_id = cas.Case_Id
				--		AND DomainId = cas.DomainId
				--		AND Transactions_Type IN (
				--			'C'
				--			,'I'
				--			,'PreC'
				--			,'PreCToP'
				--			)),0.00
				--	) [Payment Received]

						ISNULL(
					(SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(ISNULL(transactions_amount,0.00))))))
					FROM @Trans tr
					WHERE tr.case_id = cas.Case_Id
						AND (Transactions_Type =
							'C' or Transactions_Type =
							'I' or Transactions_Type =
							'PreC' or Transactions_Type =
							'PreCToP' 
							)),0.00
					) [Payment Received]

					
				

				
  ,ISNULL(PF.Name,'N/A') as PortFolio
 
  FROM    
  tblCase cas (NOLOCK)    
 

  	        LEFT JOIN tblprovider AS pro (NOLOCK) ON cas.provider_id = pro.provider_id
			LEFT JOIN tblinsurancecompany AS ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			LEFT JOIN tbl_portfolio PF(NOLOCK) ON cas.PortfolioId = PF.id
			LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON cas.AttorneyFirmId = AF.id
			LEFT JOIN dbo.tblStatus sta(NOLOCK) ON cas.STATUS = sta.Status_Type AND cas.DomainId = sta.DomainId
			LEFT JOIN tblPacket p(NOLOCK) ON cas.FK_Packet_ID = p.Packet_Auto_ID
			LEFT JOIN tblAttorney att(NOLOCK) ON cas.Attorney_Id = att.Attorney_Id
			LEFT JOIN tblAdjusters adj(NOLOCK) ON cas.Adjuster_Id = adj.Adjuster_Id
			LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON cas.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		    LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id    
            LEFT JOIN tblSettlement_Type on sett.Settled_Type = tblSettlement_Type.SettlementType_Id  
			LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id  
			LEFT JOIN tblCourt tCrt(NOLOCK) ON cas.Court_Id = tCrt.Court_Id 
			outer apply (select Settlement_Amount,Settlement_Int, Settlement_AF, Settlement_FF, Settlement_Date 
			from @Settlements settl where settl.Case_Id = cas.Case_Id) as setmnt
			
  WHERE    
  cas.DomainId = @DomainID  and isnull(cas.isdeleted,0)=0
  and cas.Status<>'IN ARB OR LIT' and (pro.Provider_Name<>'ACP' and pro.Provider_Name<>'Testing' and  pro.Provider_Name<>'Test Provider1')
  
    )

  
  , cte2 as(

  select 
  
 row_number() over(partition by [File No.] order by [File No.]) as rownum,
[File No.],
[Patient],
[ProviderGroup],
[Providername],
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
[End DOsS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio]
 from cte)

, cte3 as (
 select   
 
[File No.],
[Patient],
[ProviderGroup],
[Providername],
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
isnull([Voluntary Payment],0.00) + ISNULL(volpay1.pamnt,0.00)  as [Voluntary Payment],
[Voluntary Payment Date]   ,
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
[End DOsS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio] from cte2 
outer apply (select isnull(transactions_amount,0.00) as pamnt from @VoluntaryPayment2  Volpay where Volpay.PacketID = cte2.[File No.]) as volpay1
where  rownum=1) 

select     
TotalRowCount =count(1) over(),
[File No.],
[Patient],
[ProviderGroup],
[Providername],
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
 
case when [Voluntary Payment Date] is null or [Voluntary Payment Date] ='' then  dt.col1 else [Voluntary Payment Date] end [Voluntary Payment Date] ,
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
[End DOsS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio]
from cte3
outer apply ( select   
Transactions_Date as col1 from @VoluntaryPayment2  Volpay where Volpay.PacketID=cte3.[File No.] ) as dt
--where cte3.[File No.]='AF19-101919'
order by ProviderGroup

  END
  ELSE
  BEGIN
  	;with cte as (
    -- Insert statements for procedure here
	SELECT 
  cas.Case_Id AS [File No.]  ,      
  cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as Patient,      
  --Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider, 
  ISNULL( pro.Provider_Groupname ,'') as ProviderGroup,
  ISNULL( pro.Provider_Name ,'') as Providername,
  ins.InsuranceCompany_Name AS [Insurance Carrier],      
  ISNULL(cas.IndexOrAAA_Number,'') AS [AAA Index No],      
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Claim_Amount,0.00))))) as [Billed Amount],    
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Paid_Amount,0.00))))) as Paid,    
  convert(decimal(38,2),(convert(money,convert(float,ISNULl(cas.Claim_Amount,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) - ISNULL(cas.WriteOff,0)))) as [Claim Balance Billed],    
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00))))) as [Fee Schedule],    
  convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Fee_Schedule,0.00)) - convert(float,ISNULL(cas.Paid_Amount,0.00)) - ISNULL(cas.WriteOff,0)))) as [Fee Schedule Balance],     
  cas.Status AS [Current Status],   
   ISNULL(cas.StatusDisposition,'') AS [Status Disposition],    
 
    
 [Hearing/Trial Date]   =(select isnull(convert(varchar(20),max(Event_Date),101),'') 
							from  tblevent t
							join tblEventStatus t2 on t.EventStatusId=t2.EventStatusId
							where t.case_id = cas.Case_Id
							--and t2.EventStatusName like'%Hearing%' 
							and t.DomainId=cas.domainId ),

  --convert(decimal(38,2),(select ISNULL(sum(DISTINCT ISNULL(Settlement_Amount,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as  [PRINCIPAL Collected], 
  --convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total,     
  --convert(decimal(38,2),(select  ISNULL(sum(DISTINCT ISNULL(Settlement_Int,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [INTEREST Collected],        
  --convert(decimal(38,2),(select  ISNULL(sum(DISTINCT ISNULL(Settlement_AF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as  [ATTORNEY FEE Collected],  
  --convert(decimal(38,2),(select ISNULL(sum(DISTINCT ISNULL(Settlement_FF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as [FILING FEE Collected],
  
   convert(decimal(38,2),setmnt.Settlement_Amount) as  [PRINCIPAL Collected], 
   convert(decimal(38,2),setmnt.Settlement_Int) as  [INTEREST Collected], 
   convert(decimal(38,2),setmnt.Settlement_AF) as  [ATTORNEY FEE Collected], 
   convert(decimal(38,2),setmnt.Settlement_FF) as  [FILING FEE Collected], 
  
  (
					SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101) 
					case when convert(varchar, ISNULL(MIN( Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN( Transactions_Date),''),101) end
					FROM @Trans tr
					WHERE tr.case_id = cas.Case_Id
						 
						AND (Transactions_Type =
							'C' or Transactions_Type ='I'
							
							)
					) [Arb Payment Date]

					,
  -- Settlement_Date=CONVERT(varchar,max(DISTINCT Settlement_Date),101),
  --[Settlement Date]=case when CONVERT(varchar,max(DISTINCT ISNULL(Settlement_Date,'')),101) ='01/01/1900' then '' else CONVERT(varchar,max(DISTINCT Settlement_Date),101) end,
    setmnt.Settlement_Date as [Settlement Date],
   ISNULL(tblSettlement_Type.Settlement_Type,'') AS [Settlement Type],
 --   [Voluntary Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))),0.00) 
	--from tblTransactions (NOLOCK)  
	--where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP'))
	 
	
	--and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')
	--),    
	 [Voluntary Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNULL(transactions_amount,0.00)))))),0.00) 
	  from @Trans trans  where trans.case_id=cas.Case_Id  and (Transactions_Type ='PreC' or Transactions_Type='PreCToP')),
  
      (SELECT 
					--convert(varchar, ISNULL(MIN(tblTransactions.Transactions_Date),''),101)
					case when convert(varchar, ISNULL(MIN(Transactions_Date),''),101) ='01/01/1900' then '' 
					else convert(varchar, ISNULL(MIN( Transactions_Date),''),101) end
					FROM @Trans tr
					WHERE tr.case_id = cas.Case_Id
						 	AND (Transactions_Type =
							'PreC' or 
							Transactions_Type ='PreCToP'
							)
							

					) [Voluntary Payment Date],

   --[Collection Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))),0.00) from tblTransactions (NOLOCK) 
   --where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),  
   
   
   [Collection Payment]=(select ISNULL(convert(decimal(38,2),(convert(money,convert(float,sum(ISNUll(transactions_amount,0.00)))))),0.00) from @trans tr
   where tr.case_id=cas.Case_Id   and (Transactions_Type ='C' or Transactions_Type ='I')),   

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
  case when convert(varchar, ISNULL(cas.DateOfService_End,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.DateOfService_End,''),101) end AS [End DOSs],
  -- CONVERT(VARCHAR(10),Accident_Date,101) AS DOA, 
  case when convert(varchar, ISNULL(cas.Accident_Date,''),101) ='01/01/1900' then '' else convert(varchar, ISNULL(cas.Accident_Date,''),101) end AS DOA, 
    ISNULL(cas.Ins_Claim_Number,'') AS [Claim #],
	 ISNULL(Policy_Number,'') AS [Policy #], 
   [Bill #]=(select top 1 ISNULL(bill_number,'') from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId),


				--ISNULL(
				--	(SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(ISNULL(transactions_amount,0.00))))))
				--	FROM tblTransactions(NOLOCK)
				--	WHERE tblTransactions.case_id = cas.Case_Id
				--		AND DomainId = cas.DomainId
				--		AND Transactions_Type IN (
				--			'C'
				--			,'I'
				--			,'PreC'
				--			,'PreCToP'
				--			)),0.00
				--	) [Payment Received]

						ISNULL(
					(SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(ISNULL(transactions_amount,0.00))))))
					FROM @Trans tr
					WHERE tr.case_id = cas.Case_Id
						AND (Transactions_Type =
							'C' or Transactions_Type =
							'I' or Transactions_Type =
							'PreC' or Transactions_Type =
							'PreCToP' 
							)),0.00
					) [Payment Received]

					
				

				
  ,ISNULL(PF.Name,'N/A') as PortFolio
 
 
  FROM    
  tblCase cas (NOLOCK)    
 

  	        LEFT JOIN tblprovider AS pro (NOLOCK) ON cas.provider_id = pro.provider_id
			LEFT JOIN tblinsurancecompany AS ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			LEFT JOIN tbl_portfolio PF(NOLOCK) ON cas.PortfolioId = PF.id
			LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON cas.AttorneyFirmId = AF.id
			LEFT JOIN dbo.tblStatus sta(NOLOCK) ON cas.STATUS = sta.Status_Type AND cas.DomainId = sta.DomainId
			LEFT JOIN tblPacket p(NOLOCK) ON cas.FK_Packet_ID = p.Packet_Auto_ID
			LEFT JOIN tblAttorney att(NOLOCK) ON cas.Attorney_Id = att.Attorney_Id
			LEFT JOIN tblAdjusters adj(NOLOCK) ON cas.Adjuster_Id = adj.Adjuster_Id
			LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON cas.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		    LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id    
            LEFT JOIN tblSettlement_Type on sett.Settled_Type = tblSettlement_Type.SettlementType_Id  
			LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id  
			LEFT JOIN tblCourt tCrt(NOLOCK) ON cas.Court_Id = tCrt.Court_Id 
			outer apply (select Settlement_Amount,Settlement_Int, Settlement_AF, Settlement_FF, Settlement_Date 
			from @Settlements settl where settl.Case_Id = cas.Case_Id) as setmnt
			
  WHERE    
  cas.DomainId = @DomainID  and isnull(cas.isdeleted,0)=0
  and cas.Status<>'IN ARB OR LIT' and (pro.Provider_Name<>'ACP' and pro.Provider_Name<>'Testing' and  pro.Provider_Name<>'Test Provider1')
  
    )

  
  , cte2 as(

  select 
  
 row_number() over(partition by [File No.] order by [File No.]) as rownum,
[File No.],
[Patient],
[ProviderGroup],
[Providername],
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
[End DOsS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio]
 from cte)

, cte3 as (
 select   
 
[File No.],
[Patient],
[ProviderGroup],
[Providername],
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
isnull([Voluntary Payment],0.00) + ISNULL(volpay1.pamnt,0.00)  as [Voluntary Payment],
[Voluntary Payment Date]   ,
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
[End DOsS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio] from cte2 
outer apply (select isnull(transactions_amount,0.00) as pamnt from @VoluntaryPayment2  Volpay where Volpay.PacketID = cte2.[File No.]) as volpay1
where  rownum=1) 

select     
row_number() over(order by [ProviderGroup]) as [SR NO],
[File No.],
[Patient],
[ProviderGroup],
[Providername],
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
 
case when [Voluntary Payment Date] is null or [Voluntary Payment Date] ='' then  dt.col1 else [Voluntary Payment Date] end [Voluntary Payment Date] ,
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
[End DOsS],
[DOA],
[Claim #],
[Policy #],
[Bill #],
[Payment Received],
[PortFolio]
from cte3
outer apply ( select   
Transactions_Date as col1 from @VoluntaryPayment2  Volpay where Volpay.PacketID=cte3.[File No.] ) as dt
--where cte3.[File No.]='AF19-101919'
order by ProviderGroup


  END
  END







