CREATE PROCEDURE [dbo].[Get_Not_Report] --[Get_Not_Report] '2',''
( 
  @parameter int,
  @case_id varchar(Max)	
)
AS 
declare @sqlquery  varchar(MAX)

IF(@parameter='1')
BEGIN

	set @sqlquery = 'select distinct V.case_id,
	InjuredParty_Name, 
	Provider_Name, 
	InsuranceCompany_Name,
	V.status,
	Defendant_Name,
	IndexOrAAA_Number,
	Court_Name,
	''''as Report_Status,
	'''' as Upload_Time,
	'''' as Upload_Total,
	'''' [EVENT_TYPE],
	'''' [EVENT_STATUS], 
	'''' [EVENT_DATE], 
	'''' [EVENT_TIME],
	'''' [EVENT_DESCRIPTION],
	'''' [ASSIGNED_TO]
	from dbo.LCJ_VW_CaseSearchDetails V
	where status not in (''CLOSED'', ''settled'', ''WITHDRAWN-WITH PREJUDICE'', ''WITHDRAWN WITHOUT PREJUDICE'', ''NOTICE OF TRIAL FILED'')
	and isnull(IndexOrAAA_Number,'''') <> '''' and V.Case_Id in ('+@case_id+')
	order by V.case_id'	
	PRINT @sqlquery
	exec (@sqlquery)
END
ELSE
BEGIN
	
	IF(@case_id <> '')
	BEGIN
		set @sqlquery = 	'select distinct V.case_id,
		InjuredParty_Name, 
		Provider_Name, 
		InsuranceCompany_Name,
		V.status,
		Defendant_Name,
		IndexOrAAA_Number,
		Court_Name,
		Case When (select count(SZ_CASE_ID) from TXN_DOCUMENT_UPLOAD where SZ_CAPTION =''Discovery Responses'' and SZ_Case_ID=V.Case_Id) > 0 Then ''Yes''Else ''No'' End as Report_Status, 
		(select count(SZ_CASE_ID) from TXN_DOCUMENT_UPLOAD where SZ_CAPTION =''Discovery Responses'' and SZ_Case_ID=V.Case_Id) as Upload_Total,   
		(select convert(nvarchar,max(DT_UPLOAD_TIME),101)from TXN_DOCUMENT_UPLOAD where SZ_CAPTION =''Discovery Responses'' and SZ_Case_ID=V.Case_Id) as Upload_Time,
		EVTTYPE.EVENTTYPENAME as [EVENT_TYPE],
		EVTSTATUS.EVENTSTATUSNAME as EVENT_STATUS, 
		CONVERT(NVARCHAR(11),EVT.EVENT_DATE,101) as EVENT_DATE, 
		ISNULL(CONVERT(NVARCHAR(5),EVT.EVENT_TIME,114),'''') as EVENT_TIME,
		ISNULL(EVT.EVENT_NOTES,'''') [EVENT_DESCRIPTION],
		EVT.ASSIGNED_TO as ASSIGNED_TO    
		from dbo.LCJ_VW_CaseSearchDetails V
		LEFT OUTER JOIN (select * from tblevent where status=1) EVT on V.Case_Id = EVT.Case_Id
		LEFT OUTER JOIN TBLEVENTTYPE EVTTYPE ON EVTTYPE.EVENTTYPEID = EVT.EVENTTYPEID 
		LEFT OUTER JOIN TBLEVENTSTATUS EVTSTATUS ON EVTSTATUS.EVENTSTATUSID = EVT.EVENTSTATUSID 
		Where isnull(IndexOrAAA_Number,'''') <> ''''  and V.Case_Id in ('+@case_id+')
		order by V.case_id'
		
		print 	@sqlquery
		
		exec (@sqlquery)
	END
	ELSE
	BEGIN
		select distinct V.case_id,
		InjuredParty_Name, 
		Provider_Name, 
		InsuranceCompany_Name,
		V.status,
		Defendant_Name,
		IndexOrAAA_Number,
		Court_Name,
		Case When (select count(SZ_CASE_ID) from TXN_DOCUMENT_UPLOAD where SZ_CAPTION ='Discovery Responses' and SZ_Case_ID=V.Case_Id) > 0 Then 'Yes'Else 'No' End as Report_Status, 
		(select count(SZ_CASE_ID) from TXN_DOCUMENT_UPLOAD where SZ_CAPTION ='Discovery Responses' and SZ_Case_ID=V.Case_Id) as Upload_Total,   
		(select convert(nvarchar,max(DT_UPLOAD_TIME),101)from TXN_DOCUMENT_UPLOAD where SZ_CAPTION ='Discovery Responses' and SZ_Case_ID=V.Case_Id) as Upload_Time,
		EVTTYPE.EVENTTYPENAME as EVENT_TYPE,
		EVTSTATUS.EVENTSTATUSNAME [EVENT_STATUS], 
		CONVERT(NVARCHAR(11),EVT.EVENT_DATE,101) [EVENT_DATE], 
		ISNULL(CONVERT(NVARCHAR(5),EVT.EVENT_TIME,114),'')[EVENT_TIME],
		ISNULL(EVT.EVENT_NOTES,'') [EVENT_DESCRIPTION],
		EVT.ASSIGNED_TO[ASSIGNED_TO]    
		from dbo.LCJ_VW_CaseSearchDetails V
		LEFT OUTER JOIN (select * from tblevent where status=1) EVT on V.Case_Id = EVT.Case_Id
		LEFT OUTER JOIN TBLEVENTTYPE EVTTYPE ON EVTTYPE.EVENTTYPEID = EVT.EVENTTYPEID 
		LEFT OUTER JOIN TBLEVENTSTATUS EVTSTATUS ON EVTSTATUS.EVENTSTATUSID = EVT.EVENTSTATUSID 
		Where V.Status='ANSWER-RECD' and isnull(IndexOrAAA_Number,'') <> '' 
		and V.case_id not in (SELECT Case_id from LCJ_VW_CaseSearchDetails where InsuranceCompany_Name like 'ALLSTATE%' and Defendant_Name like '%Robert P. Tusa%')
		and V.case_id not in (SELECT Case_id from LCJ_VW_CaseSearchDetails where (InsuranceCompany_Name like 'GEICO%' or InsuranceCompany_Name like 'GOVERNMENT EMPLOYEES INSURANCE COMPANY' )and (Defendant_Name like '%Teresa M. Spina%' or Defendant_Name like  'Spina, Korshin & Welden, ESQ'))
		and V.case_id not in (SELECT Case_id from LCJ_VW_CaseSearchDetails where Provider_Name like 'Dynamic%' and InsuranceCompany_Name like 'State Farm%' and Defendant_Name like '%Rivkin & Radler%')
		and V.case_id not in (SELECT Case_id from LCJ_VW_CaseSearchDetails where InsuranceCompany_Name like 'AMERICAN TRANSIT INSURANCE COMPANY')
		and v.Case_Id not in (SELECT Case_id from LCJ_VW_CaseSearchDetails where Defendant_Name like '%Robert%Tusa%' or Defendant_Name like  '%Korshin%Welden%')
		and v.Case_Id not in (SELECT Case_id from LCJ_VW_CaseSearchDetails where InsuranceCompany_Name like '%GEICO INSURANCE COMPANY%' or Defendant_Name like  '%Law Office of Solowan & Welden%')
		order by V.case_id
	END	
END

