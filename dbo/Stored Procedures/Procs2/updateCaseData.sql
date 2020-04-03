CREATE procedure updateCaseData as
BEGIN

SET ANSI_WARNINGS OFF

update top(1000) tblcase
set DateOfService_Start=DOS,
DateOfService_End=DOE,
claim_amount=CLAIM,
paid_amount=paid,
Date_BillSent=DBS,
fee_schedule=FS,
writeOff = WOff
from tblcase
inner join (select tblcase.Case_Id as ID,
MIN(tblTreatment.DateOfService_Start) as DOS,
MAX(tblTreatment.DateOfService_end) as DOE,
ISNULL(SUM(tblTreatment.Claim_Amount),0) as CLAIM,
ISNULL(SUM(tblTreatment.Paid_Amount),0) as paid,
MIN(tblTreatment.Date_BillSent) as DBS,
SUM(tblTreatment.Fee_Schedule) as FS,
SUM(tblTreatment.writeOff) as WOff
from tblcase
inner join tblTreatment on tblTreatment.Case_Id = tblcase.Case_Id
where tblTreatment.Case_Id = tblcase.Case_Id --and tblTreatment.Paid_Amount <=tblTreatment.Claim_Amount
--and tblcase.Case_Id IN (select case_id from inserted)
group by tblcase.case_id) T on ID = tblcase.Case_Id
where case_id =id and (isnull(claim_amount,0) <> isnull(CLAIM,0) OR isnull(Fee_Schedule,0) <> isnull(FS,0))
and domainid='BT'
--And Case_Id IN (select case_id from inserted)

SET ANSI_WARNINGS ON

END
