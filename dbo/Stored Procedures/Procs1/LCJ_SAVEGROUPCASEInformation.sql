CREATE PROCEDURE [dbo].[LCJ_SAVEGROUPCASEInformation]
@CaseIdsCommaSep  as varchar(8000) ,

@caption  as varchar(8000) ,
@ClaimAmount   as varchar(8000) ,
@PaidAmount	as varchar(8000) ,

@BalanceAmount as varchar(8000) ,
@DatePacketed as varchar(8000) ,
@DateAccident as varchar(8000) ,
@GroupAll as varchar(8000) ,
@Insurance_Claim_No as varchar(8000) ,
@Group_Policy_No as varchar(8000) ,
@commasepnumbers as varchar(30),
@case_id as varchar(30)
 AS
begin
declare @separator varchar(5)
set @separator=','

declare @tmpcaption  as varchar(8000) 
declare @tmpClaimAmount   as varchar(8000) 
declare @tmpPaidAmount	as varchar(8000) 
declare @tmpBalanceAmount as varchar(8000) 
declare @tmpDatePacketed as varchar(8000) 
declare @tmpDateAccident as varchar(8000) 
declare @tmpGroupAll as varchar(8000) 
declare @tmpInsurance_Claim_No as varchar(8000) 
declare @tmpGroup_Policy_No as varchar(8000) 

set @tmpcaption  = ''
set @tmpClaimAmount   = ''
set @tmpPaidAmount	= ''
set @tmpBalanceAmount = ''
set @tmpGroupAll = ''
set @tmpInsurance_Claim_No = ''
set @tmpGroup_Policy_No = ''
set @tmpDateAccident=''



if @commasepnumbers is not null and @commasepnumbers<>'' 
begin
--First Insert Case id's 
DECLARE @INDEX INT
DECLARE @SLICE varchar(1000)
DECLARE @ROWID INT

SELECT @INDEX = 1
    IF @commasepnumbers IS  not NULL  
   begin
    WHILE @INDEX !=0
        BEGIN	
        	SELECT @INDEX = CHARINDEX(@separator,@commasepnumbers)

        	IF @INDEX !=0
        		SELECT @SLICE = LEFT(@commasepnumbers,@INDEX -1)
        	ELSE
        		SELECT @SLICE = @commasepnumbers
       	SELECT @commasepnumbers = RIGHT(@commasepnumbers,LEN(@commasepnumbers) - @INDEX)
	set @commasepnumbers= right(@commasepnumbers,len(@commasepnumbers)-len(@separator)+1)
	Set @slice = replace(@slice, @separator,'')
	
	set @tmpcaption = @tmpcaption + dbo.returnArrayIndexvalue(@caption, convert(int,@slice))+','
	set @tmpClaimAmount = @tmpClaimAmount + dbo.returnArrayIndexvalue(@ClaimAmount, convert(int,@slice))+','
	set @tmpPaidAmount = @tmpPaidAmount + dbo.returnArrayIndexvalue(@PaidAmount, convert(int,@slice))+','
	set @tmpBalanceAmount = @tmpBalanceAmount + dbo.returnArrayIndexvalue(@BalanceAmount, convert(int,@slice))+','
	set @tmpInsurance_Claim_No = @tmpInsurance_Claim_No + dbo.returnArrayIndexvalue(@Insurance_Claim_No, convert(int,@slice))+','
	set @tmpGroup_Policy_No = @tmpGroup_Policy_No + dbo.returnArrayIndexvalue(@Group_Policy_No, convert(int,@slice))+','
	set @tmpDateAccident = @tmpDateAccident + dbo.returnArrayIndexvalue(@DateAccident, convert(int,@slice))+','
	

	IF LEN(@commasepnumbers) = 0 BREAK
    END
 end
end

if len(@tmpcaption)>0 
begin
	set @tmpcaption = left(@tmpcaption,len(@tmpcaption)-1)
end

if len(@tmpClaimAmount)>0 
begin
	set @tmpClaimAmount = left(@tmpClaimAmount,len(@tmpClaimAmount)-1)
end

if len(@tmpPaidAmount)>0 
begin
	set @tmpPaidAmount = left(@tmpPaidAmount,len(@tmpPaidAmount)-1)
end

if len(@tmpBalanceAmount)>0 
begin
	set @tmpBalanceAmount = left(@tmpBalanceAmount,len(@tmpBalanceAmount)-1)
end

if len(@tmpInsurance_Claim_No)>0 
begin
	set @tmpInsurance_Claim_No = left(@tmpInsurance_Claim_No,len(@tmpInsurance_Claim_No)-1)
end

if len(@tmpGroup_Policy_No)>0 
begin
	set @tmpGroup_Policy_No = left(@tmpGroup_Policy_No,len(@tmpGroup_Policy_No)-1)
end


if len(@tmpDateAccident)>0 
begin
	set @tmpDateAccident = left(@tmpDateAccident,len(@tmpDateAccident)-1)
end

update tblcase
set caption=@tmpcaption,
group_claimamt = @tmpClaimAmount,
group_paidamt = @tmpPaidAmount,
group_insclaimno = @tmpInsurance_Claim_No,
group_all = @GroupAll,
group_balance = @tmpBalanceAmount,
group_accident = @tmpDateAccident,
group_policynum= @tmpGroup_Policy_No
where case_id in
(select case_id from tblcase where group_id = (select group_id from tblcase  where case_id=@case_id))


 

end

