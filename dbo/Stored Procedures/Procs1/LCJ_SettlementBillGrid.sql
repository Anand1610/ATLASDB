CREATE PROCEDURE [dbo].[LCJ_SettlementBillGrid]
	-- Add the parameters for the stored procedure here
(
@Case_Id nvarchar(100)
)

AS
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @SettlementCount as INT

    -- Insert statements for procedure here

create table #temp(Settled int, treatment_id int,case_id nvarchar(50),DateOfService_Start datetime,
		DateOfService_End datetime,
		Claim_Amount money,
		Paid_Amount money, Date_BillSent nvarchar(11), SERVICE_TYPE nvarchar(200),
		DENIALREASONS_TYPE nvarchar(200), F_Fee float, Settlement_Pctg float, AttorneyFee money)


insert into #temp
select top 1 (
    select CASE
    WHEN Count(*) > 0
     THEN 1
     ELSE 0
     END AS count from tblsettlements where treatment_id = b.treatment_id ),Treatment_Id,
Case_Id,
DateOfService_Start,
DateOfService_End,
Claim_Amount,
Paid_Amount,
Convert(nvarchar(11), Date_BillSent, 101) Date_BillSent,
SERVICE_TYPE,
DENIALREASONS_TYPE,(Select Settlement_Ff from tblSettlements where treatment_id = b.treatment_id) as F_Fee, 
	CASE when Settlement_Pctg is null then '100.00'
		else Settlement_Pctg end as Settlement_Pctg,
	CASE when AttorneyFee is null then '0.0' 
		else AttorneyFee end as AttorneyFee from tbltreatment b where case_id = @Case_Id

insert into #temp
select  (select CASE
    WHEN Count(*) > 0 
     THEN 1
     ELSE 0
     END AS count from tblsettlements where treatment_id = b.treatment_id
 ),Treatment_Id,
Case_Id,
DateOfService_Start,
DateOfService_End,
Claim_Amount,
Paid_Amount,
Convert(nvarchar(11), Date_BillSent, 101) Date_BillSent,
SERVICE_TYPE,
DENIALREASONS_TYPE,(Select Settlement_Ff from tblSettlements where treatment_id = b.treatment_id) as F_Fee, 
		CASE when Settlement_Pctg is null then '100.00'
		else Settlement_Pctg end as Settlement_Pctg, 
		CASE when AttorneyFee is null then '0.0' 
		else AttorneyFee end as AttorneyFee from tbltreatment b where case_id = @Case_Id
and treatment_id not in (select treatment_id from #temp)

select * from #temp

drop table #temp

