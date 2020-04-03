CREATE PROCEDURE [dbo].[lcj_freezereport]
(
@provider  nvarchar(50),
@date datetime
)
as
declare @desc1 as nvarchar(255)
declare @desc2 as nvarchar(255)
declare @desc3 as nvarchar(255)
declare @desc4 as nvarchar(255)
declare @desc5 as nvarchar(255)
declare @desc as nvarchar(4000)
set @desc=''


create table #temp(case_id nvarchar(50),cname varchar(50),collected_amt money ,collected_fee money,
		   collected_interest money,interest_fee money,filing_fee money,expense_fee money,credit money,amount_due money,notes nvarchar(225))
insert into #temp(case_id,cname)

SELECT 	distinct(tblcase.CASE_ID),INJUREDPARTY_firstNAME + ' ' +INJUREDPARTY_lastNAME as [Name]
from tbltransactions inner join tblcase on tbltransactions.case_id=tblcase.case_id 
where tblcase.provider_id=@provider and Transactions_Date=@date
	
update #temp set collected_amt=(select transactions_amount from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where transactions_type='c'
and tblcase.provider_id=@provider and Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)

update #temp set collected_fee=(select transactions_fee from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where transactions_type='c'
and tblcase.provider_id=@provider and Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)

update #temp set notes=isnull((select transactions_description
from tbltransactions inner join tblcase on tbltransactions.case_id=tblcase.case_id 
where transactions_type='c' and tblcase.provider_id=@provider and Transactions_Date=@date
and #temp.case_id=tbltransactions.case_id),'') 

update #temp set collected_interest=(select transactions_amount from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where transactions_type='i'
and tblcase.provider_id=@provider and Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)

update #temp set interest_fee=(select transactions_fee from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where 
transactions_type='i' and tblcase.provider_id=@provider and
Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)

update #temp set notes=isnull(notes,'')+isnull('#'+ (select transactions_description
from tbltransactions inner join tblcase on tbltransactions.case_id=tblcase.case_id 
where transactions_type='i' and tblcase.provider_id=@provider and Transactions_Date=@date
and #temp.case_id=tbltransactions.case_id),'') 


update #temp set filing_fee=(select transactions_amount from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where transactions_type='ffb'
and tblcase.provider_id=@provider and Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)
 
update #temp set notes=isnull(notes,'')+isnull('#'+(select isnull(transactions_description,'')
from tbltransactions inner join tblcase on tbltransactions.case_id=tblcase.case_id 
where transactions_type='ffb' and tblcase.provider_id=@provider and
Transactions_Date=@date and #temp.case_id=tbltransactions.case_id),'')

update #temp set expense_fee=(select transactions_amount from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where transactions_type='exp'
and tblcase.provider_id=@provider and Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)

update #temp set notes=isnull(notes,'')+isnull('#' + (select isnull(transactions_description,' ')
from tbltransactions inner join tblcase on tbltransactions.case_id=tblcase.case_id 
where transactions_type='exp' and tblcase.provider_id=@provider and Transactions_Date=@date
and #temp.case_id=tbltransactions.case_id),'')

update #temp set credit=(select transactions_amount from tbltransactions 
inner join tblcase on tbltransactions.case_id=tblcase.case_id where 
transactions_type in ('CRED','W') and tblcase.provider_id=@provider
and Transactions_Date=@date and #temp.case_id=tbltransactions.case_id)

update #temp set notes=isnull(notes,'')+isnull('#' + (select isnull(transactions_description,' ')
from tbltransactions inner join tblcase on tbltransactions.case_id=tblcase.case_id 
where transactions_type in('CRED','W') and tblcase.provider_id=@provider and Transactions_Date=@date
and #temp.case_id=tbltransactions.case_id),'')

update #temp set notes='' where notes=ltrim(rtrim('#'))

update #temp set amount_due=(select isnull(collected_fee,0)+isnull(interest_fee,0)+isnull(expense_fee,0)-isnull(credit,0)
from #temp t1 where #temp.case_id=t1.case_id) 

insert into #temp(case_id) values('Total')

update #temp set collected_amt=(select sum(collected_amt) from #temp )
where #temp.case_id='Total' 

update #temp set collected_interest=(select sum(collected_interest) from #temp )
where #temp.case_id='Total'

update #temp set expense_fee=(select sum(expense_fee) from #temp )
where #temp.case_id='Total'

update #temp set amount_due=(select sum(amount_due) from #temp )
where #temp.case_id='Total'

select 
	case_id as "Case Id",cname as "Patient" ,
	isnull(collected_amt,0) as "Collected Amount",
	isnull(collected_fee,0) as "Collected Fee",
	isnull(collected_interest,0) as "Interest Collected",
	isnull(interest_fee,0) as "Interest Fee",
	isnull(filing_fee,0) as "Filing Fee",
	isnull(expense_fee,0) as "Expense",
	isnull(credit,0) as "Credit",
	isnull(amount_due,0) as "Amount Due",
	notes as "description"
 from #temp




drop table #temp

