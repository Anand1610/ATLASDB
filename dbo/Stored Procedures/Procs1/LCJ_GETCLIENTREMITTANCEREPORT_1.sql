CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_1] -- LCJ_GETCLIENTREMITTANCEREPORT_1 'BT'  ,'4398'
(    
	@DomainId NVARCHAR(50),
	@clientid varchar(50)    
)    
AS
BEGIN     

IF @DomainId ='BT' 
	BEGIN
	;WITH CTE AS (
	select distinct B.provider_id,
	row_number() over (partition by A.Case_id order  by A.Case_id) as Rownum
	--,A.Transactions_Id
	, C.provider_name, dbo.fncGetAccountNumber(B.CASE_ID) as ACT_NO
	, B.CASE_ID,B.CASE_CODE,B.InjuredParty_FirstName + ' ' +B.InjuredParty_LastName[INJUREDPARTY_NAME]
	, ins.INSURANCECOMPANY_NAME
	, B.ACCIDENT_DATE
	, B.DATEOFSERVICE_START
	, B.DATEOFSERVICE_END
	, ISNULL(B.FEE_SCHEDULE,0.00) AS FEE_sCHEDULE
	, CASE WHEN  B.CASE_ID LIKE 'ACT%'  THEN CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))
      ELSE ISNULL(CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) 
	  END AS CLAIM_AMOUNT
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
		   WHEN Vendor_Fee_Type ='Flat Fee' and   TRANSACTIONS_TYPE IN ('C','PreC','PreCToP') 
		   THEN ISNULL(Vendor_Fee,0.00)

		   WHEN Vendor_Fee_Type ='%' 
		   THEN ISNULL(ABS(ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee,0.00) /100 )),0.00)),0.00)

		   WHEN Vendor_Fee_Type ='Slab Based'
		   THEN
				  case when (select top 1 AmountType from tblprovider_slabs where providerid = B.Provider_id) = 0 then 
				 (select ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and Settlement_Amount > = slabfrom and Settlement_Amount <= slabto  )  
				 when(select top 1 AmountType from tblprovider_slabs where providerid = B.Provider_id) =1 then
				 (select  ISNULL(Vendorfee,0.00) from tblCase cas inner JOIN  
				 tblprovider_slabs TS On cas.provider_id = TS.Providerid 
				 where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto  and cas.Case_Id = A.Case_Id
				 )
			     WHEN Vendor_Fee_Type IS NULL
				THEN
				0.00
				ELSE
				0.00
				END
				END AS  VENDOR_FEE,

				Vendor_Fee_Type
				
				
	--, ISNULL(C.BX_PSTG,0.00) AS FEE_POSTAGE
	--, ISNULL(Vendor_Fee_Type,'') AS Vendor_Fee_Type
	--, ISNULL(Vendor_Fee,0.00) AS Vendor_Fee
	--, Initial_Status
	--, Provider_Initial_Billing
	from tbltransactions A 
	inner join tblcase B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id   
	LEFT JOIn tblSettlements SEtt on A.case_Id=Sett.Case_Id
	WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP')   
	AND ISNULL(TRANSACTIONS_STATUS,'')<>'FREEZED'
	AND A.PROVIDER_ID=@clientid
	AND  (A.Case_Id 
	NOT in (SELECT Case_Id from Billing_Packet where DomainId=@DomainId) AND A.Case_ID not in (SELECT Packeted_Case_ID 
	from Billing_Packet where DomainId=@DomainId))

	)

	, ctesingelcase as (

	select distinct provider_id,
					--Transactions_Id,
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
					row_number() over(partition by case_id, VENDOR_FEE order by  case_id, VENDOR_FEE, transactions_id  ) as rownumber,
					case when (Vendor_Fee_Type ='Flat Fee')   
					then  ISNULL(VENDOR_FEE,0.00)
					when (Vendor_Fee_Type ='%')   
					then  ISNULL(VENDOR_FEE,0.00)
					WHEN  Vendor_Fee_Type ='Slab Based' AND ROWNUM > 1   
					THEN ISNULL(VENDOR_FEE,0.00) ELSE  ISNULL(VENDOR_FEE,0.00)
					end as VENDOR_FEE
					from CTE )

	,
	CTE1 AS (
	select distinct B.provider_id,
	ROW_NUMBER() OVER(partition by packeted_case_id,  Transactions_type 
order by A.case_id) AS  Rownum
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
		   THEN  (CASE WHEN  exists(select top 1 case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id) THEN 

		         (
				 select sum(ISNULL(Vendor_Fee,0.00)) from tblCase cas inner JOIN  
				 tblprovider TS On cas.provider_id = TS.Provider_id and cas.case_id in 
				 (select case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id
				 
				  and case_id not in (
				  select  case_id from tblTransactions with(nolock) where Transactions_status='FREEZED' 
				  union select case_id from tblTransactions with(nolock) where Invoice_Id<>0
				  )
				 )
				 where cas.provider_id = TS.Provider_id and cas.DomainId='BT'
				 
				 )
				  when exists(select top 1 case_id from Billing_Packet with(nolock) where Case_Id =  B.case_id
				 and Packeted_Case_ID in (select Case_ID from tbltransactions with(nolock) where 
				 Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I'))  AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')
				 )
				 then 0.00
				 ELSE  ISNULL(Vendor_Fee,0.00) END
				)
		   WHEN Vendor_Fee_Type ='%' 
		   THEN CAST(ISNULL(ABS(ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee,0.00) /100 )),0.00)),0.00) as decimal(10,2))
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
				 (select case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id
				  and case_id not in (
				 select  case_id from tblTransactions with(nolock) where Transactions_status='FREEZED' 
				  union select case_id from tblTransactions with(nolock) where Invoice_Id<>0
				  )
				 )
				 where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto  
				 )
				  when exists(select top 1 case_id from Billing_Packet with(nolock) where Case_Id =  B.case_id
				 and Packeted_Case_ID in (select Case_ID from tbltransactions with(nolock) where 
				 Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I'))  AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')
				 )
				 then 0.00

				 else  (select ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto) end) end
				 ,0.00
				 )

			   else 0.00 end
				  AS  VENDOR_FEE,
				Vendor_Fee_Type
				
				
	--, ISNULL(C.BX_PSTG,0.00) AS FEE_POSTAGE
	--, ISNULL(Vendor_Fee_Type,'') AS Vendor_Fee_Type
	--, ISNULL(Vendor_Fee,0.00) AS Vendor_Fee
	--, Initial_Status
	--, Provider_Initial_Billing
	from tbltransactions A 
	INNER JOIN Billing_Packet BPacket ON  A.Case_Id = BPacket.Packeted_Case_Id 
	inner join tblcase B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id   
	LEFT JOIn tblSettlements SEtt on A.case_Id=Sett.Case_Id
	WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	AND ISNULL(TRANSACTIONS_STATUS,'')<>'FREEZED'
	and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP')    
	AND A.PROVIDER_ID=@clientid
	
	 
	)
	,


 CTE3 AS (
	select distinct B.provider_id,
ROW_NUMBER() OVER(partition by  packeted_case_id, A.case_id order by A.case_id) AS  Rownum
	--,A.Transactions_Id
	, C.provider_name, dbo.fncGetAccountNumber(B.CASE_ID) as ACT_NO
	, packeted_case_id as CASE_ID,B.CASE_CODE,B.InjuredParty_FirstName + ' ' +B.InjuredParty_LastName[INJUREDPARTY_NAME]
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
		   THEN ISNULL(Vendor_Fee,0.00)
		   WHEN Vendor_Fee_Type ='%' 
		   THEN cast(ISNULL(ABS(ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee,0.00) /100 )),0.00)),0.00) as decimal(10,2))
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
				 (select case_id from Billing_Packet with(nolock) where Packeted_Case_ID =  B.case_id
				  and case_id not in (
				 select  case_id from tblTransactions with(nolock) where Transactions_status='FREEZED' 
				  union select case_id from tblTransactions with(nolock) where Invoice_Id<>0
				  )
				 )
				 where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto  
				 )
				  when exists(select top 1 case_id from Billing_Packet with(nolock) where Case_Id =  B.case_id
				 and Packeted_Case_ID in (select Case_ID from tbltransactions with(nolock) where 
				 Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I'))  
				 AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')
				 )
				 then 0.00

				 else  (select ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto) end) end
				 ,0.00
				 )

			   else 0.00 end
				  AS  VENDOR_FEE,

				Vendor_Fee_Type
				
				
	--, ISNULL(C.BX_PSTG,0.00) AS FEE_POSTAGE
	--, ISNULL(Vendor_Fee_Type,'') AS Vendor_Fee_Type
	--, ISNULL(Vendor_Fee,0.00) AS Vendor_Fee
	--, Initial_Status
	--, Provider_Initial_Billing
	from tbltransactions A 
	INNER JOIN Billing_Packet BPacket ON  A.Case_Id = BPacket.Case_Id 
	inner join tblcase B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id   
	LEFT JOIn tblSettlements SEtt on A.case_Id=Sett.Case_Id
	WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	AND ISNULL(TRANSACTIONS_STATUS,'')<>'FREEZED'
	and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP')    
	AND A.PROVIDER_ID=@clientid

	 
	)

	,CTE4 as (
		select      provider_id,
		Row_Number() Over(Partition by CASE_ID Order by case_Id) as Rownum1,
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
					VENDOR_FEE,
					Vendor_Fee_Type
					from CTE1     where rownum=1 
					)

	


	select provider_id,
					--Transactions_Id,
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
					case when rownumber>1 then 0.00 else VENDOR_FEE
					end as VENDOR_FEE
					from ctesingelcase 

					UNION

						select          provider_id,
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
					case when (Vendor_Fee_Type ='Flat Fee')  AND ROWNUM1 > 1    
					then   0.00
					when (Vendor_Fee_Type ='%')   
					then  ISNULL(VENDOR_FEE,0.00)
					WHEN  (Vendor_Fee_Type ='Slab Based')      AND ROWNUM1 > 1  
					THEN 0.00 ELSE  ISNULL(VENDOR_FEE,0.00) 
					end as VENDOR_FEE
					from CTE4      
					
					UNION
					
	--select  provider_id,
	--				--Transactions_Id,
	--				provider_name,
	--				ACT_NO,
	--				CASE_ID,
	--				CASE_CODE,
	--				INJUREDPARTY_NAME,
	--				INSURANCECOMPANY_NAME,
	--				MAX(ACCIDENT_DATE) as ACCIDENT_DATE,
	--				MIN(DATEOFSERVICE_START) as DATEOFSERVICE_START,
	--				MAX(DATEOFSERVICE_END) as DATEOFSERVICE_END,
	--				SUM(FEE_sCHEDULE) as FEE_sCHEDULE,
	--				SUM(CLAIM_AMOUNT) as CLAIM_AMOUNT,
	--				TRANSACTIONS_TYPE,
	--				SUM(TRANSACTIONS_AMOUNT) as TRANSACTIONS_AMOUNT,
	--				SUM(TRANSACTIONS_fee) as TRANSACTIONS_fee,
	--				MAX(TRANSACTIONS_DATE) as TRANSACTIONS_DATE,
	--				MAX(TRANSACTIONS_dESCRIPTION),
	--				MAX(TRANSACTIONS_ID),
 --                   SUM(VENDOR_FEE) as VENDOR_FEE
	--				from CTE3
	--				GROUP by provider_id,
	--				--Transactions_Id,
	--				provider_name,
	--				ACT_NO,
	--				CASE_ID,
	--				CASE_CODE,
	--				INJUREDPARTY_NAME,
	--				INSURANCECOMPANY_NAME,
	--				TRANSACTIONS_TYPE,
	--				TRANSACTIONS_dESCRIPTION
		select  cas.provider_id,
					--Transactions_Id,
					provider_name,
					ACT_NO,
					cas.CASE_ID,
					cas.CASE_CODE,
					INJUREDPARTY_NAME,
					INSURANCECOMPANY_NAME,
					MAX(cas.ACCIDENT_DATE) as ACCIDENT_DATE,
					MAX(cas.DATEOFSERVICE_START) as DATEOFSERVICE_START,
					MAX(cas.DATEOFSERVICE_END) as DATEOFSERVICE_END,
					MAX(cas.FEE_sCHEDULE) as FEE_sCHEDULE,
					MAX(cas.CLAIM_AMOUNT) as CLAIM_AMOUNT,
					TRANSACTIONS_TYPE,
					SUM(TRANSACTIONS_AMOUNT) as TRANSACTIONS_AMOUNT,
					SUM(TRANSACTIONS_fee) as TRANSACTIONS_fee,
					MAX(TRANSACTIONS_DATE) as TRANSACTIONS_DATE,
					MAX(TRANSACTIONS_dESCRIPTION),
					MAX(TRANSACTIONS_ID),
                 

					sum(case when (Vendor_Fee_Type ='Flat Fee')  AND ROWNUM > 1    
					then   0.00
					when (Vendor_Fee_Type ='%')   
					then  ISNULL(VENDOR_FEE,0.00)
					WHEN  (Vendor_Fee_Type ='Slab Based')      AND ROWNUM > 1  
					THEN 0.00 ELSE  ISNULL(VENDOR_FEE,0.00) 
					end )
				--	SUM( ISNULL(VENDOR_FEE,0.00) )

					from CTE3 INNER JOIN Tblcase cas with(nolock) on CTE3.CASE_ID = cas.Case_Id
					GROUP by cas.provider_id,
					--Transactions_Id,
					provider_name,
					ACT_NO,
					cas.CASE_ID,
					cas.CASE_CODE,
					INJUREDPARTY_NAME,
					INSURANCECOMPANY_NAME,
					TRANSACTIONS_TYPE,
					TRANSACTIONS_dESCRIPTION




					END

					ELSE
					BEGIN

