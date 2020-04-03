CREATE VIEW [dbo].[SJR-PreCollected]
AS
select tblTransactions.case_id, tblTransactions.provider_id, tblcase.date_opened, transactions_amount, tblcase.claim_amount 
from tblTransactions inner join tblcase on tblTransactions.case_id= tblcase.case_id
where tblTransactions.transactions_type='PreC'

--select tblTransactions.case_id,tblTransactions.provider_id,transactions_date, 
--CONVERT(money, tblcase.Claim_Amount) AS Claim_Amount, sum(transactions_amount) as voluntary_paid_amount,(CONVERT(money, tblcase.Claim_Amount)-sum(transactions_amount)) as  Amount_Outstanding
--from tblTransactions INNER JOIN dbo.tblcase ON tblcase.Case_Id =tblTransactions.Case_Id
--where tblTransactions.transactions_type='PreC'
--group by transactions_date, tblTransactions.case_id ,tblcase.Claim_Amount,tblTransactions.provider_id
