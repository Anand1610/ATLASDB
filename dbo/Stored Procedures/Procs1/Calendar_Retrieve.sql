CREATE PROCEDURE [dbo].[Calendar_Retrieve]
(
	@DomainID						VARCHAR(50),
	@s_a_user_id					VARCHAR(100) = '',
	@s_a_case_id					NVARCHAR(MAX) = '',
	@s_a_court_id					NVARCHAR(MAX) = '',
	@s_a_event_type					NVARCHAR(MAX) = '',
	@dt_a_from_date					DATETIME = '7/16/2013',
	@dt_a_to_date					DATETIME ='7/16/2013'
)
AS
BEGIN		
   SET NOCOUNT ON 
   
   IF @dt_a_from_date=''
     set @dt_a_from_date = (SELECT CONVERT(VARCHAR(10),GETDATE(),101))
   IF @dt_a_to_date=''
    set @dt_a_to_date = (SELECT CONVERT(VARCHAR(10),GETDATE(),101))
   SELECT 
        EVT.Event_Id,
		EVT.CASE_ID [CASE_ID],
		EVTTYPE.EVENTTYPENAME[EVENT_TYPE],
		EVTSTATUS.EVENTSTATUSNAME [EVENT_STATUS], 
		CONVERT(NVARCHAR(11),EVT.EVENT_DATE,101) [EVENT_DATE], 
		ISNULL(CONVERT(NVARCHAR(5),EVT.EVENT_TIME,114),'')[EVENT_TIME],
		ISNULL(EVT.EVENT_NOTES,'') [EVENT_DESCRIPTION],
		EVT.ASSIGNED_TO[ASSIGNED_TO],
		PROVIDER_NAME[PROVIDER_NAME], 
		ISNULL(VW.InjuredParty_FirstName, N'') + N'  ' + ISNULL(VW.InjuredParty_LastName, N'')       
                      AS [INJUREDPARTY_NAME], 
		Court_Name[COURT_NAME],
		COURT_VENUE[COURT_VENUE],
		INDEXORAAA_NUMBER[INDEXORAAA_NUMBER],
		DEFENDANT_NAME[DEFENDANT_NAME],
		INSURANCECOMPANY_NAME[INSURANCECOMPANY_NAME],
		VW.STATUS [STATUS],
		Claim_Amount [CLAIM_AMOUNT],
		EVENT_DATE,
		COURT_VENUE + '/' + EVTTYPE.EVENTTYPENAME+'/' +	EVTSTATUS.EVENTSTATUSNAME  AS Calendar_Subject,
		(select 
		    TOP 1  I.FileName
         from 
            dbo.TBLDOCIMAGES I WITH(NOLOCK)
            Join dbo.tblImageTag IT WITH(NOLOCK) on IT.ImageID=i.ImageID
            Join dbo.tblTags T WITH(NOLOCK) on T.NodeID = IT.TagID And T.NodeName ='TRIAL SUBMISSION' and T.CaseID= EVT.CASE_ID 
			---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		    where I.IsDeleted=0 and IT.IsDeleted=0
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
			ORDER BY DateInserted DESC) AS TRIAL_SUBMISSION_File,
		'Edit' AS Edit_Text
	FROM 
		TBLEVENT EVT WITH(NOLOCK)
	JOIN TBLEVENTTYPE EVTTYPE WITH(NOLOCK) ON EVTTYPE.EVENTTYPEID = EVT.EVENTTYPEID and EVTTYPE.DomainId =@DomainID
	JOIN TBLEVENTSTATUS EVTSTATUS WITH(NOLOCK)  ON EVTSTATUS.EVENTSTATUSID = EVT.EVENTSTATUSID and EVTSTATUS.DomainId =@DomainID
	
	JOIN tblcase VW with(nolock) ON EVT.Case_id = VW.Case_Id and VW.DomainId =@DomainID
	INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON VW.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON VW.Provider_Id = dbo.tblProvider.Provider_Id  
	LEFT OUTER JOIN  dbo.tblDefendant WITH (NOLOCK) ON VW.Defendant_Id = dbo.tblDefendant.Defendant_id  
    LEFT OUTER JOIN  dbo.tblCourt WITH (NOLOCK) ON VW.Court_Id = dbo.tblCourt.Court_Id
	WHERE 
		EVT.DomainId = @DomainID AND
		 CONVERT(VARCHAR(10),Event_Date,101) BETWEEN @dt_a_from_date AND @dt_a_to_date AND
		 (@s_a_user_id = '' OR  EVT.Assigned_To = @s_a_user_id)   AND
		 (@s_a_case_id = '' OR  EVT.Case_id = @s_a_case_id)   AND
		 (@s_a_court_id  ='' OR VW.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_court_id,',')))  AND
		 (@s_a_event_type  ='' OR EVT.EventTypeId IN (SELECT items FROM dbo.SplitStringInt(@s_a_event_type,',')))
		 AND  ISNULL(VW.IsDeleted,0) = 0  
	ORDER BY 
		Court_Name,
		COURT_VENUE,
		EVT.EVENT_TIME 
			
		
	SET NOCOUNT OFF			
END
