CREATE FUNCTION [dbo].[SJR-ENTRY_PROD_2](@START_DATE nvarchar(50),
@END_DATE nvarchar(50))
RETURNS TABLE
AS
RETURN ( SELECT     tblNotes.User_Id, COUNT(DISTINCT tblcase.Case_Id) AS Cases, SUM(tblTreatment_1.Bills) AS Bills,
     SUM(CONVERT(MONEY,ISNULL(TBLCASE.CLAIM_AMOUNT,0)) - CONVERT(MONEY,ISNULL(TBLCASE.PAID_AMOUNT,0)))AS BALANCE,tblcase.date_opened as DATE,
@start_date 'START_DATE' , @END_DATE 'END_DATE'
FROM         tblcase INNER JOIN
                      tblNotes ON tblcase.Case_Id = tblNotes.Case_Id LEFT OUTER JOIN
                      (SELECT CASE_ID as CASE_IDX ,COUNT(TREATMENT_ID)AS Bills FROM tblTreatment group BY CASE_ID)AS tblTreatment_1  ON tblcase.Case_Id = tblTreatment_1.Case_Idx
WHERE     (tblNotes.Notes_Desc = N'CASE OPENED') AND tblcase.Date_Opened BETWEEN @START_DATE AND @END_DATE
GROUP BY tblNotes.User_Id,tblcase.date_opened
)
