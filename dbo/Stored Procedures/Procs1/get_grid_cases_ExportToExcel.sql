CREATE PROCEDURE [dbo].[get_grid_cases_ExportToExcel]  --[get_grid_cases_ExportToExcel] 'la-shruti.d',0,'','',''
(  
@DomainId NVARCHAR(50),
@SZ_USER_ID NVARCHAR(50),
@FilterBy INT,
@CaseId varchar(50),
@StartDate varchar(50),
@EndDate varchar(50)
)  
  
AS    
begin  
DECLARE @IsUserAssigned NVARCHAR(100)  
Declare @UserType as  NVARCHAR(100)
  
--set @strCaseId = 'FH08-50478'  
DECLARE @strsql as varchar(8000)  
DECLARE @strsql_cursor as varchar(8000)  
set @UserType=(select usertype from IssueTracker_Users where username =@SZ_USER_ID and DomainId=@DomainId)
set @strsql_cursor = '  select top 1000  
      tblcase.Case_Id  
      From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id   
      left join tbltreatment on tblcase.Case_id = tbltreatment.Case_id   
       left join TXN_tblTreatment on tbltreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id  
      WHERE 1=1 '
  
SET @strsql_cursor = @strsql_cursor + ' Group BY tblcase.Case_Id , Case_Code ,  InjuredParty_LastName , InjuredParty_FirstName ,   
     Provider_Name , InsuranceCompany_Name , Accident_Date,tblcase.DateOfService_Start,tblcase.DateOfService_End,  
     Status,  Ins_Claim_Number, tblcase.Claim_Amount , tblcase.Paid_Amount , case_autoid  
     order by case_autoid desc'   
  
  
-------------------------------  START : CURSOR LOGIC  
print @strsql_cursor  
  
-- Start : Cursor For GetCaseIDs  
  
 CREATE TABLE   
 #TEMP_CASECOLOR(SZ_CASE_ID NVARCHAR(20) , SZ_COLOR_CODE NVARCHAR(4000))  
 declare @szCursorString nvarchar(1000)  
 set @szCursorString = ' DECLARE curGetAllCases CURSOR  
       FOR '+ @strsql_cursor  
 exec(@szCursorString)  
 DECLARE @SZ_TEMP_CASE_ID AS NVARCHAR(20)  
 OPEN curGetAllCases  
 FETCH NEXT FROM curGetAllCases INTO @SZ_TEMP_CASE_ID  
   
 WHILE @@FETCH_STATUS = 0  
    BEGIN  
    -- Cursor : To get Color code of each case.  
  
    DECLARE curGetColorCode CURSOR  
    LOCAL forward_only dynamic scroll_locks   
     FOR   
      select distinct(sz_category_color) from   tbldenialreasons,  
                 tbltreatment,  
                 txn_tbltreatment,MST_DENIAL_CATEGORY  
      where  
        tbltreatment.treatment_id = txn_tbltreatment.treatment_id  
        and txn_tbltreatment.denialreasons_id = tbldenialreasons.denialreasons_id  
        and MST_DENIAL_CATEGORY.i_category_id = tbldenialreasons.i_category_id  
        and tbltreatment.case_id = @SZ_TEMP_CASE_ID  
		and tbltreatment.DomainId=@DomainId
    DECLARE @SZ_COLOR_CODE AS NVARCHAR(20)  
    DECLARE @SZHTMLSTRING AS NVARCHAR(4000)  
    SET @SZHTMLSTRING = '<TABLE  width="100%" border="0"><TR>'  
    OPEN curGetColorCode  
    FETCH NEXT FROM curGetColorCode INTO @SZ_COLOR_CODE  
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
      SET @SZHTMLSTRING = @SZHTMLSTRING + '<TD width="2px" bgcolor="' + @SZ_COLOR_CODE + '">&nbsp;</TD>'  
      FETCH NEXT FROM curGetColorCode INTO @SZ_COLOR_CODE  
    END  
      
    SET @SZHTMLSTRING = @SZHTMLSTRING + '</TR></TABLE>'  
  
    INSERT INTO #TEMP_CASECOLOR VALUES(@SZ_TEMP_CASE_ID,@SZHTMLSTRING)   
    CLOSE curGetColorCode  
    DEALLOCATE curGetColorCode  
    -- End : To get Color code of each case.  
    FETCH NEXT FROM curGetAllCases INTO @SZ_TEMP_CASE_ID  
   END  
   CLOSE curGetAllCases  
   DEALLOCATE curGetAllCases  
-- End  
  
