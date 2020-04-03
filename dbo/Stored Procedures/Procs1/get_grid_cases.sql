CREATE PROCEDURE [dbo].[get_grid_cases]  --[get_grid_cases] 'admin',0,'','',''
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

  Declare @UserType as  NVARCHAR(100)
  DECLARE @strsql as varchar(8000)  
  set @UserType=(select usertype from IssueTracker_Users where username =@SZ_USER_ID and DomainId=@DomainId)
------------------- Original Logic to Search Case.  
  
  
set @strsql = 'select 
tblcase.Case_Id as Edit,  
tblcase.Case_Id,   
Case_Code,    
(InjuredParty_LastName + '', '' + InjuredParty_FirstName) as InjuredParty_Name,  
tblcase.Provider_Id,  
Provider_Name,  
InsuranceCompany_Name,
datediff (dd,convert(datetime, tblcasedeskhistory.date_changed),Getdate()) as Date_Count,
convert(varchar, Accident_Date, 101) as Accident_Date, 

convert(varchar, tblcase.DateOfService_Start,101) as DateOfService_Start,  
convert(varchar, tblcase.DateOfService_End,101) as DateOfService_End,  
Status,  
Ins_Claim_Number,  
convert(decimal(38,2),(convert(decimal(38,2),tblcase.Claim_Amount))-(convert(decimal(38,2),tblcase.Paid_Amount))) as Claim_Amount, 
'''' AS ClickMe,  
'''' [SZ_COLOR_CODE],
RTRIM(LTRIM(issuetracker_Users.UserName))[Assigned_By],
RTRIM(LTRIM(tblCaseDeskHistory.Change_Reason))[Change_Reason],
'''' notes_desc,
RTRIM(LTRIM(issue_To_User.UserName)) [Assigned_To],
RTRIM(LTRIM(tblCaseDeskHistory.History_Id)) [History_Id],
convert(varchar, tblcasedeskhistory.date_changed,101)[date_Assigned],
dbo.tblcase.Date_Opened
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
WHERE 1=1 AND TO_USER_ID is not null and bt_status=1 and ISNULL(tblcase.IsDeleted, 0)=0 and tblcase.DomainId = '''+ @DomainId +''''  


declare @ROLEID as integer  
 set @ROLEID = (SELECT TOP 1 ROLEID FROM IssueTracker_Users  WHERE USERNAME=@SZ_USER_ID and DomainId=@DomainId)  
  
if (@ROLEID = 10 or (@ROLEID = 1 and @UserType='S') or @SZ_USER_ID = 'la-kedar.j')  
BEGIN  
 set @strsql = @strsql  
END
else if @ROLEID=4
BEGIN
	set @strsql = @strsql + ' And tblcasedeskhistory.To_User_Id = (Select UserId from issuetracker_users  where username= '''+@SZ_USER_ID+''' and DomainId= '''+@DomainId+''')'  
END
ELSE  
BEGIN 
if (Select RoleId from issuetracker_users where username= @SZ_USER_ID and DomainId=@DomainId) <>10 -- or ((Select RoleId from issuetracker_users where username= @SZ_USER_ID and DomainId=@DomainId) <>1 and (select usertype from IssueTracker_Users where username =@SZ_USER_ID) <>'S' and DomainId=@DomainId )
	begin
		set @strsql = @strsql + ' And tblcasedeskhistory.To_User_Id = (Select UserId from issuetracker_users  where username= '''+@SZ_USER_ID+''' and DomainId= '''+@DomainId+''')'  
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

SET @strsql = @strsql + ' order by convert(varchar, tblcasedeskhistory.date_changed,101) desc' 

  print @strsql   
  exec (@strsql) 

  
end