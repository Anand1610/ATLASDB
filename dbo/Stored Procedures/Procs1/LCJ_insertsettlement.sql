CREATE PROCEDURE [dbo].[LCJ_insertsettlement]
@case_id varchar(200)
as
begin

select sum(settlement_amount)as settlement_amount,
sum(settlement_int)as settlement_int,sum(settlement_af)as settlement_af,
sum(settlement_ff)as settlement_ff,sum(settlement_total)as settlement_total
from tblsettlements where case_id =@case_id
end

