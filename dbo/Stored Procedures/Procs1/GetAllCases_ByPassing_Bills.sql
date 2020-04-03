CREATE PROCEDURE [dbo].[GetAllCases_ByPassing_Bills] --GetAllCases_ByPassing_Bills 'abc,aaa'
(  
   @Bills nvarchar(50)  
)  
as  
Declare @Bill_Number as nvarchar(4000)
Declare @str as nvarchar(4000)
Declare @case_Info as nvarchar(4000)

begin 
create table #TEMP (case_id nvarchar(4000)) 
set @Bill_Number=REPLACE (@Bills,',',''',''')
print @Bill_Number
set @str='select REPLACE ((select SUBSTRING ((select distinct '','' + case_id from tblTreatment where BILL_NUMBER in('''+@Bill_Number+''') FOR XML PATH('''')),2,200000)),'','','''''','''''')'
insert into #TEMP exec (@str)

set @case_Info='select case_id as FHKP_Cases,GB_CASE_ID as GB_Cases,GB_CASE_NO,[dbo].[fncGetBillNumber] (tblcase.case_Id) as Bill_Number,[dbo].fncGetRequestList (tblcase.case_Id)as Request_List,[dbo].[fncGetRejectionList] (tblcase.case_Id)as Rejection_List from tblcase where case_id in('''+(select case_id from #TEMP)+''')'
exec (@case_Info)
end
--select * from tblTreatment
--select treatment_id from tblcase
--select * from tblREJECTION_REQUEST 

--select * from MST_REQUEST_REJECTION_MASTER 

--select [dbo].fncGetRequestList ('FH12-95855')

--select case_id,BILL_NUMBER from tblTreatment where case_id='FH12-95860'

--select distinct case_id from tblTreatment where BILL_NUMBER in('CB2626','CB3195')

