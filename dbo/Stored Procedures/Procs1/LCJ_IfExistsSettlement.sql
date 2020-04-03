CREATE PROCEDURE [dbo].[LCJ_IfExistsSettlement]

(
@DomainId NVARCHAR(50),
@Case_Id NVARCHAR(100),
@OutputCaseId INTEGER OUTPUT

)

AS
--               set @strsql = @strsql + '  AND DenialReasons_Type = ''' + @DenialReasons_Type + ''''

declare @case_count as int
create table #tempcase (case_count int)


Declare @st as nvarchar(1000)
set @st = 'select Count(case_id) as case_count from tblSettlements  where case_id in (''' + Replace(@Case_Id,',',''',''') + ''') and DomainId='''+@DomainId+''''
Insert into #tempcase
exec sp_executesql @st


--IF EXISTS(Select Case_Id  FROM  tblSettlements WHERE Case_Id in (@Case_Id)  )
Select @case_count = case_count from #tempcase
If (@case_count>0)
	BEGIN
		
		SET @OutputCaseId = @case_count
		
		--RETURN @OutputCaseId
	END
 
ELSE

	BEGIN
		
		SET @OutputCaseId = 0
		
		--RETURN @OutputCaseId
	END

