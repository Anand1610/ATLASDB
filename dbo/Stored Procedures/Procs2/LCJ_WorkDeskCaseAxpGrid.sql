CREATE PROCEDURE [dbo].[LCJ_WorkDeskCaseAxpGrid]    
(    
    
@Desk_Id int  
    
    
)    
AS    
Begin    
 Select distinct '' as RemoveCase, LCJ_VW_CaseSearchDetails.Case_Id, Provider_Name,   
InsuranceCompany_Name, InjuredParty_Name, Accident_Date, DateOfService_Start,   
DateOfService_End, Status, Policy_Number, tblcasedesk.Desk_Reason [Reason for Case assigned],  
tblnotes.user_id [Assigned By],tblnotes.notes_date [Assigned on] from LCJ_VW_CaseSearchDetails Inner Join tblCaseDesk   
ON LCJ_VW_CaseSearchDetails.Case_Id = tblCaseDesk.Case_Id Inner join tblnotes  
on tblnotes.case_id = lcj_vw_casesearchdetails.case_id  
where tblCaseDesk.Desk_Id = @Desk_Id and tblnotes.user_id in (select top 1 user_id from tblnotes where notes_desc like '%Desk_Reason changed from%to%' order by notes_date desc)
and tblnotes.notes_date in (select top 1 notes_date from tblnotes where notes_desc like '%Desk_Reason changed from%to%' order by notes_date desc)   
    
End

