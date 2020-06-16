CREATE PROCEDURE P_INS_tblCASEID_AGE_DETAILS AS
 
BEGIN


SELECT * INTO #TABA FROM(
SELECT 
DENSE_RANK() OVER (PARTITION BY Case_Id Order By Case_Id,B.Audit_TimeStamp)D_RNK,
RANK() OVER ( Order By Case_Id,B.Audit_TimeStamp)RNK,B.*,CAST(NULL AS DATETIME)SECOND_DT
FROM tbl_Case_Status_Hierarchy B
)A;


UPDATE #TABA
SET    SECOND_DT =NULL;


UPDATE A
SET    A.SECOND_DT = B.Audit_TimeStamp 
FROM   #TABA A,#TABA B
WHERE  A.RNK + 1 = B.RNK;


TRUNCATE TABLE tblCaseID_Age_Details;

--SELECT * FROM tblCaseID_Age_Details

INSERT INTO tblCaseID_Age_Details
SELECT 
A.DomainID,A.Case_id,A.Case_Auto_Id,Provider_Id,Provider_Name,Audit_TimeStamp,AVG_AGE,CAST(0 AS INTEGER )AVG_AGE_PRD,
CAST(0 AS INTEGER )AVG_AGE_STS,MONTH_Opened,Year_Opened,
DENSE_RANK() OVER (PARTITION BY Provider_Id Order By Audit_TimeStamp)D_RNK,
RANK() OVER ( Order By Audit_TimeStamp)RNK,
CASE WHEN MONTH_Opened IN ('Apr','May','Jun') THEN 'Q1'
     WHEN MONTH_Opened IN ('Jul','Aug','Sep') THEN 'Q2'
	 WHEN MONTH_Opened IN ('Oct','Nov','Dec') THEN 'Q3'
	 WHEN MONTH_Opened IN ('Jan','Feb','Mar') THEN 'Q4'
	 ELSE NULL END AS [QUARTER] FROM(
SELECT 
A.DomainID,A.Case_id,A.Case_Auto_Id,Provider_Id,Provider_Name,Audit_TimeStamp,AVG_AGE,
Convert(char(3), Audit_TimeStamp, 0)[MONTH_Opened],
YEAR(Audit_TimeStamp)[Year_Opened]FROM(
SELECT 
A.DomainID,A.Case_id,A.Case_Auto_Id,D.Provider_Id,D.Provider_Name,Audit_TimeStamp,AVG_AGE
FROM #TABA A
 JOIN (
SELECT A.Case_id,AVG_AGE,MIN(D_RNK)D_RNK
FROM #TABA A
LEFT JOIN ( SELECT Case_id,AVG(N_DAYS)AVG_AGE FROM(
			SELECT 
			D_RNK,RNK,DomainID,[status],Case_id,Case_Auto_Id,Audit_Command,Audit_TimeStamp,[USER_NAME],SECOND_DT,N_DAYS FROM(
			SELECT 
			A.*,DateDiff(dd,Audit_TimeStamp,SECOND_DT)N_DAYS
			FROM #TABA A 
			)A
			WHERE N_DAYS >0
			)A 
			GROUP BY Case_id
		  )AB ON A.Case_id = AB.Case_id
WHERE    A.Case_Auto_Id IS NOT NULL
GROUP BY A.Case_id,AVG_AGE
)DD ON A.Case_id = DD.Case_id AND A.D_RNK = DD.D_RNK
LEFT JOIN tblcase B ON A.Case_Auto_Id =B.Case_AutoId
LEFT JOIN tblProvider D ON B.Provider_Id = D.Provider_Id
WHERE AVG_AGE IS NOT NULL
)A
)A;


DELETE FROM tblCaseID_Age_Details 
WHERE Provider_Name IS NULL;


UPDATE A
SET    A.AVG_AGE_PRD = B.AVG_AGE_P 
FROM   tblCaseID_Age_Details A
LEFT JOIN ( SELECT 
			Provider_Id,AVG(AVG_AGE)AVG_AGE_P 
			FROM tblCaseID_Age_Details 
			GROUP BY Provider_Id)B ON A.Provider_Id = B.Provider_Id
WHERE  A.D_RNK = 1;


UPDATE A
SET    A.AVG_AGE_PRD = 0 
FROM   tblCaseID_Age_Details A
WHERE  A.AVG_AGE_PRD IS NULL;


------------------------------------------------------------------------------------------------------


TRUNCATE TABLE tblStatusWise_CaseID_CNT;


