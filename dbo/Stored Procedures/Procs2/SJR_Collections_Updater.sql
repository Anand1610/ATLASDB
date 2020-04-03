-- =============================================
-- Author:		<Serge Rosenthal
-- Create date: <11/15/2007>
-- Description:	<Update SP for cases that need to be transferred to Collections>
-- =============================================
CREATE PROCEDURE [dbo].[SJR_Collections_Updater] 
	
AS

DECLARE @COUNT INT
CREATE TABLE #TEMPTABLE (CASE_ID VARCHAR(50),CASE_STATUS VARCHAR(50),DomainId varchar(10))
BEGIN
SET NOCOUNT ON;

INSERT INTO #TEMPTABLE
SELECT     tblcase.Case_Id, tblcase.Status,tblcase.DomainId
FROM         tblcase INNER JOIN
                      [SJR-SETTLEMENTS_FULL] ON tblcase.Case_Id = [SJR-SETTLEMENTS_FULL].Case_Id INNER JOIN
                      tblStatus ON tblcase.Status = tblStatus.Status_Type LEFT OUTER JOIN
                      [SJR-SETTLED_PAYMENTS_FULL] ON [SJR-SETTLEMENTS_FULL].Case_Id = [SJR-SETTLED_PAYMENTS_FULL].Case_Id
WHERE     (CONVERT(int, GETDATE() - [SJR-SETTLEMENTS_FULL].Settl_date) > 45) AND tblstatus.status_hierarchy <1000 AND (tblcase.Status LIKE '%SETTLED%' OR
                      tblcase.Status = N'PAID' OR
                      tblcase.Status = N'PAYMENT DISBURSED') AND (ISNULL([SJR-SETTLEMENTS_FULL].Sett_tot, 0) > 0) AND 
                      (ISNULL([SJR-SETTLEMENTS_FULL].Settlement_Amount + [SJR-SETTLEMENTS_FULL].Settlement_Int + [SJR-SETTLEMENTS_FULL].Settlement_Af + [SJR-SETTLEMENTS_FULL].Settlement_Ff,
                       0) - ISNULL([SJR-SETTLED_PAYMENTS_FULL].Payments, 0) > 30)


		SELECT @COUNT = COUNT(CASE_ID) FROM #TEMPTABLE
		
		IF @COUNT > 0
		BEGIN

		SELECT CASE_ID into #temp1
		 FROM #TEMPTABLE t1
		  join tblStatus t2 on t1.CASE_STATUS=t2.Status_Type
		 join tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type='COLLECTION'   
		 WHERE CASE_STATUS NOT LIKE '%AAA SETTLED%' and t3.Status_Hierarchy >= t2.Status_Hierarchy

		UPDATE dbo.TBLCASE 
		SET STATUS = 'COLLECTION'
		,Old_Status=Status,
		Date_Status_Changed = GETDATE()  
		FROM dbo.tblcase 
		 join  #temp1 on  #temp1.CASE_ID=tblcase.Case_Id

		 SELECT CASE_ID into #temp2 FROM #TEMPTABLE t1
		 join tblStatus t2 on t1.CASE_STATUS=t2.Status_Type
		 join tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type='AAA COLLECTION'   
		WHERE CASE_STATUS LIKE '%AAA SETTLED%' and  t3.Status_Hierarchy >= t2.Status_Hierarchy

		UPDATE dbo.TBLCASE 
		SET STATUS = 'AAA COLLECTION' ,Old_Status=Status,Date_Status_Changed = GETDATE()  
		FROM dbo.tblcase  
		join #temp2 on #temp2.CASE_ID=tblcase.Case_Id

		INSERT INTO TBLNOTES (NOTES_DESC,NOTES_TYPE,CASE_ID,NOTES_PRIORITY,USER_ID)
		SELECT 'CASE FLAGGED FOR COLLECTIONS','Activity',CASE_ID , 0,'SYSTEM'
		FROM #temp1
		union all
		SELECT 'CASE FLAGGED FOR COLLECTIONS','Activity',CASE_ID , 0,'SYSTEM'
		FROM #temp2


		END



/*
DELETE FROM TEMPTABLE

INSERT INTO #TEMPTABLE
SELECT     tblcase.Case_Id
FROM         tblcase INNER JOIN
                      [SJR-SETTLEMENTS_FULL] ON tblcase.Case_Id = [SJR-SETTLEMENTS_FULL].Case_Id LEFT OUTER JOIN
                      [SJR-SETTLED_PAYMENTS_FULL] ON [SJR-SETTLEMENTS_FULL].Case_Id = [SJR-SETTLED_PAYMENTS_FULL].Case_Id
WHERE     (tblcase.Status LIKE '%SETTLED%' OR
                      tblcase.Status = N'PAID' OR
                      tblcase.Status = N'PAYMENT DISBURSED') AND (ISNULL([SJR-SETTLEMENTS_FULL].Sett_tot,0) = 0) 

UPDATE dbo.TBLCASE 
		SET STATUS = 'COLLECTION' FROM dbo.tblcase  WHERE CASE_ID IN (SELECT CASE_ID FROM #TEMPTABLE)

		INSERT INTO TBLNOTES (NOTES_DESC,NOTES_TYPE,CASE_ID,NOTES_PRIORITY,USER_ID)
		SELECT 'CASE FLAGGED FOR COLLECTIONS','Activity',CASE_ID , 0,'SYSTEM'
		FROM #TEMPTABLE */

SELECT * FROM #TEMPTABLE
	 
DROP TABLE #TEMPTABLE
DROP TABLE #temp2
DROP TABLE #temp1

END

