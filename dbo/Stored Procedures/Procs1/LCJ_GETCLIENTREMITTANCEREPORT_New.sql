CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_New] -- LCJ_GETCLIENTREMITTANCEREPORT 'glf'  ,'3786'
(    
	@DomainId NVARCHAR(50),
	@clientid varchar(50)    
)    
AS
BEGIN     


DECLARE @caseData Table
			(
			[Case_Id] varchar(50) index IDX_CLUST Clustered,
		    [Accident_Date] datetime NULL,
			[Case_AutoId] int,
			[Case_Code] varchar(100) NULL,
			[Claim_Amount] float NULL,
			[Date_BillSent] varchar(50),
			[DomainId] varchar(50) NULL,
			[Fee_Schedule] float NULL,
			[Initial_Status] varchar(50) NULL,
			[InjuredParty_FirstName] varchar(100) NULL,
			[InjuredParty_LastName] varchar(100) NULL,
			[InsuranceCompany_Id] int NULL,
			[InsuredParty_FirstName] varchar(100) NULL,
			[InsuredParty_LastName] varchar(100) NULL,
			[Paid_Amount] float NULL,
			[PortfolioId] int NULL,
			[Provider_Id] int NULL,
			[Status] varchar(50) NULL,
			[WriteOff] float NULL,
			[IsDeleted] bit NULL,
			[InsuranceCompany_Name] varchar(250) NULL,
			[Provider_Name] varchar(200),
		    [Provider_GroupName] varchar(100),
			[packet_type] varchar(100),
			[DATEOFSERVICE_START] datetime,
			[DATEOFSERVICE_END] datetime
			
			)

			INSERT INTO @caseData
			(   
			    Accident_Date,
				Case_AutoId,
				Case_Code,
				Case_Id,
				Claim_Amount,
				Date_BillSent,
				DomainId,
				Fee_Schedule,
				Initial_Status,
				InjuredParty_FirstName,
				InjuredParty_LastName,
				InsuredParty_FirstName,
				InsuredParty_LastName,
				Paid_Amount,
				PortfolioId,
				Provider_Id,
				Status,
				WriteOff,
				DATEOFSERVICE_START,
				DATEOFSERVICE_END,
				InsuranceCompany_Id
	--			  Provider_Name, Vendor_Fee_Type, 
	--Provider_Initial_Billing, Provider_IntBilling, Provider_Initial_IntBilling, Vendor_Fee,InsuranceCompany_Name ,

	

			)

			SELECT 
				Accident_Date,
				Case_AutoId,
				Case_Code,
				cas.Case_Id,
				Claim_Amount,
				Date_BillSent,
				cas.DomainId,
				Fee_Schedule,
				Initial_Status,
				InjuredParty_FirstName,
				InjuredParty_LastName,
				InsuredParty_FirstName,
				InsuredParty_LastName,
				Paid_Amount,
				PortfolioId,
				cas.Provider_Id,
				Status,
				WriteOff,
				DATEOFSERVICE_START,
				DATEOFSERVICE_END,
				--Provider_Name, Vendor_Fee_Type, 
	   --         Provider_Initial_Billing, 
	   --         Provider_IntBilling, 
				--Provider_Initial_IntBilling, 
				--Vendor_Fee,
				--InsuranceCompany_Name ,
				cas.InsuranceCompany_Id
				
			from tblcase cas with(nolock) 
			INNER JOIN tblProvider pro with(nolock) ON Cas.Provider_Id= pro.Provider_Id
			INNER JOIN tblInsuranceCompany INS with(nolock) ON cas.InsuranceCompany_Id = INS.InsuranceCompany_Id
			INNER JOIN tbltransactions tr with(nolock)  ON cas.case_Id=tr.Case_Id 
			where cas.domainid=@DomainID  and cas.Provider_Id=@Clientid

     DECLARE @TransactionsData TABLE
	(
	 [Case_Id] varchar(50) ,
	 [Transactions_Id] [int]   INDEX IDX_TRANS clustered,
	 [Transactions_Type] [nvarchar](20) NOT NULL,
	 [Transactions_Amount] [money] NOT NULL,
	 [Transactions_Description] [nvarchar](255) NULL,
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
	where tr.DomainId=@DomainId AnD (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED' or Transactions_status!='FREEZED'  )  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP','PreI','ID') 

    DECLARE @TransactionsData2 TABLE
	(
	 [Case_Id] varchar(50) ,
	 [Transactions_Id] [int]   INDEX IDX_TRANS clustered,
	 [Transactions_Type] [nvarchar](20) NOT NULL,
	 [Transactions_Amount] [money] NOT NULL,
	 [Transactions_Description] [nvarchar](255) NULL,
	 [Transactions_status] [varchar](50) NULL,
	 [Transactions_Date] [smalldatetime] NOT NULL
	
	)
	
	INSERT INTO @TransactionsData2(Case_Id, Transactions_Id, Transactions_Type, Transactions_Amount, Transactions_Description,Transactions_status, Transactions_Date)
	SELECT tr.Case_id, Transactions_Id, Transactions_Type, Transactions_Amount, Transactions_Description,Transactions_status, Transactions_Date
	FROM tbltransactions tr with(nolock) 
	INNER JOIN @caseData cas ON  tr.case_id = cas.Case_Id
	where tr.DomainId=@DomainId AND Transactions_status='FREEZED' 
		   AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I') AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')



	 DECLARE @Settlment TABLE
	(
	[Case_Id] [nvarchar](50) INDEX IDX_SETT clustered,
	[Settlement_Amount] [money] NULL,
	[Settled_Type] [nvarchar](100) NULL
	)

	INSERT INTO @Settlment(Case_Id,Settlement_Amount,  Settled_Type)
	select cas.Case_Id,Settlement_Amount,  Settled_Type from @caseData cas INNER JOIN tblSettlements tse with(NOLOCK) 
	ON cas.Case_Id = tse.Case_Id
	
	where cas.DomainId=@DomainId



    ;WITH CTE AS (
	select  B.provider_id,
	row_number() over (partition by A.Case_id, A.transactions_type, A.transactions_amount order  by A.Case_id) as Rownum
	--,A.Transactions_Id
	, C.provider_name, dbo.fncGetAccountNumber(B.CASE_ID) as ACT_NO
	, B.CASE_ID,B.CASE_CODE,B.InjuredParty_FirstName + ' ' +B.InjuredParty_LastName[INJUREDPARTY_NAME]
	, ins.INSURANCECOMPANY_NAME
	, B.ACCIDENT_DATE
	, B.DATEOFSERVICE_START
	, B.DATEOFSERVICE_END
	, ISNULL(B.FEE_SCHEDULE,0.00) AS FEE_sCHEDULE
	, CASE WHEN  B.CASE_ID LIKE 'ACT%'  THEN CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))
		   ELSE ISNULL(CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) END AS CLAIM_AMOUNT
	, A.TRANSACTIONS_TYPE
	, A.TRANSACTIONS_AMOUNT --A.TRANSACTIONS_fee,
	, CASE 	   
		   WHEN TRANSACTIONS_TYPE IN ('PreC') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Initial_Billing,1) /100 )),0.00)
			WHEN TRANSACTIONS_TYPE IN ('PreCToP') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Initial_Billing,1) /100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('C')
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Billing,1) /100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I')  AND B.CASE_ID LIKE 'ACT%' 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT *  ISNULL(Provider_Initial_IntBilling,1)/100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_IntBilling,1) /100 )),0.00) END as TRANSACTIONS_FEE
	, A.TRANSACTIONS_DATE
	, 'Check Date : ' +ISNULL(CONVERT(VARCHAR,A.CheckDate,101 ),'') +' Check No : ' + ISNULL(A.ChequeNo,'')  + ' Desc : ' + ISNULL(A.TRANSACTIONS_dESCRIPTION    ,'') as TRANSACTIONS_dESCRIPTION
	--, ISNULL(A.ChequeNo,'')  + ISNULL(A.TRANSACTIONS_dESCRIPTION    ,'') as TRANSACTIONS_dESCRIPTION
	, A.TRANSACTIONS_ID,

	
	CASE 	   
		   WHEN Vendor_Fee_Type ='Flat Fee' 
		   AND Transactions_Id =(select Top 1 Transactions_Id from @TransactionsData where Case_Id=A.Case_Id 
		   AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I') AND (A.Case_Id NOT 
		   IN (Select Case_Id from @TransactionsData2 where Transactions_status='FREEZED' 
		   AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I')))  
		   AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') order by Transactions_Id )
		   
		   THEN 
		      CASE WHEN @domainid='BT' then 
		       (CASE WHEN  exists(select top 1 case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id) THEN 

		         (
				 select sum(ISNULL(Vendor_Fee,0.00)) from tblCase cas inner JOIN  
				 tblprovider TS On cas.provider_id = TS.Provider_id and cas.case_id in 
				 (select case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id)
				 where cas.provider_id = TS.Provider_id and cas.DomainId='BT')
				 ELSE  ISNULL(Vendor_Fee,0.00) END
				)
				ELSE
				ISNULL(Vendor_Fee,0.00) END
			WHEN Vendor_Fee_Type ='%' 
			AND Transactions_Id =(select Top 1 Transactions_Id from @TransactionsData where Case_Id=A.Case_Id AND Transactions_Type 
			IN ('PreC','C','PreCToP','PreI','ID','I') AND (A.Case_Id NOT IN (Select Case_Id from @TransactionsData2 where Transactions_status='FREEZED' AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I')))  AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') order by Transactions_Id )
			THEN 
				ISNULL(ABS(ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee,0.00) /100 )),0.00)),0.00)
			
			WHEN Vendor_Fee_Type ='Slab Based'
			THEN
				 ISNULL( case when (select top 1 AmountType from tblprovider_slabs where providerid = B.Provider_id) = 0 then 
				 (
				 case when exists(select top 1 case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id) 
				 THEN 
				 --(select sum(ISNULL(Vendorfee,0.00)) from tblCase cas inner JOIN  
				 --tblprovider_slabs TS On cas.provider_id = TS.Providerid and cas.case_id in 
				 --(select case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id)
				 --where providerid = B.Provider_id 
				 --and Settlement_Amount > = slabfrom and Settlement_Amount <= slabto  
				 --)
				 --else  
				 (select ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and Settlement_Amount > = slabfrom and Settlement_Amount <= slabto) end 

				 )
				 else
				 (
				 case when exists(select top 1 case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id) 
				 THEN 
				 (select sum(ISNULL(Vendorfee,0.00)) from tblCase cas inner JOIN  
				 tblprovider_slabs TS On cas.provider_id = TS.Providerid and cas.case_id in 
				 (select case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id)
				 where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto  
				 )
				 else  (select ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto) end) end
				 ,0.00
				 )

			WHEN Vendor_Fee_Type IS NULL
				THEN
				0.00
				ELSE
				0.00
				END AS  VENDOR_FEE,

				Vendor_Fee_Type
				
				
	--, ISNULL(C.BX_PSTG,0.00) AS FEE_POSTAGE
	--, ISNULL(Vendor_Fee_Type,'') AS Vendor_Fee_Type
	--, ISNULL(Vendor_Fee,0.00) AS Vendor_Fee
	--, Initial_Status
	--, Provider_Initial_Billing
	from @TransactionsData A 
	inner join @caseData B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id   
	LEFT JOIN @Settlment   Sett ON sett.Case_Id=A.Case_Id
	WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP')    
	AND B.PROVIDER_ID=@clientid    )

