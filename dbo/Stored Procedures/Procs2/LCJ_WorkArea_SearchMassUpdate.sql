
CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchMassUpdate]-- [LCJ_WorkArea_SearchMassUpdate]'priya','','','','','','','','','','','','','','miller leena'
(
	@DomainId								nvarchar(50),
	@strOldCaseId                           nvarchar(50),
	@strCaseId                              nvarchar(50),
	@Status                                 nvarchar(50),
	@InjuredParty_LastName               	nvarchar(50),
	@InjuredParty_FirstName               	nvarchar(50),
	@InsuredParty_LastName              	nvarchar(50),
	@InsuredParty_FirstName              	nvarchar(50),
	@Policy_Number                          nvarchar(100),
	@Ins_Claim_Number                       nvarchar(100),
	@IndexOrAAA_Number                  	nvarchar(100),
	@AssignedValue						int =null,
	@PeerDoctor						nvarchar (100)=null,
	@strMultipleValues Nvarchar(max),
	@strMultipleNames Nvarchar(max)
)

As

DECLARE @NameCounts  INT
DECLARE @RowConut  INT
DECLARE @TRIMED_Name VARCHAR(50)

DECLARE @tblCaseTemp AS TABLE
(
	CASEID VARCHAR(100)
)

DECLARE @tblNames AS TABLE
(
    ID INT IDENTITY,
	NAMES VARCHAR(100)
)

INSERT INTO @tblCaseTemp
select items FROM dbo.STRING_SPLIT(@strMultipleValues,',')

INSERT INTO @tblNames
select items FROM dbo.STRING_SPLIT(@strMultipleNames,',')

SET @RowConut =1;

SELECT @NameCounts = COUNT(*) from @tblNames;

WHILE(@RowConut <=@NameCounts)
BEGIN
	SELECT @TRIMED_Name = NAMES FROM @tblNames WHERE ID=@RowConut;
	SET @TRIMED_Name = LTRIM(RTRIM(@TRIMED_Name))

	WHILE CHARINDEX('  ',@TRIMED_Name  ) > 0
     BEGIN
        SET @TRIMED_Name = replace(@TRIMED_Name, '  ', ' ')
     END

	 UPDATE @tblNames SET NAMES=@TRIMED_Name WHERE ID=@RowConut;
	
	SET @RowConut =@RowConut+1;
END

--SELECT * FROM @tblNames;
DECLARE @strsql as nvarchar(max)

begin
  
--print(@strsql_cursor)
select top 1000 Case_Id,
Case_Code,  
(InjuredParty_LastName + ',' + InjuredParty_FirstName) as InjuredParty_Name,
Provider_Name,
InsuranceCompany_Name,
convert(varchar, Accident_Date, 101) as Accident_Date,
ISNULL(convert(varchar, DateOfService_Start,101),'') as DateOfService_Start,
ISNULL(convert(varchar, DateOfService_End,101),'') as DateOfService_End,
Status,
Initial_Status,
Ins_Claim_Number,
convert(decimal(38,2),convert(float,Claim_Amount) - convert(float,Paid_Amount)) as Claim_Amount,
'' AS ClickMe
From tblcase  
inner join tblProvider  on tblcase.provider_id=tblProvider.provider_id and tblcase.DomainId=tblProvider.DomainId
inner join tblInsuranceCompany  on tblcase.insurancecompany_id=tblInsuranceCompany.insurancecompany_id  and tblcase.DomainId=tblInsuranceCompany.DomainId
WHERE 
 1=1
 AND tblcase.DomainId=@DomainId
AND (@strOldCaseId = '' OR Case_Code like '%' + @strOldCaseId +'%')
	AND (@strCaseId = '' OR Case_Id like '%' + @strCaseId +'%' )
	AND (@InjuredParty_LastName ='' OR InjuredParty_LastName like '%'+ @InjuredParty_LastName + '%')
	AND (@InjuredParty_FirstName ='' OR InjuredParty_FirstName like '%'+ @InjuredParty_FirstName + '%')
	AND (@InsuredParty_LastName ='' OR InsuredParty_LastName like '%'+ @InsuredParty_LastName + '%')
	AND (@InsuredParty_FirstName ='' OR InsuredParty_FirstName like '%'+ @InsuredParty_FirstName + '%')
	AND (@Policy_Number ='' OR Policy_Number like '%'+ @Policy_Number + '%')
	AND (@Ins_Claim_Number ='' OR Ins_Claim_Number like '%'+ @Ins_Claim_Number + '%')
	AND (@IndexOrAAA_Number ='' OR IndexOrAAA_Number like '%'+ @IndexOrAAA_Number + '%')		
	AND (@Status = '' OR @Status = '0' OR Status = @Status)
	AND (@strMultipleValues ='' OR Case_Id in (SELECT CASEID FROM @tblCaseTemp))
	AND (@strMultipleNames ='' OR InjuredParty_FirstName+' '+InjuredParty_LastName in (SELECT NAMES FROM @tblNames)) 
ORDER BY Case_AutoId DESC

end
--**************** End of Procedure LCJ_WorkArea_SearchCaseSimple **********************