INSERT INTO tblStatusWise_CaseID_CNT
SELECT 
DomainId,Year_Opened,[QUARTER],MONTH_Opened,Initial_Status,[Status],COUNT(DISTINCT Case_Id)CASE_COUNT
FROM(
SELECT 
DomainId,Case_Id,Provider_Id,Provider_Name,SUM(Claim_AMT)Claim_AMNT,SUM(Paid_AMT)Paid_AMNT,Initial_Status,[Status],MONTH_Opened,Year_Opened,[QUARTER],GET_MNTH_FLG
FROM(
SELECT 
DomainId,Case_Id,Provider_Id,Provider_Name,Claim_AMT,Paid_AMT,Initial_Status,[Status],MONTH_Opened,Year_Opened,
CASE WHEN MONTH_Opened IN ('Apr','May','Jun') THEN 'Q1'
     WHEN MONTH_Opened IN ('Jul','Aug','Sep') THEN 'Q2'
	 WHEN MONTH_Opened IN ('Oct','Nov','Dec') THEN 'Q3'
	 WHEN MONTH_Opened IN ('Jan','Feb','Mar') THEN 'Q4'
	 ELSE NULL END AS [QUARTER],
CASE WHEN Date_Opened BETWEEN (GETDATE()-30) AND GETDATE() THEN 1 ELSE NULL END AS GET_MNTH_FLG
FROM(
SELECT 
C.DomainId,Case_Id,A.Provider_Id,C.Provider_Name,SUM(Claim_Amount)Claim_AMT,SUM(Paid_Amount)Paid_AMT,Initial_Status,[Status],Date_Opened,
--RANK () OVER (ORDER BY SUM(Claim_Amount) DESC) Claim_AMT_RNK,
Convert(char(3), Date_Opened, 0)[MONTH_Opened],
YEAR(Date_Opened)[Year_Opened]
from tblcase A
JOIN tblProvider C ON A.Provider_Id = C.Provider_Id
WHERE Date_Opened BETWEEN (GETDATE()-720) AND GETDATE()
GROUP BY C.DomainId,Case_Id,A.Provider_Id,C.Provider_Name,Date_Opened,Convert(char(3), Date_Opened, 0),YEAR(Date_Opened),Initial_Status,[Status]
)A
)A
--WHERE GET_MNTH_FLG = 1
GROUP BY DomainId,Case_Id,Provider_Id,Provider_Name,Initial_Status,[Status],MONTH_Opened,Year_Opened,[QUARTER],GET_MNTH_FLG
)A
GROUP BY DomainId,Year_Opened,[QUARTER],MONTH_Opened,Initial_Status,[Status];


/*
SELECT TOP 50 * FROM tblCaseID_Age_Details
SELECT 
Year_Opened,[QUARTER],MONTH_Opened,Provider_Name,AVG(AVG_AGE)AVG_AGE
FROM(
SELECT 
Year_Opened,MONTH_Opened,Provider_Name,COUNT(DISTINCT Case_id)CASE_CNT,AVG(AVG_AGE)AVG_AGE
FROM tblCaseID_Age_Details
GROUP BY Year_Opened,MONTH_Opened,Provider_Name
)A
--WHERE AVG_AGE IS NULL
ORDER BY Year_Opened,MONTH_Opened ASC, CASE_CNT DESC
*/

/*
SELECT 
Year_Opened,COUNT(DISTINCT Provider_Name)PRVDR_CNT
FROM tblCaseID_Age_Details
GROUP BY Year_Opened
*/


------------------------------------------------------------------------------------------------------------------------------------


SELECT * INTO #TABB FROM(
SELECT 
DENSE_RANK() OVER (PARTITION BY Case_Id Order By Case_Id,B.Audit_TimeStamp)D_RNK,
RANK() OVER ( Order By Case_Id,B.Audit_TimeStamp)RNK,B.*,CAST(NULL AS DATETIME)SECOND_DT
FROM tbl_Case_Status_Hierarchy B
)A;
--SELECT TOP 2 * FROM #TABB


UPDATE #TABB
SET    SECOND_DT =NULL;


UPDATE A
SET    A.SECOND_DT = B.Audit_TimeStamp 
FROM   #TABB A,#TABB B
WHERE  A.RNK + 1 = B.RNK;


--select * from tblStatusWise_Age_Details


TRUNCATE TABLE tblStatusWise_Age_Details;


--ALTER TABLE tblStatusWise_Age_Details ADD U_ROWID int NOT NULL IDENTITY PRIMARY KEY

