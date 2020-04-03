CREATE PROCEDURE [dbo].[USP_SearchProviderCase] 
-- [USP_SearchProviderCase] '','','','','','','','',2007,0,'',0,'priya'
( 
@strCaseId                              nvarchar(50)=null,
@Status                                 nvarchar(50),
@InjuredParty_LastName               	nvarchar(50)=null,
@InjuredParty_FirstName               	nvarchar(50)=null,
@InsuredParty_LastName              	nvarchar(50)=null,
@InsuredParty_FirstName              	nvarchar(50)=null,
@Policy_Number                          nvarchar(100)=null,
@Ins_Claim_Number                       nvarchar(100)=null,
@Provider_Id							int=0,
@InsuranceCompany_Id					int=0,
@SZ_USER_ID						NVARCHAR(50),
@DomainId								NVARCHAR(50)
)
AS

begin

SET @strCaseId=(LTRIM(RTRIM(@strCaseId)))
 
DECLARE @strsql_cursor as nvarchar(max)  
DECLARE @strsql as nvarchar(max)


set @strsql = 'select top 5000 tblProviderCase.Case_Id as Edit,tblProviderCase.Case_Id as upload, Case_Id,  
(ClaimantParty_LastName + '','' + ClaimantParty_FirstName) as InjuredParty_Name,
Provider_Name,
InsuranceCompany_Name,
convert(varchar, Incident_Date, 101) as Incident_Date,
convert(varchar, ISNULL(tblProviderCase.DateOfService_Start,''''),101) as DateOfService_Start,
convert(varchar, ISNULL(tblProviderCase.DateOfService_End,''''),101) as DateOfService_End,
Status,
Ins_Claim_Number,
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
(Select top 1 a.Case_Id FROM  tblProviderCase a WHERE a.Provider_Id =tblProviderCase.Provider_Id  and a.ClaimantParty_LastName =tblProviderCase.ClaimantParty_LastName
and a.ClaimantParty_FirstName = tblProviderCase.ClaimantParty_FirstName and  a.Incident_Date =tblProviderCase.Incident_Date  
and a.Case_Id <> tblProviderCase.case_id) AS Similar_To_Case_ID

From tblProviderCase as tblProviderCase inner join tblprovider as tblprovider on tblProviderCase.provider_id=tblprovider.provider_id 
inner join tblinsurancecompany as tblinsurancecompany on tblProviderCase.insurancecompany_id=tblinsurancecompany.insurancecompany_id 

WHERE 1=1 and   tblProviderCase.Provider_Id=''' + Convert(VARCHAR,@Provider_Id )+''' AND  tblProviderCase.DomainId= '''+@DomainId+'''  '

			if @strCaseId <> ''
			begin
                set @strsql = @strsql + ' AND tblProviderCase.Case_Id Like ''%' + @strCaseId + '%'''             
			end
			
			if @InjuredParty_LastName <> '' 
			begin
                set @strsql = @strsql + '  AND ClaimantParty_LastName Like ''%' + @InjuredParty_LastName + '%'''         
			end

			if @InjuredParty_FirstName <> '' 
			begin
                set @strsql = @strsql + '  AND ClaimantParty_FirstName Like ''%' + @InjuredParty_FirstName + '%'''
			end

			if @InsuredParty_LastName <> '' 
			begin
               set @strsql = @strsql + '  AND InsuredParty_LastName Like ''%' + @InsuredParty_LastName + '%'''
			end
			 
			if @InsuredParty_FirstName <> '' 
			begin
                set @strsql = @strsql + '  AND InsuredParty_FirstName Like ''%' + @InsuredParty_FirstName + '%'''
			end

			if @Policy_Number <> ''
			begin
                set @strsql = @strsql + '  AND Policy_Number= ''' + @Policy_Number + ''''
			end
			
			if @Ins_Claim_Number <> ''
			begin
               set @strsql = @strsql + '  AND Ins_Claim_Number= ''' + @Ins_Claim_Number + ''''
			end
		
			If (@InsuranceCompany_Id <> 0) 
			Begin
				set @strsql = @strsql +  ' AND tblProviderCase.InsuranceCompany_Id  = ''' + Convert(VARCHAR,@InsuranceCompany_Id) + ''''
			End
				   

			SET @strsql = @strsql + ' order by case_autoid desc'	


print @strsql 
exec (@strsql)

end

