CREATE PROCEDURE [dbo].[GetAllCases_ByPassing_CompanyNo] --GetAllCases_ByPassing_CaseId '444,1097'
(  
   @Company_Id nvarchar(50)  
)  
as  
  Declare @company as nvarchar(4000)
  Declare @case_Info as nvarchar(4000)

begin
set @company=REPLACE (@Company_Id,',',''',''')
set @case_Info='select case_id as FHKP_Cases,GB_CASE_ID as GB_Cases,GB_CASE_NO,[dbo].[fncGetBillNumber] (tblcase.case_Id) as Bill_Number,[dbo].fncGetRequestList (tblcase.case_Id)as Request_List,[dbo].[fncGetRejectionList] (tblcase.case_Id)as Rejection_List from tblcase where GB_COMPANY_ID in('''+@company+''')'
print @case_Info
exec (@case_Info)
end

--select * from tblTreatment
--select treatment_id from tblcase
--select * from tblREJECTION_REQUEST 
--select * from MST_REQUEST_REJECTION_MASTER 
--select [dbo].fncGetRequestList ('FH12-95855')
--select case_id,BILL_NUMBER from tblTreatment where case_id='FH12-95860'
--select distinct case_id from tblTreatment where BILL_NUMBER in('CB2626','CB3195')

