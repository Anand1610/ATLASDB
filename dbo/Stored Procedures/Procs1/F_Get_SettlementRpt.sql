CREATE PROCEDURE [dbo].[F_Get_SettlementRpt]   --[dbo].[F_Get_SettlementRpt] '1/1/2013','12/31/2013','Provider' ,''   
(
	@DomainId NVARCHAR(50),
	@s_l_fromdate DATETIME,
	@s_l_todate DATETIME,
	@chk VARCHAR(50),
	@provider_Group VARCHAR(50)
)
AS  
	BEGIN
	
	
	DECLARE @Table_Settlement TABLE( 
						Case_ID varchar(30) NOT NULL,
						Provider_Group VARCHAR(200),
						Provider_Name VARCHAR(1000),
						InsuranceCompany_Name VARCHAR(1000),
						User_Id VARCHAR(100),
						Claim_Amount money,
						Paid_Amount money,
						Claim_Balance money,
						FeeSchedule_Balance money,
						Settlement_Amount money,
						Settlement_Date DateTime,
						Settlement_Type Varchar(500),
						Settlement_AF money,
						Settlement_Ff Money,
						Settlement_Per Decimal(18,2),
						Provider_Billing Decimal(18,2)
					
					); 

	INSERT @Table_Settlement
	SELECT distinct C.CASE_ID
		, ISNULL(P.Provider_GroupName,'') AS  Provider_GroupName
		, P.Provider_Name
		, I.InsuranceCompany_Name
		, S.User_Id
		, ISNULL(C.Claim_Amount,'0.00') AS Claim_Amount
		, ISNULL(C.Paid_Amount,'0.00') AS Paid_Amount
		--, ISNULL(C.Claim_Amount,'0.00') - ISNULL(C.Paid_Amount,'0.00') AS FeeSchedule_Balance
		, CONVERT(float, ISNULL(C.Claim_Amount,'0.00')) - CONVERT(float, ISNULL(C.Paid_Amount,'0.00'))
		, ISNULL(C.Fee_Schedule,'0.00') - ISNULL(C.Paid_Amount,'0.00') AS FeeSchedule_Balance
		, max(Settlement_Amount)+Max(Settlement_Int) AS Settlement_Amount
		, max(Settlement_Date) AS Settlement_Date
		, max(Settlement_Type) AS Settlement_Type
		, max(Settlement_AF) AS Settlement_AF
		, max(Settlement_Ff) AS Settlement_Ff
		, ISNULL(100 * (SUM(CONVERT(MONEY,ISNULL(Settlement_Amount,0)) + CONVERT(MONEY,ISNULL(Settlement_Int,0))))/NULLIF(SUM(Fee_Schedule-Paid_Amount),0),'0.00') as Settlement_Avg
		, (Max(Provider_Billing)*max(Settlement_Amount)/100)+(Max(Provider_IntBilling)*max(Settlement_Int)/100)
	FROM tblcase C
	INNER JOIN tblProvider P ON P.Provider_Id = C.Provider_Id
	INNER JOIN tblInsuranceCompany I on I.InsuranceCompany_Id = C.InsuranceCompany_Id
	INNER JOIN Tblsettlements S ON  S.Case_Id =C.Case_Id
	LEFT OUTER JOIN tblSettlement_Type ST ON ST.SettlementType_Id = Settled_Type
	WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate	
		AND ISNULL(P.Provider_GroupName,'') like '%' + @provider_Group +'%' and C.DomainId=@DomainId
	GROUP BY C.CASE_ID
		, P.Provider_GroupName
		, P.Provider_Name
		, I.InsuranceCompany_Name
		, S.User_Id
		, C.Claim_Amount
		, C.Paid_Amount
		, C.Fee_Schedule
		, Provider_Billing





IF (@chk='INSURANCE')
BEGIN
	SELECT Distinct DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) AS 	Settlement_Date,
		CONVERT(VARCHAR(7), Settlement_Date, 120) AS [Set_Date],
		InsuranceCompany_Name as [Group],
		count(Case_ID) AS Case_ID,
		SUM(Claim_Amount) AS Claim_Amount,
		SUM(Paid_Amount) AS Paid_Amount,
		SUM(FeeSchedule_Balance) AS Claim_Balance,
		--SUM(FeeSchedule_Balance) AS 	FeeSchedule_Balance,
		SUM(Settlement_Amount) AS Settlement_Amount,
		MAX(Settlement_Type) AS  Settlement_Type,
		SUM(Settlement_AF) AS Settlement_AF,
		SUM(Settlement_Ff) AS Settlement_Ff,
		CONVERT(Numeric(18,2),SUM(Settlement_Per)/Count(Case_ID)) AS AvgRatio,
		SUM(Provider_Billing) as Client_Fee
	FROM @Table_Settlement
	Group by 
		InsuranceCompany_Name,
		DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)),
		CONVERT(VARCHAR(7), Settlement_Date, 120)
	ORDER BY CONVERT(VARCHAR(7), Settlement_Date, 120)
