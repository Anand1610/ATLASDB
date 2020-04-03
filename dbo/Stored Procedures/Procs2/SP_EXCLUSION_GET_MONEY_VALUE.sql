CREATE PROCEDURE [dbo].[SP_EXCLUSION_GET_MONEY_VALUE]
@PROVIDER_ID NVARCHAR(100),
@STATUS NVARCHAR(50)=NULL
AS
BEGIN
IF @STATUS IS NULL
BEGIN

	SELECT TBLCASE.STATUS,COUNT(DISTINCT TBLCASE.CASE_ID) AS [CNT],SUM(TBLTREATMENT.CLAIM_AMOUNT) AS [AMOUNT BILLED]
	FROM TBLCASE 
	INNER JOIN
	TBLTREATMENT ON TBLCASE.CASE_ID = TBLTREATMENT.CASE_ID
	INNER JOIN tblStatus ON tblStatus.Status_Type=TBLCASE.Status
	WHERE PROVIDER_ID=@PROVIDER_ID
	AND
	TBLCASE.status in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost') 
	GROUP BY STATUS,tblStatus.hierarchy_Id,tblStatus.forum ORDER BY tblStatus.hierarchy_Id,tblStatus.forum ASC

END
ELSE
BEGIN
	SELECT TBLCASE.STATUS,COUNT(DISTINCT TBLCASE.CASE_ID) AS [CNT],SUM(TBLTREATMENT.CLAIM_AMOUNT) AS [AMOUNT BILLED]
	FROM TBLCASE 
	INNER JOIN
	TBLTREATMENT ON TBLCASE.CASE_ID = TBLTREATMENT.CASE_ID
	INNER JOIN tblStatus ON tblStatus.Status_Type=TBLCASE.Status
	WHERE PROVIDER_ID=@PROVIDER_ID AND TBLCASE.STATUS=@STATUS AND
	TBLCASE.status in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost') 
	GROUP BY STATUS,tblStatus.hierarchy_Id,tblStatus.forum ORDER BY tblStatus.hierarchy_Id,tblStatus.forum ASC
END

END

