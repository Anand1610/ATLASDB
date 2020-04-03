CREATE PROCEDURE [dbo].[sp_LCJ_GetEvents_Caseid]    
(  
@DomainId nvarchar(50),  
 @Case_id varchar(50)    
)    
as    
begin    
 select evt.case_id [Case Id],evt.event_id [Event Id],evtType.EventTypeName[Event Type],evtStatus.EventStatusName [Event Status],convert(nvarchar(11),evt.Event_Date,113) [Event Date],LTRIM(RIGHT(CONVERT(VARCHAR(20),Event_Time, 100), 7))    
  [Event Time],isnull(evt.Event_Notes,'') [Event Description],evt.assigned_to[Assigned To],Provider_name[Provider Name], ISNULL(vw.InjuredParty_FirstName, N'') + N'  ' + ISNULL(vw.InjuredParty_LastName, N'')     as [InjuredParty Name], Court_Venue[Court Venue],    
  isnull(IndexOrAAA_Number,'-') [IndexOrAAA Number], isnull(Defendant_Name,'-') [Defendant Name], InsuranceCompany_Name[InsuranceCompany Name],evt.eventtypeid [EventTypeID],    
  convert(nvarchar(10),evt.Event_Date,101) [evtmmddyy],evt.eventstatusid [EventStatusID] , isnull(evt.arbitrator_id,2) [ArbitratorId],  
  (select arbitrator_name from TblArbitrator  as tblarbitrator with(nolock) where DomainId=@DomainId and arbitrator_id = evt.arbitrator_id) [ArbitratorName]  
  from tblevent  evt with(nolock) join tbleventtype evtType with(nolock) on evtType.eventtypeid = evt.eventtypeid    
  join tbleventstatus evtStatus with(nolock) on evtStatus.eventstatusid = evt.eventstatusid join tblcase vw 
  on evt.Case_id=vw.Case_id INNER JOIN  dbo.tblInsuranceCompany INS WITH (NOLOCK) ON VW.InsuranceCompany_Id = INS.InsuranceCompany_Id
  INNER JOIN dbo.tblProvider WITH (NOLOCK) ON VW.Provider_Id = dbo.tblProvider.Provider_Id 
  LEFT OUTER JOIN  dbo.tblDefendant def WITH (NOLOCK) ON VW.Defendant_Id = def.Defendant_id
  LEFT OUTER JOIN  dbo.tblCourt crt WITH (NOLOCK) ON VW.Court_Id = crt.Court_Id 
  where evt.Case_id = @Case_id  and evt.DomainId=@DomainId  AND ISNULL(VW.IsDeleted,0) = 0
 order by  evt.Event_Date desc ,evt.Event_Time desc,evt.Assigned_To asc   
end