END
IF (@chk='PROVIDER') 
BEGIN
	SELECT Distinct DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) AS 	Settlement_Date,
		CONVERT(VARCHAR(7), Settlement_Date, 120) AS [Set_Date],
		Provider_Name as [Group],
		count(Case_ID) AS Case_ID,
		SUM(Claim_Amount) AS Claim_Amount,
		SUM(Paid_Amount) AS Paid_Amount,
		SUM(FeeSchedule_Balance) AS Claim_Balance,
		--SUM(FeeSchedule_Balance) AS 	FeeSchedule_Balance,
		SUM(Settlement_Amount) AS Settlement_Amount,
		MAX(Settlement_Type) AS  Settlement_Type,
		SUM(Settlement_AF) AS Settlement_AF,
		SUM(Settlement_Ff) AS Settlement_Ff,
		CONVERT(Numeric(18,2),SUM(Settlement_Per)/Count(Case_ID)) AS AvgRatio,
		SUM(Provider_Billing) as Client_Fee
	FROM @Table_Settlement
	Group by 
		Provider_Name,
		DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)),
		CONVERT(VARCHAR(7), Settlement_Date, 120)
	ORDER BY CONVERT(VARCHAR(7), Settlement_Date, 120)
END
IF (@chk='')
BEGIN
	SELECT Distinct DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) AS 	Settlement_Date,
		CONVERT(VARCHAR(7), Settlement_Date, 120) AS [Set_Date],
		User_Id as [Group],
		count(Case_ID) AS Case_ID,
		SUM(Claim_Amount) AS Claim_Amount,
		SUM(Paid_Amount) AS Paid_Amount,
		SUM(FeeSchedule_Balance) AS Claim_Balance,
		--SUM(FeeSchedule_Balance) AS 	FeeSchedule_Balance,
		SUM(Settlement_Amount) AS Settlement_Amount,
		MAX(Settlement_Type) AS  Settlement_Type,
		SUM(Settlement_AF) AS Settlement_AF,
		SUM(Settlement_Ff) AS Settlement_Ff,
		CONVERT(Numeric(18,2),SUM(Settlement_Per)/Count(Case_ID)) AS AvgRatio,
		SUM(Provider_Billing) as Client_Fee
	FROM @Table_Settlement
	Group by 
		User_Id,
		DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)),
		CONVERT(VARCHAR(7), Settlement_Date, 120)
	ORDER BY CONVERT(VARCHAR(7), Settlement_Date, 120)
