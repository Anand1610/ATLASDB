CREATE PROCEDURE [dbo].[LCJ_GetExistingSettlements] 

(
@DomainId NVARCHAR(50),
@Case_Id NVARCHAR(100)

)

AS

--SELECT * from tblSettlements WHERE Case_Id = +@Case_Id

Declare @st as nvarchar(1000)
set @st = 'Select Settlement_Id, ISNULL(Settlement_Amount,0) AS Settlement_Amount, ISNULL(Settlement_Int,0) AS Settlement_Int,
ISNULL(Settlement_Af,0) AS Settlement_Af,ISNULL(Settlement_Ff,0) AS Settlement_Ff,ISNULL(Settlement_Total,0) AS Settlement_Total,
Settlement_Date, Treatment_Id, Case_Id, User_Id, SettledWith,Settlement_Notes,ISNULL(Settlement_Rfund_PR,0) AS Settlement_Rfund_PR,
ISNULL(Settlement_Rfund_Int,0) AS Settlement_Rfund_Int,ISNULL(Settlement_Rfund_Total,0) AS Settlement_Rfund_Total,
Settlement_Rfund_date, Settlement_Rfund_Batch,Settlement_Rfund_UserId,Settlement_Batch,Settled_With_Name,Settled_With_Phone,
Settled_With_Fax,Settled_Type,ISNULL(Settled_by,0) AS Settled_by,Settled_Percent,DomainId from tblSettlements where case_id in (''' + Replace(@Case_Id,',',''',''') + ''') and DomainId='''+@DomainId+''' '
print @st
exec sp_executesql @st

