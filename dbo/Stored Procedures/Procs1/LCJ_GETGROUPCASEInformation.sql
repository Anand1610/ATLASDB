CREATE PROCEDURE [dbo].[LCJ_GETGROUPCASEInformation]
@DomainId nvarchar(50),
@caseid nvarchar(50),
@CaseIdsCommaSep  as varchar(8000) output,

@caption  as varchar(8000) output,
@ClaimAmount   as varchar(8000) output,
@PaidAmount	as varchar(8000) output,

@BalanceAmount as varchar(8000) output,
@DatePacketed as varchar(8000) output,
@DateAccident as varchar(8000) output,
@GroupAll as varchar(8000) output,
@Insurance_Claim_No as varchar(8000) output,
@Group_Policy_No as varchar(8000) output
 AS
begin
declare @separator varchar(5)
set @separator=','


SELECT 
--@CaseIdsCommaSep =  COALESCE(@CaseIdsCommaSep +@separator, '')  + cast(ltrim(rtrim(case_id)) as nvarchar(50)),
--@caption =  COALESCE(@caption +@separator, '')  + cast(ltrim(rtrim(caption)) as nvarchar(1000)),
@caption= caption,
-- @ClaimAmount =  COALESCE(@ClaimAmount +@separator, '')  + cast(ltrim(rtrim(Claim_Amount)) as varchar(100)),
 @ClaimAmount = Group_ClaimAmt,
--@PaidAmount =  COALESCE(@PaidAmount +@separator, '')  + cast(ltrim(rtrim(Paid_Amount)) as varchar(100)),
@PaidAmount = Group_PaidAmt,
@BalanceAmount = Group_Balance,
--@BalanceAmount =  COALESCE(@BalanceAmount +@separator, '')  + cast(ltrim(rtrim(Claim_Amount)) as varchar(1000)),
--@DatePacketed =  COALESCE(@DatePacketed +@separator, '')  + cast(ltrim(rtrim(convert(varchar,Date_Packeted,101))) as varchar(20)),
@DatePacketed = convert(varchar,Date_Packeted,101),
--@DateAccident =  COALESCE(@DateAccident +@separator, '')  +  cast(ltrim(rtrim(convert(varchar,Accident_Date,101))) as varchar(20)),
--@GroupAll =  COALESCE(@GroupAll +@separator, '')  + cast(ltrim(rtrim(Group_All)) as varchar(500)),
@DateAccident =  group_accident,
@GroupAll = Group_All,
@Insurance_Claim_No = Group_InsClaimNo,
@CaseIdsCommaSep = Group_All,
--@Insurance_Claim_No =  COALESCE(@Insurance_Claim_No +@separator, '')  + cast(ltrim(rtrim(Ins_Claim_Number)) as varchar(100)),
@Group_Policy_No = Group_PolicyNum
--@Group_Policy_No =  COALESCE(@Group_Policy_No +@separator, '')  + cast(ltrim(rtrim(Group_PolicyNum)) as varchar(200))



FROM tblcase cas with(nolock)  where  ISNULL(cas.IsDeleted,0) = 0   and group_id in 
(select group_id from tblcase  where case_id=@caseid and tblcase.DomainId=@DomainId and group_id > 0) and cas.DomainId=@DomainId

--order by case_id

--print @caption
--print @ClaimAmount
end