END

	
			--IF (@chk='INSURANCE') 
			--	BEGIN
			--			 SELECT  DISTINCT INSURANCE_NAME as [Group], Settlement_Type='withdrawn', COUNT( DISTINCT cASe_id) AS CASE_ID,SUM(Fee_Schedule-Paid_Amount)AS CLAIM_BALANCE, 
			--			 SUM(Settlement_PI+Settlement_Int) AS Settlement_Amount,SUM(Settlement_Af) AS Settlement_Af,SUM(Settlement_Ff) AS Settlement_Ff,
			--			 SUM(PROVIDER_BILLING*SETTLEMENT_AMOUNT/100) AS Collection_Fee,
			--			 DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) Settlement_Date,
			--			 CAST(ROUND(100.0 * SUM(Settlement_PI+Settlement_Int) / NULLIF(SUM(Fee_Schedule-Paid_Amount),0),2) AS DECIMAL(8,2)) AS AvgRatio
			--			 FROM LCJ_VW_CaseSearchDetails	
			--			 WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate AND Settlement_Type LIKE '%withdrawn%'
			--			 and Provider_GroupName like @provider_Group
			--			 GROUP BY INSURANCE_NAME,DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date))
			--			UNION 
			--			 SELECT  distinct INSURANCE_NAME as [Group],Settlement_Type='settled',COUNT( DISTINCT cASe_id) AS CASE_ID,SUM(Fee_Schedule-Paid_Amount)AS CLAIM_BALANCE,
			--			 SUM(Settlement_PI+Settlement_Int) AS Settlement_Amount,SUM(Settlement_Af) AS Settlement_Af,SUM(Settlement_Ff) AS Settlement_Ff,
			--			 SUM(PROVIDER_BILLING*SETTLEMENT_AMOUNT/100) AS Collection_Fee,
			--			 DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) Settlement_Date,
			--			 CAST(round(100.0 * SUM(Settlement_PI+Settlement_Int) /  NULLIF(SUM(Fee_Schedule-Paid_Amount),0),2) AS DECIMAL(8,2)) AS AvgRatio
			--			 FROM LCJ_VW_CaseSearchDetails 
			--			 WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate	AND Settlement_Type not like '%withdrawn%'
			--			 and Provider_GroupName like @provider_Group
			--			 GROUP BY INSURANCE_NAME,DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date))
			--	 END   
			-- ELSE
			-- IF (@chk='PROVIDER') 
			--	 BEGIN
			--	 SELECT  DISTINCT Provider_Name as [Group],Settlement_Type='withdrawn', COUNT( DISTINCT Case_Id) AS CASE_ID,SUM(Fee_Schedule-Paid_Amount)AS CLAIM_BALANCE, 
			--	 SUM(Settlement_PI+Settlement_Int) AS Settlement_Amount,SUM(Settlement_Af) AS Settlement_Af,SUM(Settlement_Ff) AS Settlement_Ff,
			--	 SUM(PROVIDER_BILLING*SETTLEMENT_AMOUNT/100) AS Collection_Fee,
			--	 DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) Settlement_Date,
			--	 CAST(ROUND(100.0 * SUM(Settlement_PI+Settlement_Int) /  NULLIF(SUM(Fee_Schedule-Paid_Amount),0),2) AS DECIMAL(8,2) ) AS AvgRatio
			--	 FROM LCJ_VW_CaseSearchDetails	
			--	 WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate AND Settlement_Type LIKE '%withdrawn%'
			--	 and Provider_GroupName like @provider_Group
			--	 GROUP BY Provider_Name,DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date))
				 
			--	UNION 
			--	 SELECT  distinct Provider_Name as [Group], Settlement_Type='settled',COUNT( DISTINCT cASe_id) AS CASE_ID,SUM(Fee_Schedule-Paid_Amount)AS CLAIM_BALANCE,
			--	 SUM(Settlement_PI+Settlement_Int) AS Settlement_Amount,SUM(Settlement_Af) AS Settlement_Af,SUM(Settlement_Ff) AS Settlement_Ff,
			--	 SUM(PROVIDER_BILLING*SETTLEMENT_AMOUNT/100) AS Collection_Fee,
			--	 DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) Settlement_Date,
			--	 CAST(round(100.0 * SUM(Settlement_PI+Settlement_Int) / NULLIF(SUM(Fee_Schedule-Paid_Amount),0),2) AS DECIMAL(8,2)) AS AvgRatio
			--	 FROM LCJ_VW_CaseSearchDetails 
			--	 WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate	AND Settlement_Type not like '%withdrawn%'
			--	 and Provider_GroupName like @provider_Group
			--	 GROUP BY Provider_Name,DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date))
			--	 END 
			-- ELSE
			--  IF (@chk='') 
			--	 BEGIN
			--	 SELECT  DISTINCT USER_ID as [Group],Settlement_Type='withdrawn', COUNT( DISTINCT cASe_id) AS CASE_ID,SUM(Fee_Schedule-Paid_Amount)AS CLAIM_BALANCE, 
			--	 SUM(Settlement_PI+Settlement_Int) AS Settlement_Amount,SUM(Settlement_Af) AS Settlement_Af,SUM(Settlement_Ff) AS Settlement_Ff,
			--	 SUM(PROVIDER_BILLING*SETTLEMENT_AMOUNT/100) AS Collection_Fee,
			--	 DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) Settlement_Date,
			--	 CAST(ROUND(100.0 * SUM(Settlement_PI+Settlement_Int) / NULLIF(SUM(Fee_Schedule-Paid_Amount),0),2) AS DECIMAL(8,2)) AS AvgRatio
			--	 FROM LCJ_VW_CaseSearchDetails	
			--	 WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate AND Settlement_Type LIKE '%withdrawn%'
			--	 and Provider_GroupName like @provider_Group
			--	 GROUP BY User_Id,DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date))
			--	UNION 
			--	 SELECT  distinct USER_ID as [Group],Settlement_Type='settled',COUNT( DISTINCT cASe_id) AS CASE_ID,SUM(Fee_Schedule-Paid_Amount)AS CLAIM_BALANCE,
			--	 SUM(Settlement_PI+Settlement_Int) AS Settlement_Amount,SUM(Settlement_Af) AS Settlement_Af,SUM(Settlement_Ff) AS Settlement_Ff,
			--	 SUM(PROVIDER_BILLING*SETTLEMENT_AMOUNT/100) AS Collection_Fee,
			--	 DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) Settlement_Date,
			--	 CAST(round(100.0 * SUM(Settlement_PI+Settlement_Int) / NULLIF(SUM(Fee_Schedule-Paid_Amount),0),2) AS DECIMAL(8,2)) AS AvgRatio
			--	 FROM LCJ_VW_CaseSearchDetails 
			--	 WHERE CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Settlement_Date)) AS DATETIME) <= @s_l_todate	AND Settlement_Type not like '%withdrawn%'
			--	 and Provider_GroupName like @provider_Group
			--	 GROUP BY User_Id,DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date))
			--	END
	END

