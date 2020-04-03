

CREATE PROCEDURE [dbo].[LCJ_WorkAreaPaymentSummaryInforamtion] --[LCJ_WorkAreaPaymentSummaryInforamtion] 'AF','AF19-204270'

(
@DomainId AS NVARCHAR(50),
@Case_Id as NVARCHAR(400)
)

AS

select t1.Treatment_Id,sum(ISNULL(t3.RegionIVfeeScheduleAmount,0))[RegionIVfeeScheduleAmount] into #temp
from tblTreatment t1 (nolock)
join BILLS_WITH_PROCEDURE_CODES   t2 (nolock)
on t1.Treatment_Id=t2.fk_Treatment_Id and t1.Case_Id=@CASE_ID
join MST_PROCEDURE_CODES  t3   on t2.Auto_Proc_id=t3.Auto_Proc_id and t3.DomainId=@DomainId
GROUP BY t1.Treatment_Id

Select max(CASE_ID) as [case_id],(convert(varchar(10),min(DATEOFSERVICE_START),101)) as [DATEOFSERVICE_START],
	  (convert(varchar(10),max(DATEOFSERVICE_END),101)) as [DATEOFSERVICE_END],sum(CLAIM_AMOUNT) as [Claim_Amount],
	  sum (CONVERT(float, Claim_Amount) - CONVERT(float, Paid_Amount) - ISNULL(DeductibleAmount,0.00)) AS [Claim_Balance],
       sum(PAID_AMOUNT) as [Paid_Amount],
       sum(Fee_Schedule) as  [Fee_Schedule],
	   (select sum(transactions_amount) from tblTransactions (NOLOCK)  where tblTransactions.case_id=tblTreatment.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP'))[Voluntary_Payment],
	   (select sum(transactions_amount) from tblTransactions  (NOLOCK) where tblTransactions.case_id=tblTreatment.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I'))[Collection_Payment],
	  -- max(convert(decimal(38,2),Claim_Amount)-convert(decimal(38,2),Paid_Amount))[Claim_Balance],
	  -- max(ISNULL(CONVERT(DECIMAL(38,2),FEE_SCHEDULE),0)-ISNULL(CONVERT(DECIMAL(38,2),PAID_AMOUNT),0)) AS BALANCE_FS, 
	 --  max (ISNULL(CONVERT(float,FEE_SCHEDULE),0)-ISNULL(CONVERT(float,PAID_AMOUNT),0))[BALANCE_FS],
	 CASE WHEN @DomainId = 'AF'
	 THEN sum (CONVERT(float, FEE_SCHEDULE) - CONVERT(float, PAID_AMOUNT) - ISNULL(DeductibleAmount,0.00))
	 ELSE sum (CONVERT(float, FEE_SCHEDULE) - CONVERT(float, PAID_AMOUNT))
	 END AS [BALANCE_FS],
       max(DATE_BILLSENT) as [DATE_BILLSENT],
	   sum(ISNULL(DeductibleAmount,0.00)) AS [Total_Deductible],
	   sum(ISNULL(#temp.RegionIVfeeScheduleAmount,0.00)) [RegionIVfeeScheduleAmount]
	   from tblTreatment (Nolock) 
	   left join #temp on tblTreatment.Treatment_Id=#temp.Treatment_Id
	   where Case_Id= + @Case_Id and DomainId=@DomainId GROUP BY tblTreatment.Case_Id



