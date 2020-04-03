CREATE PROCEDURE [dbo].[eomBalances](
@clid varchar(50),
@monthVar int,
@yearVar int
)
as
begin
create table #temp(provider_id varchar(50),monthVar int,yearVar int,total_due money,AmountCurrent money,Amount30 money,Amount60 money,AmountPast money)
declare
@dt datetime,
@dt2 varchar(50),
@ad money,
@ae money,
@ac money,
@ap money,
@amountcurrent money,
@amount30 money,
@amount60 money,
@amountpast money,
@totaldue money

set @ad = 0.00
set @ae = 0.00
set @ac = 0.00
set @ap = 0.00


set @dt2 = convert(varchar,@monthvar) + '/20/' + convert(varchar,@yearVar)

set @dt = cast(@dt2 as datetime)
print @dt

------------------------total due----------------------------------------
select @ad = sum(transactions_fee) from tbltransactions where transactions_type in ('C','I') and provider_id=@clid and month(transactions_Date) = @monthvar and year(transactions_Date) = @yearVar 
print 'ad-' + convert(varchar,@ad)
select @ae = sum(transactions_amount) from tbltransactions where transactions_type in ('FFB','EXP') and provider_id=@clid and month(transactions_Date) = @monthvar and year(transactions_Date) = @yearVar
print 'ae-' +  convert(varchar,@ae)
select @ac = sum(transactions_amount) from tbltransactions where transactions_type in ('CRED') and provider_id=@clid and month(transactions_Date) = @monthvar and year(transactions_Date) = @yearVar 
print 'ac -' + convert(varchar,@ac)
select @ap = sum(payment_amount) from tblpayment where provider_id=@clid and month(payment_Date) = @monthvar and year(payment_Date) = @yearVar
print 'ap -' +  convert(varchar,@ap)

set @totaldue = isnull(@ad,0.00) + isnull(@ae,0.00) - (isnull(@ac,0.00) + isnull(@ap,0.00))

print 'totaldue - ' + convert(varchar,@totaldue)

------------------------current month----------------------------------------
select @ad = sum(transactions_fee) from tbltransactions where transactions_type in ('C','I') and provider_id=@clid and month(transactions_Date) <= @monthvar and year(transactions_Date) <= @yearVar 
--print convert(varchar,@ad)
select @ae = sum(transactions_amount) from tbltransactions where transactions_type in ('FFB','EXP') and provider_id=@clid and month(transactions_Date) <= @monthvar and year(transactions_Date) <= @yearVar
--print convert(varchar,@ae)
select @ac = sum(transactions_amount) from tbltransactions where transactions_type in ('CRED') and provider_id=@clid and month(transactions_Date) <= @monthvar and year(transactions_Date) <= @yearVar 
print convert(varchar,@ac)
select @ap = sum(payment_amount) from tblpayment where provider_id=@clid and month(payment_Date) <= @monthvar and year(payment_Date) <= @yearVar
print convert(varchar,@ap)

set @amountcurrent = isnull(@ad,0.00) + isnull(@ae,0.00) - (isnull(@ac,0.00) + isnull(@ap,0.00))

print convert(varchar,@amountcurrent)

------------------------30 month----------------------------------------
set @ad = 0.00
set @ae = 0.00
set @ac = 0.00
set @ap = 0.00

select @ad = sum(transactions_fee) from tbltransactions where transactions_type in ('C','I') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-1,@dt)) and year(transactions_Date) <= year(DateAdd(m,-1,@dt))
print convert(varchar,@ad)
select @ae = sum(transactions_amount) from tbltransactions where transactions_type in ('FFB','EXP') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-1,@dt)) and year(transactions_Date) <= year(DateAdd(m,-1,@dt))
print convert(varchar,@ae)
select @ac = sum(transactions_amount) from tbltransactions where transactions_type in ('CRED') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-1,@dt)) and year(transactions_Date) <= year(DateAdd(m,-1,@dt))
print convert(varchar,@ac)
select @ap = sum(payment_amount) from tblpayment where provider_id=@clid and month(payment_Date) <= month(DateAdd(m,-1,@dt)) and year(payment_Date) <= year(DateAdd(m,-1,@dt))
print convert(varchar,@ap)

set @amount30 = isnull(@ad,0.00) + isnull(@ae,0.00) - (isnull(@ac,0.00) + isnull(@ap,0.00))
print convert(varchar,@amount30)
------------------------60 month----------------------------------------
set @ad = 0.00
set @ae = 0.00
set @ac = 0.00
set @ap = 0.00

select @ad = sum(transactions_fee) from tbltransactions where transactions_type in ('C','I') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-2,@dt)) and year(transactions_Date) <= year(DateAdd(m,-2,@dt))
select @ae = sum(transactions_amount) from tbltransactions where transactions_type in ('FFB','EXP') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-2,@dt)) and year(transactions_Date) <= year(DateAdd(m,-2,@dt))
select @ac = sum(transactions_amount) from tbltransactions where transactions_type in ('CRED') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-2,@dt)) and year(transactions_Date) <= year(DateAdd(m,-2,@dt))
select @ap = sum(payment_amount) from tblpayment where provider_id=@clid and month(payment_Date) <= month(DateAdd(m,-2,@dt)) and year(payment_Date) <= year(DateAdd(m,-2,@dt))

set @amount60 = isnull(@ad,0.00) + isnull(@ae,0.00) - (isnull(@ac,0.00) + isnull(@ap,0.00))
print convert(varchar,@amount60)

------------------------prev month----------------------------------------
set @ad = 0.00
set @ae = 0.00
set @ac = 0.00
set @ap = 0.00

select @ad = sum(transactions_fee) from tbltransactions where transactions_type in ('C','I') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-3,@dt)) and year(transactions_Date) <= year(DateAdd(m,-3,@dt))
select @ae = sum(transactions_amount) from tbltransactions where transactions_type in ('FFB','EXP') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-3,@dt)) and year(transactions_Date) <= year(DateAdd(m,-3,@dt))
select @ac = sum(transactions_amount) from tbltransactions where transactions_type in ('CRED') and provider_id=@clid and month(transactions_Date) <= month(DateAdd(m,-3,@dt)) and year(transactions_Date) <= year(DateAdd(m,-3,@dt))
select @ap = sum(payment_amount) from tblpayment where provider_id=@clid and month(payment_Date) <= month(DateAdd(m,-3,@dt)) and year(payment_Date) <= year(DateAdd(m,-3,@dt))

set @amountpast = isnull(@ad,0.00) + isnull(@ae,0.00) - (isnull(@ac,0.00) + isnull(@ap,0.00))

insert into #temp values (@clid,@monthVar,@yearVar,@totaldue,@amountcurrent,@amount30,@amount60,@amountpast)

select * from #temp
drop table #temp

end

