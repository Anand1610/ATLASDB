CREATE PROCEDURE DSH_LS_DTLS AS
 
BEGIN

SELECT 
C.DomainId,A.Case_Id,A.Provider_Id,C.Provider_Name,A.InsuranceCompany_Id,AA.InsuranceCompany_Name,
ISNULL(Claim_Amount,0)Claim_Amount,ISNULL(Paid_Amount,0)Paid_Amount,ISNULL(Settlement_AMT,0)Settlement_Amount,Initial_Status,
[Status],Date_Opened,Court_Name,Court_Venue,SettlementType_Id,Settlement_Type,DenialReasons_Type,
ISNULL(PreLit_Amt,0)PreLit_Amt,ISNULL(PostLit_Amt,0)PostLit_Amt,
Date_Index_Number_Purchased,Pre_Transactions_Date,Post_Transactions_Date,
ISNULL(DateDiff(dd,Pre_Transactions_Date,Date_Index_Number_Purchased),0)Pre_LIT_Days,
ISNULL(DateDiff(dd,Date_Index_Number_Purchased,Post_Transactions_Date),0)Post_LIT_Days,
CONCAT(Attorney_FirstName, ' ', Attorney_LastName) AS Attorney_Name,
RANK () OVER (ORDER BY Date_Opened DESC)RNK_BY_DT,
RANK () OVER (PARTITION BY C.DomainId ORDER BY Date_Opened DESC)D_RNK_BY_DT,RNK_BY_INS_C
from tblcase A
JOIN tblProvider C ON A.Provider_Id = C.Provider_Id
JOIN tblInsuranceCompany D ON A.InsuranceCompany_Id = D.InsuranceCompany_Id
LEFT JOIN ( SELECT 
			A.InsuranceCompany_Id,D.InsuranceCompany_Name,COUNT(Case_Id)CASE_CNT,
			RANK () OVER (ORDER BY COUNT(Case_Id) DESC)RNK_BY_INS_C 
			FROM tblcase A
			JOIN tblProvider C ON A.Provider_Id = C.Provider_Id
			JOIN tblInsuranceCompany D ON A.InsuranceCompany_Id = D.InsuranceCompany_Id
			WHERE Date_Opened BETWEEN (GETDATE()-1095) AND GETDATE()
			GROUP BY A.InsuranceCompany_Id,D.InsuranceCompany_Name 
			)AA ON A.InsuranceCompany_Id = AA.InsuranceCompany_Id
LEFT JOIN tblCourt E ON A.Court_Id = E.Court_Id
LEFT JOIN tblAttorney EA ON A.Attorney_Id = CAST(EA.Attorney_AutoId AS VARCHAR(50))
LEFT JOIN (SELECT 
           DISTINCT Case_Id,SettlementType_Id,Settlement_Type
           FROM tblSettlements,tblSettlement_type
		   WHERE Settled_Type = SettlementType_Id)F ON A.Case_Id = F.Case_Id
LEFT JOIN (SELECT 
			A.Case_Id,SUM(Settlement_Total)Settlement_AMT
			FROM tblcase A
			JOIN tblProvider C ON A.Provider_Id = C.Provider_Id
			JOIN tblInsuranceCompany D ON A.InsuranceCompany_Id = D.InsuranceCompany_Id
			JOIN tblsettlements E ON A.Case_Id = E.Case_Id
			WHERE Date_Opened BETWEEN (GETDATE()-1095) AND GETDATE()
			GROUP BY A.Case_Id
			)G ON A.Case_Id = G.Case_Id
LEFT JOIN (SELECT 
			A.Case_Id,
			SUM(CASE WHEN Transactions_Type = 'PreC' THEN Transactions_Amount ELSE 0 END)PreLit_Amt,
			SUM(CASE WHEN Transactions_Type IN ('C','I') THEN Transactions_Amount ELSE 0 END)PostLit_Amt,
			MIN(CASE WHEN Transactions_Type = 'PreC' THEN Transactions_Date ELSE NULL END)Pre_Transactions_Date,
			MAX(CASE WHEN Transactions_Type IN ('C','I') THEN Transactions_Date ELSE NULL END)Post_Transactions_Date
			FROM tblcase A
			JOIN tblProvider C ON A.Provider_Id = C.Provider_Id
			JOIN tblInsuranceCompany D ON A.InsuranceCompany_Id = D.InsuranceCompany_Id
			JOIN tbltransactions E ON A.Case_Id = E.Case_Id
			WHERE Date_Opened BETWEEN (GETDATE()-1095) AND GETDATE()
			GROUP BY A.Case_Id
			)H ON A.Case_Id = H.Case_Id
WHERE Date_Opened BETWEEN (GETDATE()-1095) AND GETDATE()
ORDER BY RANK () OVER (ORDER BY Date_Opened DESC)

END