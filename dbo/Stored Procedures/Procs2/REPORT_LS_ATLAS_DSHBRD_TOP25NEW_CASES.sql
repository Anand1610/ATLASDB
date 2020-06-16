CREATE PROCEDURE REPORT_LS_ATLAS_DSHBRD_TOP25NEW_CASES AS
 
BEGIN

SELECT 
DomainId,Case_Id,Provider_Id,Provider_Name,Claim_Amount,Paid_Amount,
Date_Opened,TOP25_NC_RNK FROM(
SELECT 
C.DomainId,Case_Id,A.Provider_Id,C.Provider_Name,Claim_Amount,Paid_Amount,
Date_Opened,RANK () OVER (ORDER BY Date_Opened DESC)TOP25_NC_RNK
from tblcase A
JOIN tblProvider C ON A.Provider_Id = C.Provider_Id
--WHERE Date_Opened BETWEEN (GETDATE()-30) AND GETDATE()
--ORDER BY Date_Opened
)A
WHERE TOP25_NC_RNK <= 25
ORDER BY TOP25_NC_RNK ASC

END