WITH CTE AS (
	select distinct B.provider_id,
	row_number() over (partition by A.Case_id order  by A.Case_id) as Rownum
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
		   AND Transactions_Id =(select Top 1 Transactions_Id from tblTransactions where Case_Id=A.Case_Id 
		   AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I') AND (A.Case_Id NOT 
		   IN (Select Case_Id from tblTransactions where Transactions_status='FREEZED' 
		   AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I')))  
		   AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') order by Transactions_Id )
		   THEN 
		   ISNULL(Vendor_Fee,0.00) 
		   WHEN Vendor_Fee_Type ='%' 
		   AND Transactions_Id =(select Top 1 Transactions_Id from tblTransactions where Case_Id=A.Case_Id AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I') AND (A.Case_Id NOT IN (Select Case_Id from tblTransactions where Transactions_status='FREEZED' AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I')))  AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') order by Transactions_Id )
		   THEN  ISNULL(ABS(ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee,0.00) /100 )),0.00)),0.00) 
		    WHEN Vendor_Fee_Type IS NULL
				THEN
				0.00
				ELSE
				0.00
				END AS  VENDOR_FEE,
		   Vendor_Fee_Type
	from tbltransactions A 
	inner join tblcase B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id   
	LEFT JOIn tblSettlements SEtt on A.case_Id=Sett.Case_Id
	WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP')    
	AND A.PROVIDER_ID=@clientid
	)

	SELECT  DISTINCT 
			provider_id,
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
			TRANSACTIONS_FEE,
			TRANSACTIONS_DATE,
			TRANSACTIONS_dESCRIPTION,
			TRANSACTIONS_ID,
			case when Vendor_Fee_Type ='Flat Fee'  or Vendor_Fee_Type ='%'    
					then  ISNULL(VENDOR_FEE,0.00)  WHEN  Vendor_Fee_Type ='Slab Based' AND ROWNUM > 1  
					THEN 0 ELSE  ISNULL(VENDOR_FEE,0.00) end as VENDOR_FEE
					from CTE


END

END