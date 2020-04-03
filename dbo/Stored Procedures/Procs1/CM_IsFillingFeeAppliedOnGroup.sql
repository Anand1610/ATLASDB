CREATE PROCEDURE[dbo].[CM_IsFillingFeeAppliedOnGroup]

(

@Case_Id NVARCHAR(100),
@FillingExists INTEGER OUTPUT

)

AS
--               set @strsql = @strsql + '  AND DenialReasons_Type = ''' + @DenialReasons_Type + ''''


declare @case_count as int
create table #tempcase (case_count int)

Declare @st as nvarchar(1000)
set @st = 'select Count(Settlement_Ff) from tblsettlements where case_id in (select case_id from tblcase where group_id in (select  group_id  from tblcase where case_id in (''' + Replace(@Case_Id,',',''',''') + ''') )) AND (Settlement_FF IS NOT NULL) AND (Settlement_FF <> 0)'

Insert into #tempcase
exec sp_executesql @st


--IF EXISTS(Select Case_Id  FROM  tblSettlements WHERE Case_Id in (@Case_Id)  )
Select @case_count = case_count from #tempcase
If (@case_count>0)
	BEGIN
		
		SET @FillingExists = @case_count
		
		--RETURN @OutputCaseId
	END
 
ELSE

	BEGIN
		
		SET @FillingExists = 0
		
		--RETURN @OutputCaseId
	END

