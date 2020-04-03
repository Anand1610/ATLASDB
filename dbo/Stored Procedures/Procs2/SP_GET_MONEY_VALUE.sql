CREATE PROCEDURE [dbo].[SP_GET_MONEY_VALUE]    --      [SP_GET_MONEY_VALUE]     '40392'
@PROVIDER_ID NVARCHAR(100),
@STATUS NVARCHAR(50)=NULL
AS
BEGIN
IF @STATUS IS NULL
BEGIN

	SELECT TBLCASE.Provider_Id,TBLCASE.STATUS,COUNT(DISTINCT TBLCASE.CASE_ID) AS [CNT],SUM(TBLTREATMENT.CLAIM_AMOUNT) AS [AMOUNT_BILLED]
	FROM TBLCASE 
	INNER JOIN
	TBLTREATMENT ON TBLCASE.CASE_ID = TBLTREATMENT.CASE_ID
	INNER JOIN tblStatus ON tblStatus.Status_Type=TBLCASE.Status
	WHERE PROVIDER_ID=@PROVIDER_ID
	AND
	TBLCASE.status not in ('CLOSED','Closed Arbitration','Closed AS per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','PENDing','Open-Old','Trial Lost') 
	GROUP BY STATUS,tblStatus.hierarchy_Id,tblStatus.forum,TBLCASE.Provider_Id ORDER BY tblStatus.hierarchy_Id,tblStatus.forum ASC
END
ELSE
BEGIN
	SELECT TBLCASE.Provider_Id,TBLCASE.STATUS,COUNT(DISTINCT TBLCASE.CASE_ID) AS [CNT],SUM(TBLTREATMENT.CLAIM_AMOUNT) AS [AMOUNT BILLED]
	FROM TBLCASE 
	INNER JOIN
	TBLTREATMENT ON TBLCASE.CASE_ID = TBLTREATMENT.CASE_ID
	INNER JOIN tblStatus ON tblStatus.Status_Type=TBLCASE.Status
	WHERE PROVIDER_ID=@PROVIDER_ID AND TBLCASE.STATUS=@STATUS AND
	TBLCASE.status not in ('CLOSED','Closed Arbitration','Closed AS per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','PENDing','Open-Old','Trial Lost') 
	GROUP BY STATUS,tblStatus.hierarchy_Id,tblStatus.forum,TBLCASE.Provider_Id ORDER BY tblStatus.hierarchy_Id,tblStatus.forum ASC
END

END