-------------------------------  END : CURSOR LOGIC  
  
  
------------------- Original Logic to Search Case.  
  
  
set @strsql = 'select  top 1000    
tblcase.Case_Id as [Case Id],    
(InjuredParty_LastName + '', '' + InjuredParty_FirstName) as [Injured Party],   
Provider_Name as [Provider],  
InsuranceCompany_Name as [Insurance Company],  
convert(varchar, Accident_Date, 101) as [Accident Date],  
''<TABLE  width="100%" border="0"><TR>''
	    + ''<TD width="2px" bgcolor="''
	    + CASE  WHEN STATUS IN (''CLOSED'',''Closed Arbitration'',''Closed as per RCF'',''Closed Judgement'',''Closed Withdrawn with Prejudice'',''Closed Withdrawn without prejudice'',''Settled'',''Withdrawn-with-prejudice'',''withdrawn-without-prejudice'',''Carrier In Rehab'',''Pending'',''Open-Old'',''Trial Lost'')
			THEN ''RED'' 
			WHEN STATUS IN (''AAA CLOSED'',''AAA COLLECTION'',''AAA CONCILIATION SETTLEMENT'',''AAA CONFIRMED'',''AAA FILED'',''AAA HEARING SET'',''AAA OPEN'',''AAA PENDING'',''AAA RESPONSE RCVD'',''AAA SETTLED AT HEARING'',''AAA SETTLED POST HEARING'',''AAA SETTLED PRE HEARING'',''AAA WITHDRAWN WITH PREJUDICE AT HEARING'',''AAA WITHDRAWN WITH PREJUDICE POST HEARING'',''AAA WITHDRAWN WITH PREJUDICE PRE HEARING'',''AAA WITHDRAWN WITHOUT PREJUDICE AT HEARING'',''AAA WITHDRAWN WITHOUT PREJUDICE POST HEARING'',''AAA WITHDRAWN WITHOUT PREJUDICE PRE HEARING'')
			THEN ''GREEN''
			ELSE '''' END
				
	    +''">''+Status+''</TD>''
	    + ''</TR></TABLE>'' as Status,  
Ins_Claim_Number as [Claim #],  
convert(decimal(38,2),(convert(decimal(38,2),tblcase.Claim_Amount))-(convert(decimal(38,2),tblcase.Paid_Amount))) as [Claim Amt], 

(SELECT SZ_COLOR_CODE FROM #TEMP_CASECOLOR WHERE SZ_CASE_ID = tblcase.Case_Id ) [Color Code],
RTRIM(LTRIM(issuetracker_Users.UserName))[Assigned By], 
RTRIM(LTRIM(issue_To_User.UserName)) [Assigned To],
convert(varchar, tblcasedeskhistory.date_changed,101)[Date Assigned],
RTRIM(LTRIM(tblCaseDeskHistory.Change_Reason))[Reason]
from tblcasedeskhistory inner join tblcase
on tblcasedeskhistory.Case_Id=tblcase.Case_Id
inner join tblprovider 
on tblcase.provider_id=tblprovider.provider_id 
inner join tblinsurancecompany 
on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id   
inner join issuetracker_Users 
on tblcasedeskhistory.Login_User_Id=issuetracker_Users.UserId
inner join issuetracker_Users issue_To_User
on tblcasedeskhistory.To_User_Id=issue_To_User.UserId
WHERE 1=1 AND TO_USER_ID is not null and bt_status=1 and tblcase.DomainId= '''+@DomainId+''''  


declare @ROLEID as integer  
 set @ROLEID = (SELECT TOP 1 ROLEID FROM ISSUETRACKER_USERS WHERE USERNAME=@SZ_USER_ID and DomainId=@DomainId)  
  
if (@ROLEID = 10 or (@ROLEID = 1 and @UserType='S') or @SZ_USER_ID = 'la-kalpana.s')  
BEGIN  
 set @strsql = @strsql  
END
else if (@SZ_USER_ID = 'ljainarine' OR @SZ_USER_ID = 'la-supriya.a' OR @SZ_USER_ID = 'la-medini.d')
begin
	set @strsql = @strsql + ' And Status in (''Pending'',''AAA PENDING'') or tblcasedeskhistory.To_User_Id = (Select UserId from issuetracker_users where username= '''+@SZ_USER_ID+''')'
end
ELSE  
BEGIN 
if (Select RoleId from issuetracker_users where username= @SZ_USER_ID and DomainId=@DomainId) <>10 or ((Select RoleId from issuetracker_users where username= @SZ_USER_ID and DomainId=@DomainId) <>1 and (select usertype from IssueTracker_Users where username =@SZ_USER_ID and DomainId=@DomainId) <>'S' ) or @SZ_USER_ID <> 'la-kalpana.s'
	begin
		set @strsql = @strsql + ' And tblcasedeskhistory.To_User_Id = (Select UserId from issuetracker_users where username= '''+@SZ_USER_ID+''')'  
	end 
END  

--IF @FilterBy = 0
--BEGIN
--	SET @strsql = @strsql
--END
--ELSE IF @FilterBy = 1
--BEGIN
--	SET @strsql = @strsql + ' And DateDiff(d,Date_Changed,getdate()) >= 60'
--END

--IF @CaseId <> ''
--BEGIN
--	SET @strsql = @strsql + ' And tblcasedeskhistory.Case_Id like ''%' + @CaseId + '%'''
--END

--IF @StartDate <> '' and @EndDate <> ''
--BEGIN
--	SET @strsql = @strsql + ' And CAST(FLOOR(CAST(date_changed AS FLOAT))AS DATETIME) >= ''' + @StartDate + ''' and CAST(FLOOR(CAST(date_changed AS FLOAT))AS DATETIME) <= ''' + @EndDate + ''''
--END

SET @strsql = @strsql + ' order by case_autoid desc' 

  print @strsql   
  exec (@strsql)  
  
DROP TABLE #TEMP_CASECOLOR  

  
end

