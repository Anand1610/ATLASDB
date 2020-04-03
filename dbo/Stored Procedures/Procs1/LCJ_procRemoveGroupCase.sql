CREATE PROCEDURE [dbo].[LCJ_procRemoveGroupCase](
@DomainId nvarchar(50),
@case_id varchar(50)
)
as
BEGIN
declare
@gdata nvarchar(1000),
@cid varchar(50),
@gid int,
@ST NVARCHAR(1000),
@seq int,
@max_seq int

select @gid = group_id, @seq= group_case_sequence from tblcase  where case_id=@case_id and DomainId=@DomainId

--select @max_seq = max(group_case_sequence) from tblcase where group_id = @group_id

print @gid

if @gid <> 0 
begin

	set @gdata = ','
	create table #temp(case_id varchar(50))

	insert into #temp
	select distinct case_id from tblcase  where group_id =@gid  and case_id <> @case_id and DomainId=@DomainId


	declare mycur cursor local for
	select case_id from #temp
	open mycur
	fetch next from mycur into @cid
	while @@fetch_status=0
	begin
		set @gdata = @gdata + ',' + @cid 
		fetch next from mycur into @cid
	end
	close mycur
	deallocate mycur
	drop table #temp


	if @gdata <> ''
	BEGIN
		DECLARE @GDATA2 NVARCHAR(1000)
		SELECT @GDATA2 = right(@gdata,len(@gdata)-2)
		--exec LCJ_CreateGroup @mids = @GDATA2
	END

	set @st = 'select ''File ' + @CASE_ID + ' REMOVED FROM GROUP ' + @GDATA2 + ' in packet ' + convert(varchar,@gid) + ''',''Activity'',0,case_id,''' + convert(varchar,getdate()) + ''',''system'' from tblcase where case_id in (''' + @CASE_ID + ''')'
	print @st

	insert into tblnotes
	exec sp_executesql @st

	update tblcase set group_all=B.cASE_ID,cAPTION = B.injuredparty_name,group_id=0,group_data=0,Group_InsClaimNo = B.Ins_Claim_Number,Group_ClaimAmt = B.claim_amount,Group_PaidAmt =B.Paid_amount,Group_Balance = CONVERT(VARCHAR,CONVERT(MONEY,B.CLAIM_AMOUNT)-CONVERT(MONEY,B.PAID_AMOUNT)),Group_PolicyNum=b.Policy_Number,Group_Accident=b.Accident_Date from TBLCASE INNER JOIN LCJ_VW_cASESEARCHDETAILS B ON TBLCASE.CASE_ID=B.CASE_ID where TBLCASE.case_id=@case_id

	END
end
if @gid = 0 
begin

update tblcase set group_all=B.cASE_ID,cAPTION = B.injuredparty_name,group_id=0,group_data=0,Group_InsClaimNo = B.Ins_Claim_Number,Group_ClaimAmt = B.claim_amount,Group_PaidAmt =B.Paid_amount,Group_Balance = CONVERT(VARCHAR,CONVERT(MONEY,B.CLAIM_AMOUNT)-CONVERT(MONEY,B.PAID_AMOUNT)),Group_PolicyNum=b.Policy_Number,Group_Accident=b.Accident_Date, group_case_sequence=null from TBLCASE INNER JOIN LCJ_VW_cASESEARCHDETAILS B ON TBLCASE.CASE_ID=B.CASE_ID where TBLCASE.case_id=@case_id

set @st = 'select ''File ' + @CASE_ID + ' REMOVED FROM GROUP ' + @GDATA2 + ' in packet ' + convert(varchar,@gid) + ''',''Activity'',0,case_id,''' + convert(varchar,getdate()) + ''',''system'' from tblcase where case_id in (''' + @CASE_ID + ''')'
print @st

insert into tblnotes
exec sp_executesql @st

delete from tblgroup where group_all = @case_id

end

--Correcting the sequencing of other cases in the Group
--update tblcase set group_case_sequence = group_case_sequence-1 where group_id=@gid and group_case_sequence>@seq

