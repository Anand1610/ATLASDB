CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchCaseSimpleOnAwardedAmount](
	@DomainId nvarchar(50),
	@strCaseId nvarchar(50),
	@strOldCaseId nvarchar(20), 
	@Status nvarchar(50),  
	@InjuredParty_LastName nvarchar(50),  
	@InjuredParty_FirstName nvarchar(50),  
	@InsuredParty_LastName nvarchar(50),  
	@InsuredParty_FirstName nvarchar(50),  
	@Policy_Number nvarchar(100),
	@Ins_Claim_Number nvarchar(100),
	@IndexOrAAA_Number nvarchar(100),  
	@StartId nvarchar(50),  
	@EndId nvarchar(50),  
	@ExcludeIds nvarchar(1000),
	@UserType nvarchar(10),          
	@UserTypeLogin nvarchar(100),
	@InsuranceCompany_Id nvarchar(100),
	@Provider_Id nvarchar(200)
)  
AS
DECLARE @strsql as nvarchar(4000)
begin  
  
	set @strsql = 'select    
	top 100 Case_Id as Edit,  
	Case_Id as Case_Id,
	(InjuredParty_FirstName + '' '' + InjuredParty_LastName) as InjuredParty_Name,  
	Provider_Name, 
	isnull(claim_amount,0.0),
	InsuranceCompany_Name,  
	convert(varchar, hearing_date, 101) as Hearing_Date,
	Status,
	isnull(flt_amount_awarded,0.0) as Amount_Awarded
	From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
	WHERE 1=1 and DomainId='''+@DomainId+''''
  
	if @strOldCaseId <> ''
	begin
		set @strsql = @strsql + ' AND Old_Case_Id Like ''%' + @strOldCaseId + '%'''             
	end

	if @strCaseId <> ''  
	begin  
		set @strsql = @strsql + ' AND Case_Id Like ''%' + @strCaseId + '%'''               
	end  

	if @Status <> '' and @Status <> '0' and @Status <> 'all'  
	begin  
		set @strsql = @strsql + '  AND STATUS = ''' + @Status + ''''         
	end  

	if @InjuredParty_LastName <> ''   
	begin  
		set @strsql = @strsql + '  AND InjuredParty_LastName Like ''%' + @InjuredParty_LastName + '%'''           
	end  
  
	if @InjuredParty_FirstName <> ''   
	begin  
		set @strsql = @strsql + '  AND InjuredParty_FirstName Like ''%' + @InjuredParty_FirstName + '%'''  
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
  
	if @IndexOrAAA_Number <> ''  
	begin  
		set @strsql = @strsql + '  AND IndexOrAAA_Number LIKE ''%' + @IndexOrAAA_Number + '%'''  
	end  
  
	if (@StartId <> '')  
	Begin  
		set @strsql = @strsql +  ' AND case_id >= ''' + @StartId + ''''  
	End   
  
	If (@EndId <> '')   
	Begin  
		set @strsql = @strsql +  ' AND case_id <= ''' + @EndId + ''''  
	End  

	If (@ExcludeIds <> '')  
	Begin  
		set @strsql = @strsql +  ' And case_id not in (''' + Replace(@ExcludeIds,',',''',''') + ''')'   
	End 

	if @userType = 'P'          
	begin          
		set @strsql = @strsql + ' AND tblcase.Provider_Id = ''' + @userTypeLogin + ''''          
	end   
	else 
	if @userType = 'I'          
	begin          
		set @strsql = @strsql + ' AND tblcase.InsuranceCompany_Id = ''' + @userTypeLogin + ''''          
	end
	else 
	if @userType = 'S'          
	begin          
		set @strsql = @strsql          
	end     
	if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> ''        
	begin        
		set @strsql = @strsql + '  AND tblcase.InsuranceCompany_Id = ''' + @InsuranceCompany_Id + ''''        
	end
	if @Provider_Id <> '0' and @Provider_Id <> ''        
	begin        
		set @strsql = @strsql + '  AND tblcase.Provider_Id =''' + @Provider_Id + ''''        
	end
	SET @strsql = @strsql + ' AND (tblcase.FLT_AMOUNT_AWARDED - isnull(paid_amount,0.0)) > 0'
	SET @strsql = @strsql + ' order by date_opened desc'  
	
	exec (@strsql)
end

