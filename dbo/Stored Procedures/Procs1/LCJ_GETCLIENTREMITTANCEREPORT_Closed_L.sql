
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_Closed_L]
	-- Add the parameters for the stored procedure here  
	@DomainId NVARCHAR(50)
	,@Client_id NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;;

	WITH CTE
	AS (
		-- Insert statements for procedure here  
		SELECT B.provider_id
			,row_number() OVER (
				PARTITION BY A.Case_id
				,A.transactions_type
				,A.transactions_amount ORDER BY A.Case_id
				) AS Rownum
			,C.provider_name
			,dbo.fncGetAccountNumber(B.CASE_ID) AS ACT_NO
			,B.CASE_ID
			,B.CASE_CODE
			,B.InjuredParty_FirstName + ' ' + B.InjuredParty_LastName [INJUREDPARTY_NAME]
			,ins.INSURANCECOMPANY_NAME
			,B.ACCIDENT_DATE
			,B.DATEOFSERVICE_START
			,B.DATEOFSERVICE_END
			,ISNULL(B.FEE_SCHEDULE, 0.00) AS FEE_sCHEDULE
			,CASE 
				WHEN B.Case_Id LIKE 'ACT%'
					THEN CONVERT(MONEY, ISNULL(B.CLAIM_AMOUNT, 0.00))
				ELSE ISNULL(CONVERT(MONEY, ISNULL(B.CLAIM_AMOUNT, 0.00)) - CONVERT(MONEY, ISNULL(B.PAID_AMOUNT, 0.00)), 0.00)
				END AS CLAIM_AMOUNT
			,A.TRANSACTIONS_TYPE
			,A.TRANSACTIONS_AMOUNT --A.TRANSACTIONS_fee,  
			,CASE 
				WHEN TRANSACTIONS_TYPE IN ('FFB')
					THEN ISNULL(convert(MONEY, (A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Initial_Billing, 1) / 100)), 0.00)
				WHEN Transactions_Type IN ('EXP')
					THEN isnull(convert(MONEY, (A.TRANSACTIONS_AMOUNT * 1)), 0.00)
						--when  Transactions_Type in ('CRED')  
						--then isnull(convert(money,(A.TRANSACTIONS_AMOUNT * -1)),0.00)  
				END AS TRANSACTIONS_fee
			,A.TRANSACTIONS_DATE
			,ISNULL(A.ChequeNo, '') + ISNULL(A.TRANSACTIONS_dESCRIPTION, '') AS TRANSACTIONS_dESCRIPTION
			,A.TRANSACTIONS_ID
			,CASE 
				WHEN Vendor_Fee_Type = 'Flat Fee'
					AND Transactions_Id = (
						SELECT TOP 1 Transactions_Id
						FROM tblTransactions WITH (NOLOCK)
						WHERE Case_Id = A.Case_Id
							AND Transactions_Type IN (
								'FFB'
								,'EXP'
								)
							AND (
								A.Case_Id NOT IN (
									SELECT Case_Id
									FROM tblTransactions WITH (NOLOCK)
									WHERE Transactions_status = 'FREEZED'
										AND Transactions_Type IN (
											'FFB'
											,'EXP'
											)
									)
								)
							AND (
								TRANSACTIONS_STATUS IS NULL
								OR TRANSACTIONS_STATUS = 'CONFIRMED'
								)
						ORDER BY Transactions_Id
						)
					THEN CASE 
							WHEN @domainid = 'BT'
								THEN (
										CASE 
											WHEN EXISTS (
													SELECT TOP 1 case_id
													FROM Billing_Packet WITH (NOLOCK)
													WHERE Packeted_Case_ID = B.case_id
													)
												THEN (
														SELECT sum(ISNULL(Vendor_Fee, 0.00))
														FROM tblCase cas
														INNER JOIN tblprovider TS ON cas.provider_id = TS.Provider_id
															AND cas.case_id IN (
																SELECT case_id
																FROM Billing_Packet WITH (NOLOCK)
																WHERE Packeted_Case_ID = B.case_id
																	AND case_id NOT IN (
																		SELECT case_id
																		FROM tblTransactions WITH (NOLOCK)
																		WHERE Transactions_status = 'FREEZED'
																		)
																)
														WHERE cas.provider_id = TS.Provider_id
															AND cas.DomainId = 'BT'
														)
											WHEN EXISTS (
													SELECT TOP 1 case_id
													FROM Billing_Packet WITH (NOLOCK)
													WHERE Case_Id = B.case_id
														AND Packeted_Case_ID IN (
															SELECT Case_ID
															FROM tbltransactions WITH (NOLOCK)
															WHERE Transactions_Type IN (
																	'FFB'
																	,'EXP'
																	)
															)
														AND (
															TRANSACTIONS_STATUS IS NULL
															OR TRANSACTIONS_STATUS = 'CONFIRMED'
															)
													)
												THEN 0.00
											ELSE ISNULL(Vendor_Fee, 0.00)
											END
										)
							ELSE ISNULL(Vendor_Fee, 0.00)
							END
				WHEN (
						Vendor_Fee_Type = '%'
						OR NOT EXISTS (
							SELECT TOP 1 *
							FROM tblprovider_slabs
							WHERE providerid = B.Provider_id
							)
						)
					AND Transactions_Id = (
						SELECT TOP 1 Transactions_Id
						FROM tblTransactions WITH (NOLOCK)
						WHERE Case_Id = A.Case_Id
							AND Transactions_Type IN (
								'FFB'
								,'EXP'
								)
							AND (
								A.Case_Id NOT IN (
									SELECT Case_Id
									FROM tblTransactions WITH (NOLOCK)
									WHERE Transactions_status = 'FREEZED'
										AND Transactions_Type IN (
											'FFB'
											,'EXP'
											)
									)
								)
							AND (
								TRANSACTIONS_STATUS IS NULL
								OR TRANSACTIONS_STATUS = 'CONFIRMED'
								)
						ORDER BY Transactions_Id
						)
					THEN ISNULL(ABS(ISNULL(convert(MONEY, (A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee, 0.00) / 100)), 0.00)), 0.00)
				WHEN Vendor_Fee_Type = 'Slab Based'
					THEN ISNULL(CASE 
								WHEN (
										SELECT TOP 1 AmountType
										FROM tblprovider_slabs
										WHERE providerid = B.Provider_id
										) = 0
									THEN (
											CASE 
												WHEN EXISTS (
														SELECT TOP 1 case_id
														FROM Billing_Packet WITH (NOLOCK)
														WHERE Packeted_Case_ID = B.case_id
														)
													THEN
														(
															SELECT ISNULL(Vendorfee, 0.00)
															FROM tblprovider_slabs
															WHERE providerid = B.Provider_id
																AND Settlement_Amount > = slabfrom
																AND Settlement_Amount <= slabto
															)
												END
											)
								ELSE (
										CASE 
											WHEN EXISTS (
													SELECT TOP 1 case_id
													FROM Billing_Packet WITH (NOLOCK)
													WHERE Packeted_Case_ID = B.case_id
													)
												THEN (
														SELECT sum(ISNULL(Vendorfee, 0.00))
														FROM tblCase cas
														INNER JOIN tblprovider_slabs TS ON cas.provider_id = TS.Providerid
															AND cas.case_id IN (
																SELECT case_id
																FROM Billing_Packet WITH (NOLOCK)
																WHERE Packeted_Case_ID = B.case_id
																	AND case_id NOT IN (
																		SELECT case_id
																		FROM tblTransactions WITH (NOLOCK)
																		WHERE Transactions_status = 'FREEZED'
																		)
																)
														WHERE providerid = B.Provider_id
															AND Claim_Amount > = slabfrom
															AND Claim_Amount <= slabto
														)
											WHEN EXISTS (
													SELECT TOP 1 case_id
													FROM Billing_Packet WITH (NOLOCK)
													WHERE Case_Id = B.case_id
														AND Packeted_Case_ID IN (
															SELECT Case_ID
															FROM tbltransactions WITH (NOLOCK)
															WHERE Transactions_Type IN (
																	'FFB'
																	,'EXP'
																	)
															)
														AND (
															TRANSACTIONS_STATUS IS NULL
															OR TRANSACTIONS_STATUS = 'CONFIRMED'
															)
													)
												THEN 0.00
											ELSE (
													SELECT ISNULL(Vendorfee, 0.00)
													FROM tblprovider_slabs
													WHERE providerid = B.Provider_id
														AND Claim_Amount > = slabfrom
														AND Claim_Amount <= slabto
													)
											END
										)
								END, 0.00)
				WHEN Vendor_Fee_Type IS NULL
					THEN 0.00
				ELSE 0.00
				END AS VENDOR_FEE
			,Vendor_Fee_Type
		--, Initial_Status  
		--, Provider_Initial_Billing  
		FROM tbltransactions(NOLOCK) A
		INNER JOIN tblcase(NOLOCK) B ON A.Case_Id = B.Case_Id
		INNER JOIN tblStatus(NOLOCK) sts ON B.STATUS = sts.Status_Type
		INNER JOIN tblprovider(NOLOCK) C ON C.Provider_Id = B.Provider_Id
		INNER JOIN tblInsuranceCompany(NOLOCK) ins ON ins.InsuranceCompany_Id = B.InsuranceCompany_Id
		LEFT JOIN tblSettlements(NOLOCK) Sett ON sett.Case_Id = A.Case_Id
		WHERE A.PROVIDER_ID = @Client_id
			AND (
				TRANSACTIONS_STATUS IS NULL
				OR TRANSACTIONS_STATUS = 'CONFIRMED'
				)
			AND B.DomainId = @DomainId
			AND TRANSACTIONS_TYPE IN (
				'FFB'
				,'EXP'
				)
			AND sts.Final_Status = 'Closed_L'
		)
	SELECT DISTINCT provider_id
		,Transactions_Id
		,provider_name
		,ACT_NO
		,CASE_ID
		,CASE_CODE
		,INJUREDPARTY_NAME
		,INSURANCECOMPANY_NAME
		,ACCIDENT_DATE
		,DATEOFSERVICE_START
		,DATEOFSERVICE_END
		,FEE_sCHEDULE
		,CLAIM_AMOUNT
		,TRANSACTIONS_TYPE
		,TRANSACTIONS_AMOUNT
		,ISNULL(TRANSACTIONS_fee, 0.00) AS TRANSACTIONS_fee
		,TRANSACTIONS_DATE
		,TRANSACTIONS_dESCRIPTION
		,TRANSACTIONS_ID
		,
		--case when  ROWNUM =1  
		--THEN VENDOR_FEE ELSE  0 end as VENDOR_FEE
		CASE 
			WHEN Vendor_Fee_Type = 'Flat Fee'
				OR Vendor_Fee_Type = '%'
				THEN ISNULL(VENDOR_FEE, 0.00)
			WHEN Vendor_Fee_Type = 'Slab Based'
				AND ROWNUM > 1
				THEN 0
			ELSE ISNULL(VENDOR_FEE, 0.00)
			END AS VENDOR_FEE
	FROM CTE
END
