CREATE PROCEDURE [dbo].[GET_WORKDESK_CASES_COUNT] --[GET_WORKDESK_CASES_COUNT] 'tech',0
	@DomainId NVARCHAR(50),
	@USER_NAME VARCHAR(50),
	@FILTERBY INT
AS
BEGIN
create table #temp
(
	Edit nvarchar(150),
	Case_Id nvarchar(50),
	Case_Code nvarchar(150),
	InjuredParty_Name nvarchar(150),
	Provider_Id nvarchar(50),
	Provider_Name nvarchar(150),
	InsuranceCompany_Name nvarchar(150),
	Date_Count INT,
	Accident_Date nvarchar(50),
	DateOfService_Start nvarchar(50),
	DateOfService_End nvarchar(50),
	Status nvarchar(150),
	Ins_Claim_Number nvarchar(50),
	Claim_Amount nvarchar(50),
	ClickMe nvarchar(50),
	SZ_COLOR_CODE nvarchar(550),
	Assigned_By nvarchar(150),
	Change_Reason nvarchar(750),
	notes_desc nvarchar(max),
	Assigned_To nvarchar(150),
	History_Id int,
	date_Assigned nvarchar(50),
	date_opened nvarchar(50)
)
	DECLARE @USER_ID AS INT
	DECLARE @STRSQL AS VARCHAR(MAX)
	SET @USER_ID = (SELECT USERID FROM ISSUETRACKER_USERS WHERE USERNAME = @USER_NAME and DomainId=@DomainId)
	
	INSERT INTO #TEMP
	exec get_grid_cases @DomainId=@DomainId, @SZ_USER_ID=@USER_NAME,@FilterBy=@FILTERBY,@CaseId='',@StartDate='',@EndDate=''

	SELECT count(*) as Total_Cases FROM #TEMP
	drop table #temp
END