, CTE2 as (
		    select 
		    row_number() over (partition by Case_id order  by Case_id, transactions_id) as Rownum,
			provider_id,
			Vendor_Fee_Type,
			provider_name,
			ACT_NO,
			CASE_ID,
			CASE_CODE,
			INJUREDPARTY_NAME,
			INSURANCECOMPANY_NAME,
			ACCIDENT_DATE,
			DATEOFSERVICE_START,
			DATEOFSERVICE_END,
			FEE_sCHEDULE,
			CLAIM_AMOUNT,
			TRANSACTIONS_TYPE,
			TRANSACTIONS_AMOUNT,
			TRANSACTIONS_fee,
			TRANSACTIONS_DATE,
			TRANSACTIONS_dESCRIPTION,
			TRANSACTIONS_ID,
			VENDOR_FEE
 from CTE where rownum= 1)

	select distinct provider_id,
					Transactions_Id,
					provider_name,
					ACT_NO,
					CASE_ID,
					CASE_CODE,
					INJUREDPARTY_NAME,
					INSURANCECOMPANY_NAME,
					ACCIDENT_DATE,
					DATEOFSERVICE_START,
					DATEOFSERVICE_END,
					FEE_sCHEDULE,
					CLAIM_AMOUNT,
					TRANSACTIONS_TYPE,
					TRANSACTIONS_AMOUNT,
					TRANSACTIONS_fee,
					TRANSACTIONS_DATE,
					TRANSACTIONS_dESCRIPTION,
					TRANSACTIONS_ID,
					--case when  ROWNUM =1  
					--THEN VENDOR_FEE ELSE  0 end as VENDOR_FEE
					 Vendor_Fee_Type,
					case when Vendor_Fee_Type ='Flat Fee'  or Vendor_Fee_Type ='%'    
					then  VENDOR_FEE  WHEN  Vendor_Fee_Type ='Slab Based' AND ROWNUM > 1  
					THEN 0 ELSE  VENDOR_FEE end as VENDOR_FEE

					from CTE2 

	--ORDER BY TRANSACTIONS_DATE  
END

