CREATE PROCEDURE[dbo].[ClientMonthTrans_ByMonth](
@clid varchar(40),
@TransDate_st DateTime,
@TransDate_end DateTime
)
AS
begin

declare @dif integer
declare @dtcnt integer
set @dtcnt=0
declare @temptrandate datetime
set @dif=datediff(day,@transdate_st,@transdate_end)

 
print @dif
CREATE TABLE #MonthlyDetails (		     clid varchar(50),
					     	transdate varchar(20),
						CountCases INT,
						TotalCollected Money,
						cntTotalCollected int,
						TotalIntCollected MOney,
						cntTotalIntCollected int,
						TotalDue Money, 
						TotalCost Money,
						cntTotalCost int,
						TotalFFReceived Money,
						cntTotalFFReceived int,
						TotalCred  Money,
						cntTotalCred  int,
						payments money,
						FinalTotalDue MoneY,
						InvoiceNo int
			)

 

while (@dtcnt <=(@dif)-1) 


begin

 set @dtcnt = @dtcnt + 1
 Set @TempTranDate = DATEADD ( day , @dtcnt , @TransDate_st ) 
 
 --SET @TempMonth = convert(varchar(2) ,Month(@TempTransDate))
 --SET @TempYear = convert(varchar(4) ,Year(@TempTransDate))
 --print ('MonthTrans ''' +   @clid  + ''' , '  + @TempMonth + ' , ' + @TempYear  )

Insert Into #MonthlyDetails ( 			clid,
						transdate,
						CountCases,
						TotalCollected ,
						cntTotalCollected, 
						TotalIntCollected ,
						cntTotalIntCollected ,
						TotalDue , 
						TotalCost ,
						cntTotalCost ,
						TotalFFReceived,
						cntTotalFFReceived,
						TotalCred ,
						cntTotalCred ,
						payments,
						FinalTotalDue,
						InvoiceNo
				)
Exec dbo.ClientMonthTransSingle @clid ,  @TempTranDate  
 
  
end
Select * from #MonthlyDetails 
end
drop table #monthlydetails

