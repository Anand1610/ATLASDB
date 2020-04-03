CREATE PROCEDURE [dbo].[LCJ_setTable_SUM] 
(
@case_id varchar(50)
)
as
begin
select count(distinct settlement_id)as tot_count,a.case_id,isnull(sum(b.claim_amount),0)as sum_claim_amount,isnull(sum(b.paid_amount),0)as sum_paid_amount,
isnull(sum(a.settlement_amount),0)as sum_settlement_amount,isnull(sum(a.settlement_int),0)as sum_settlement_int,
isnull(sum(a.settlement_af),0) as sum_settlement_af,isnull(sum(a.settlement_ff),0)as sum_settlement_ff,
a.settlement_date,isnull(sum(a.settlement_total),0)as sum_settlement_total,a.user_id
from tblsettlements a inner join tbltreatment b on
a.treatment_id=b.treatment_id where a.case_id=@case_id
group by  a.case_id,a.settlement_date,a.user_id
end

