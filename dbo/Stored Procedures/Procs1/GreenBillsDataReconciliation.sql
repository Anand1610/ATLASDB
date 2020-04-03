CREATE PROCEDURE GreenBillsDataReconciliation
AS
BEGIN
	
	DECLARE @tblReconcilationData AS TABLE
	(
		DomainID VARCHAR(40),
		Case_ID VARCHAR(40),
		Bill_number VARCHAR(40),
		Collected_C MONEY,
		Collected_I MONEY,
		Collected_PreC MONEY,
		Collected_PreI MONEY,
		Transactions_Date DATETIME
	)
		---- Main Query Here 

	INSERT INTO @tblReconcilationData
			Select
					DomainID = tre.DomainID,
					Case_ID = MIN(tre.Case_id) , 
					Bill_Number = tre.Bill_number,
					Collected_C = SUM(CASE WHEN tre.Claim_amount- tre.Paid_Amount > 0 THEN (Transactions_Amount_C * (tre.Claim_amount- tre.Paid_Amount))/ ClaimBalance ELSE 0 END),
					Collected_I = SUM(CASE WHEN tre.Claim_amount- tre.Paid_Amount > 0 THEN (Transactions_Amount_I * (tre.Claim_amount- tre.Paid_Amount))/ ClaimBalance ELSE 0 END),
					Collected_PreC = SUM(CASE WHEN tre.Claim_amount- tre.Paid_Amount > 0 THEN (Transactions_Amount_PreC * (tre.Claim_amount- tre.Paid_Amount))/ ClaimBalance ELSE 0 END),
					Collected_PreI = SUM(CASE WHEN tre.Claim_amount- tre.Paid_Amount > 0 THEN (Transactions_Amount_PreI * (tre.Claim_amount- tre.Paid_Amount))/ ClaimBalance ELSE 0 END),
					Transactions_Date = MAX(Transactions_Date )
			FROM
			 tblTreatment tre 
			 LEFT OUTER JOIN		(
					Select DomainId,
							Case_id , 
							Transactions_Amount_C=Case When Transactions_Type ='C' THEN Transactions_Amount ELSE 0 END,
							Transactions_Amount_I=Case When Transactions_Type ='I' THEN Transactions_Amount ELSE 0 END,
							Transactions_Amount_PreC=Case When Transactions_Type ='PreC' THEN Transactions_Amount ELSE 0 END,
							Transactions_Amount_PreI=Case When Transactions_Type ='PreI' THEN Transactions_Amount ELSE 0 END,		 
							Transactions_Type,
							Transactions_Date,
							ClaimBalance = (Select SUM(Claim_Amount - Paid_Amount) from tblTreatment (nolock) where case_id = tt.case_id AND Claim_Amount > Paid_Amount)
			             
					from tbltransactions (NOLOCK) tt
					WHERE Transactions_Type IN ('C','I','PreC','PreI')
					) t
			
			ON  t.Case_id = tre.Case_Id  and t.DomainId = tre.DomainId
			Group by tre.DomainID, --tre.Case_Id , 
			tre.Bill_number 
	

	UPDATE XN
	SET AtlasCaseID = Case_ID,
			AtlasPrincipalAmountCollected = Collected_C,
			AtlasInterestAmountCollected = Collected_I,
			AtlasLastTransactionDate = Transactions_Date,
			IsDataSyncedtoGYB = 0	
	from XN_TEMP_GBB_ALL XN
	JOIN @tblReconcilationData Rec on  XN.DomainID = Rec.DomainId and XN.BillNumber = Rec.Bill_Number
	WHERE (AtlasCaseID <>Rec.CASE_ID OR AtlasCaseID IS NULL
	OR  AtlasPrincipalAmountCollected <> Collected_C 
	OR  AtlasInterestAmountCollected <> Collected_I)
	

	UPDATE XN
	SET AtlasCaseIndexNumber = IndexOrAAA_Number,
		AtlasCaseStatus = Status,
		IsDataSyncedtoGYB = 0
	FROM XN_TEMP_GBB_ALL XN
	JOIN tblcase cas ON XN.AtlasCaseID = cas.Case_ID AND XN.DomainID = XN.DomainID
	WHERE AtlasCaseIndexNumber <> cas.IndexOrAAA_Number
	OR AtlasCaseStatus <> Status
	--OR AtlasCaseIndexNumber IS NuLL
	--OR AtlasCaseStatus IS NULL
	
	
END
