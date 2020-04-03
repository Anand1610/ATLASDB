CREATE PROCEDURE [dbo].[F_CaseDeskHistory_Retrive_By_UserId]  --[F_CaseDeskHistory_Retrive_By_UserId] 'cwhite',0,'','',''
  
(
     @i_a_user_id int=0
)  
  
AS    
BEGIN
     select 
          ROW_NUMBER() OVER (ORDER BY History_Id) As s_no,
          RTRIM(LTRIM(tblCaseDeskHistory.History_Id)) [History_Id],
          tblcase.Case_Id,   
          Case_Code,    
          (InjuredParty_LastName + ', ' + InjuredParty_FirstName) as InjuredParty_Name,  
          tblcase.Provider_Id,  
          Provider_Name,  
          InsuranceCompany_Name,  
          convert(varchar, Accident_Date, 101) as Accident_Date,  
          convert(varchar, tblcase.DateOfService_Start,101) as DateOfService_Start,  
          convert(varchar, tblcase.DateOfService_End,101) as DateOfService_End,  
          '<TABLE  width="100%" border="0"><TR>'
         + '<TD width="2px" bgcolor="'
         + CASE  WHEN STATUS IN ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')
	          THEN 'RED' 
	          WHEN STATUS IN ('AAA CLOSED','AAA COLLECTION','AAA CONCILIATION SETTLEMENT','AAA CONFIRMED','AAA FILED','AAA HEARING SET','AAA OPEN','AAA PENDING','AAA RESPONSE RCVD','AAA SETTLED AT HEARING','AAA SETTLED POST HEARING','AAA SETTLED PRE HEARING','AAA WITHDRAWN WITH PREJUDICE AT HEARING','AAA WITHDRAWN WITH PREJUDICE POST HEARING','AAA WITHDRAWN WITH PREJUDICE PRE HEARING','AAA WITHDRAWN WITHOUT PREJUDICE AT HEARING','AAA WITHDRAWN WITHOUT PREJUDICE POST HEARING','AAA WITHDRAWN WITHOUT PREJUDICE PRE HEARING')
	          THEN 'GREEN'
	          ELSE '' END
				
         +'">'+Status+'</TD>'
         + '</TR></TABLE>' as Status,  
          Ins_Claim_Number,  
          convert(decimal(38,2),(convert(decimal(38,2),tblcase.Claim_Amount))-(convert(decimal(38,2),tblcase.Paid_Amount))) as Claim_Amount,  
          '' AS ClickMe,

          RTRIM(LTRIM(issuetracker_Users.UserName))[Assigned_By],
          RTRIM(LTRIM(tblCaseDeskHistory.Change_Reason))[Change_Reason],
          RTRIM(LTRIM(issue_To_User.UserName)) [Assigned_To],
          convert(varchar, tblcasedeskhistory.date_changed,101)[Date_Assigned],
          dbo.tblcase.Date_Opened
     from tblcasedeskhistory 
          INNER JOIN tblcase on tblcasedeskhistory.Case_Id=tblcase.Case_Id
          INNER JOIN tblprovider on tblcase.provider_id=tblprovider.provider_id 
          INNER JOIN tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id   
          INNER JOIN issuetracker_Users on tblcasedeskhistory.Login_User_Id=issuetracker_Users.UserId
          INNER JOIN issuetracker_Users issue_To_User on tblcasedeskhistory.To_User_Id=issue_To_User.UserId
     WHERE 1=1 AND TO_USER_ID = @i_a_user_id and bt_status=1  
END

