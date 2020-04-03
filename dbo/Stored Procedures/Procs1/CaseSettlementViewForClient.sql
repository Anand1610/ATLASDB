
CREATE PROCEDURE [dbo].[CaseSettlementViewForClient]    
(
@months int=12,
@Month_bucket int =1,
@caseId varchar(50),
@DomainId varchar(50)
	) 
AS    
BEGIN  
 
 --local var
declare @i  int =1
declare  @date datetime
declare @claim_amt numeric(18,2)
declare @fundingDate datetime
declare @IFee decimal(18,2)
declare @MFee decimal(18,2)
declare @ReservedPercentage int
declare @Advance_Rate decimal(18,2)
declare @Paid_amt decimal(18,2)
declare @Reserved_amt decimal(18,2)
declare @PaymentToBeRecieved  decimal(18,2)
declare  @Fixed_Fee_Rate_Time int
declare @PaymentToBeRecievedToClient decimal(18,2)
declare @buyout bit 
--local var


select @date=tc.DateOfService_Start,@claim_amt=convert(numeric(18,2),tc.Claim_Amount),
       @fundingDate=tc.DateOfService_Start,@IFee=tpr.Fixed_Fee_Rate,@MFee=Period_Fee_Rate,
	   @ReservedPercentage=tpf.Reserved_Percentage,
	   @Advance_Rate=tpr.Advance_Rate,
	   @Fixed_Fee_Rate_Time =(tpr.Fixed_Fee_Rate_Time)/30,
	   @buyout =tpr.Buyout
	     
       from tblcase tc 
       join tbl_Portfolio tpf on tc.PortfolioId =tpf.Id
       join tbl_Program  tpr on tpf.ProgramId = tpr.Id

       where tc.[DomainId] =@DomainId and tc.[Case_Id] =@caseId


---Paid amt calculation
SET @Paid_amt  =(@Advance_Rate*@claim_amt)/100
SET @Reserved_amt =( @ReservedPercentage*@claim_amt)/100
--SET @PaymentToBeRecieved =

---Paid amt calculation

  

DECLARE @CaseInfo TABLE
(
Id INT IDENTITY(1,1),
Claim_Amt numeric(18,2),
Funding_Date date,
Settlement_Date date,
Paid_amt decimal(18,2),
IFee varchar(50),
MFee varchar(50),
Reserved varchar(50),
Payment_To_Be_Received decimal(18,2),
Payment_To_Client decimal(18,2),
bucket int
);


if(@buyout =1)
begin

SET @PaymentToBeRecievedToClient = (@Paid_amt + @Reserved_amt)
SET @PaymentToBeRecieved =(@claim_amt - @PaymentToBeRecievedToClient);

insert into @CaseInfo values(@claim_amt,@fundingDate,@fundingDate,0,'0%','0%',Convert(varchar,@ReservedPercentage)+'%',@PaymentToBeRecieved,@PaymentToBeRecievedToClient,136);
end
else
begin
while(@i<=@months)
begin
declare @settlementDate date 
declare @bucket int

SELECT @settlementDate = DATEADD(month, @i, @date);

if(@i%3=0 and @i%6=0)
begin
set @bucket =136
end
else if(@i%3=0)
begin
set @bucket =13
end
else
begin
set @bucket =1
end


---Payment calculation
IF(@i <=@Fixed_Fee_Rate_Time)
begin 

SET @PaymentToBeRecieved =@Paid_amt+((@IFee*@claim_amt)/100);
SET @PaymentToBeRecievedToClient = (@claim_amt -@PaymentToBeRecieved)


insert into @CaseInfo values(@claim_amt,@fundingDate,@settlementDate,@Paid_amt,Convert(varchar,@IFee)+'%','0%',Convert(varchar,@ReservedPercentage)+'%',@PaymentToBeRecieved,@PaymentToBeRecievedToClient,@bucket);

end
else
begin

SET @PaymentToBeRecieved =@PaymentToBeRecieved+(@MFee*@claim_amt)/100;
SET @PaymentToBeRecievedToClient = (@claim_amt -@PaymentToBeRecieved)


insert into @CaseInfo values(@claim_amt,@fundingDate,@settlementDate,@Paid_amt,'0%',Convert(varchar,@MFee)+'%',Convert(varchar,@ReservedPercentage)+'%',@PaymentToBeRecieved,@PaymentToBeRecievedToClient,@bucket);

end

---Payment calculation

--insert into @CaseInfo values(@claim_amt,@fundingDate,@settlementDate,@Paid_amt,@IFee,@MFee,@ReservedPercentage,50,40,@bucket);

set @i=@i+1;

end
end





select * from @CaseInfo where bucket like CONCAT('%',@Month_bucket, '%') ;




select DateOfService_Start,
       tpr.Fixed_Fee_Rate,Period_Fee_Rate,
	   tpf.Reserved_Percentage,
	tpr.Advance_Rate,
	   tpr.Fixed_Fee_Rate_Time,
	 tpr.Period_Fee_Time_Frame,
	tpr.Buyout
	     
       from tblcase tc 
       join tbl_Portfolio tpf on tc.PortfolioId =tpf.Id
       join tbl_Program  tpr on tpf.ProgramId = tpr.Id
       where tc.[DomainId] =@DomainId and tc.[Case_Id] =@caseId



END

