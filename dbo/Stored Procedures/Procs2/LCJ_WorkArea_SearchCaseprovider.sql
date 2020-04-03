
CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchCaseprovider]--[LCJ_WorkArea_SearchCaseprovider]'','','','','P','Test','test','',''
(
	@DomainId nvarchar(50),
	@strCaseId nvarchar(50),	
	@Status nvarchar(50),
	@InjuredParty_LastName nvarchar(50),
	@InjuredParty_FirstName nvarchar(50),	
	@UserType nvarchar(10),
	@UserTypeLogin nvarchar(100),
	@UserName varchar(50),
	@InsuranceCompany_Id nvarchar(100),
	@Provider_Id nvarchar(200)	
)
AS
	DECLARE @UID AS VARCHAR(50)
	SET @UID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE UserName=@UserName and DomainId=@DomainId)
DECLARE @strsql as nvarchar(4000)  
begin  
	set @strsql = 'select    
	top 5000   
	Case_Id as Case_Id,
	(InjuredParty_FirstName + '' '' + InjuredParty_LastName) as InjuredParty_Name,  
	Provider_Name, 	
	InsuranceCompany_Name,  	
	Status,
	initial_status [current status]  
	From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id inner 
    join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
	INNER JOIN TXN_PROVIDER_LOGIN ON tblcase.provider_id = TXN_PROVIDER_LOGIN.provider_id
	WHERE 1=1  AND DomainId= '''+@DomainId+''' AND TXN_PROVIDER_LOGIN.user_id = ' + @UID
  
	if @strCaseId <> ''  
	begin  
		set @strsql = @strsql + ' AND Case_Id Like ''%' + @strCaseId + '%'''               
	end 
	if @UID = 354
	begin  
		set @strsql = @strsql + ' AND Case_Id like ''%MDM%'' '               
	end	 
	if @Status <> '' and @Status <> '0' and @Status <> 'all' and @Status <> '...Select Status...'
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
	
	--if @userType = 'P'          
	--begin          
	--	set @strsql = @strsql + ' AND tblcase.Provider_Id = ''' + @Provider_Id + ''''          
	--end          
--	else
--
--	if @userType = 'I'          
--	begin          
--		set @strsql = @strsql + ' AND tblcase.InsuranceCompany_Id = ''' + @InsuranceCompany_Id + ''''          
--	end          
--	           
--	else if @userType = 'S'          
--	begin          
--		set @strsql = @strsql          
--	end          
	
	if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> ''        
	begin        
		set @strsql = @strsql + '  AND tblcase.InsuranceCompany_Id = ''' + @InsuranceCompany_Id + ''''        
	end
	    
	if @Provider_Id <> '0' and @Provider_Id <> ''        
	begin        
		set @strsql = @strsql + '  AND tblcase.Provider_Id =''' + @Provider_Id + ''''
	end 
    
  	SET @strsql = @strsql + ' order by case_autoid desc'    
	--print @strsql   
	exec (@strsql)
end



--select    
--	top 5000   
--	Case_Id as Case_Id,
--	(InjuredParty_FirstName + ' ' + InjuredParty_LastName) as InjuredParty_Name,  
--	Provider_Name, 	
--	InsuranceCompany_Name,  	
--	Status,
--	initial_status [current status]  
--	From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id inner 
--    join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
--	INNER JOIN TXN_PROVIDER_LOGIN ON tblcase.provider_id = TXN_PROVIDER_LOGIN.provider_id
--	WHERE 1=1 AND TXN_PROVIDER_LOGIN.user_id ='349' 

