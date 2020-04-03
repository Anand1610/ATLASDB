CREATE PROCEDURE [dbo].[sp_LCJ_GetEvents_userid] 
(
@User_id varchar(50),
@Event_Date varchar(50)
)
as
begin
select evt.case_id [Case Id],evtType.EventTypeName[Event Type],evtStatus.EventStatusName [Event Status],evt.Event_Date[Event Date], isnull(convert(nvarchar(5),evt.Event_Time,114),'')
[Event Time],isnull(evt.Event_Notes,'') [Event Description],evt.assigned_to[Assigned To],Provider_name[Provider Name], ISNULL(vw.InjuredParty_FirstName, N'') + N'  ' + 
ISNULL(vw.InjuredParty_LastName, N'') 
as [InjuredParty Name], Court_Venue[Court Venue], 
IndexOrAAA_Number[IndexOrAAA Number], Defendant_Name[Defendant Name], InsuranceCompany_Name[InsuranceCompany Name] from tblevent evt join tbleventtype evtType 
on evtType.eventtypeid = evt.eventtypeid 
join tbleventstatus evtStatus WITH (NOLOCK) on evtStatus.eventstatusid = evt.eventstatusid join tblcase vw with(nolock)  on evt.Case_id=vw.Case_id 
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON vw.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON vw.Provider_Id = dbo.tblProvider.Provider_Id
LEFT OUTER JOIN  dbo.tblDefendant WITH (NOLOCK) ON vw.Defendant_Id = dbo.tblDefendant.Defendant_id
LEFT OUTER JOIN  dbo.tblCourt WITH (NOLOCK) ON vw.Court_Id = dbo.tblCourt.Court_Id 
where evt.Event_Date = @Event_Date 
and evt.User_id=@User_id 
AND ISNULL(vw.IsDeleted,0) = 0
order by  evt.Assigned_To asc,evt.Event_Time 
end