INSERT INTO tblStatusWise_Age_Details
(DomainID,Case_id,Case_Auto_Id,Provider_Id,Provider_Name,status,Audit_TimeStamp,N_DAYS,
N_DAYS_PRD,Days_OverAll,N_DAYS_STS,MONTH_Opened,Year_Opened,[QUARTER],D_RNK,RNK)
SELECT
A.DomainID,A.Case_id,A.Case_Auto_Id,Provider_Id,Provider_Name,A.[status],Audit_TimeStamp,N_DAYS,CAST(0 AS INTEGER )N_DAYS_PRD,CAST(0 AS INTEGER )Days_OverAll,
CAST(0 AS INTEGER )N_DAYS_STS,MONTH_Opened,Year_Opened,
CASE WHEN MONTH_Opened IN ('Apr','May','Jun') THEN 'Q1'
     WHEN MONTH_Opened IN ('Jul','Aug','Sep') THEN 'Q2'
	 WHEN MONTH_Opened IN ('Oct','Nov','Dec') THEN 'Q3'
	 WHEN MONTH_Opened IN ('Jan','Feb','Mar') THEN 'Q4'
	 ELSE NULL END AS [QUARTER], 
DENSE_RANK() OVER (PARTITION BY Provider_Id Order By Audit_TimeStamp)D_RNK,
RANK() OVER ( Order By Audit_TimeStamp)RNK
FROM(
SELECT 
A.DomainID,A.Case_id,A.Case_Auto_Id,Provider_Id,Provider_Name,A.[status],Audit_TimeStamp,N_DAYS,
Convert(char(3), Audit_TimeStamp, 0)[MONTH_Opened],
YEAR(Audit_TimeStamp)[Year_Opened]FROM(
SELECT 
A.DomainID,A.Case_id,A.Case_Auto_Id,D.Provider_Id,D.Provider_Name,A.[status],A.Audit_TimeStamp,N_DAYS
FROM #TABB A
 JOIN (
SELECT 
			D_RNK,RNK,DomainID,[status],Case_id,Case_Auto_Id,Audit_Command,Audit_TimeStamp,[USER_NAME],SECOND_DT,N_DAYS FROM(
			SELECT 
			A.*,DateDiff(dd,Audit_TimeStamp,SECOND_DT)N_DAYS
			FROM #TABB A --WHERE   A.Case_id = 'ACT-AF-107217'
			)A
			WHERE N_DAYS >0 --AND Case_id = 'ACT-AF-107217'
			)DD ON A.Case_id = DD.Case_id AND A.D_RNK = DD.D_RNK
LEFT JOIN tblcase B ON A.Case_Auto_Id =B.Case_AutoId
LEFT JOIN tblProvider D ON B.Provider_Id = D.Provider_Id
)A --WHERE A.Case_id = 'ACT-AF-107217'
)A;

--SELECT COUNT(*),MAX(U_ROWID) FROM tblStatusWise_Age_Details


UPDATE A
SET    A.N_DAYS_PRD = B.N_DAYS_P 
FROM   tblStatusWise_Age_Details A
LEFT JOIN ( SELECT 
			Provider_Name,AVG(N_DAYS)N_DAYS_P,MIN(U_ROWID)U_ROWID 
			FROM tblStatusWise_Age_Details
			GROUP BY Provider_Name)B ON A.Provider_Name = B.Provider_Name AND A.U_ROWID = B.U_ROWID;


UPDATE A
SET    A.Days_OverAll = (select AVG(N_DAYS_PRD)N_DAYS_PRD
                         from  tblStatusWise_Age_Details
                         WHERE N_DAYS_PRD >0)
FROM   tblStatusWise_Age_Details A
WHERE  N_DAYS_PRD >0;


UPDATE A
SET    A.N_DAYS_STS = C.N_DAYS_ST 
FROM   tblStatusWise_Age_Details A
JOIN ( SELECT 
	   [status],MIN(U_ROWID)U_ROWID,AVG(N_DAYS)N_DAYS_ST 
	   FROM tblStatusWise_Age_Details
	   GROUP BY [status])C ON A.U_ROWID = C.U_ROWID;


/*
SELECT * FROM tblStatusWise_Age_Details
WHERE Case_id = 'ACT-AF-107217'
SELECT * FROM tblCaseID_Age_Details
WHERE Case_id = 'ACT-AF-107217'
SELECT * FROM tblStatusWise_Age_Details
WHERE N_DAYS_STS IS NOT NULL
SELECT * FROM tblStatusWise_Age_Details
WHERE status  = 'AAA - FILED'
*/

/*
SELECT * FROM tblStatusWise_Age_Details
WHERE N_DAYS_STS IS NOT NULL
SELECT * FROM tblStatusWise_Age_Details
WHERE status  = 'AAA - REJECT - RETURN TO CLIENT - LOW CLAIM AMT'
SELECT * FROM tblStatusWise_Age_Details
WHERE Provider_NAme = 'CROSSTOWN MEDICAL P.C.' 
AND   N_DAYS_PRD >0
*/

END
