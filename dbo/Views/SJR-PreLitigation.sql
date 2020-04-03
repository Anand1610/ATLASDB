

CREATE VIEW [dbo].[SJR-PreLitigation]
AS
select distinct (case_id) as case_id, provider_id,(CONVERT(money, Claim_Amount)) as claim_amount,
(CONVERT(money, Fee_Schedule)) as Fee_Schedule ,SUM(transactions_amount)as Voluntary_Paid_Amount ,
 date_opened,
 transactions_date, DomainID
from [vw_precollected] 
group by date_opened ,case_id, claim_amount,provider_id,transactions_date,Fee_Schedule,DomainID

--select count(distinct (case_id))case_count, provider_id,sum(transactions_amount)as Voluntary_Paid_Amount ,(CONVERT(money, Claim_Amount)) as claim_amount , date_opened
--from [SJR-PreCollected] 
--group by date_opened ,case_id, claim_amount,provider_id

