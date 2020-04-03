--**************** Start of procedure [LCJ_DDL_InsuranceCompanyNamesByUserTypeLogin] **********************
/*Previously called LCJ_DDL_InsurerNames */

CREATE PROCEDURE [dbo].[LCJ_DDL_InsuranceCompanyNamesByUserTypeLogin]

	(
	@DomainId NVARCHAR(50),
		--@parameter1 datatype = default value,
		--@parameter2 datatype OUTPUT
		@UserType Nvarchar(10),
		@UserTypeLogin Nvarchar(100)
	)

AS
--ALTER TABLE #tmpInsuranceCompanyNames
--	(InsuranceCompany_Id nvarchar(100), InsuranceCompany_Name varchar(400))

begin

IF @UserType = 'I'

	BEGIN
--	insert into #tmpClientNames values(Null, Null)
--			insert into #tmpInsuranceCompanyNames values(Null, Null)
--			insert into #tmpInsuranceCompanyNames values(0,'...Select Insurance Company...')
--			insert into #tmpInsuranceCompanyNames
--			
				SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
				FROM         tblInsuranceCompany
				WHERE    InsuranceCompany_Id = @UserTypeLogin and DomainId=@DomainId and active <> 0 order by InsuranceCompany_Name

			
--				SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
--				FROM         tblInsuranceCompany
--				WHERE    InsuranceCompany_Id = @UserTypeLogin order by InsuranceCompany_Name

			
--			select InsuranceCompany_Id, InsuranceCompany_Name from #tmpInsuranceCompanyNames order by 2
--			drop table #tmpInsuranceCompanyNames
	
	END
Else
	
	BEGIN
	
--			insert into #tmpInsuranceCompanyNames values(Null, Null)
--			insert into #tmpInsuranceCompanyNames values(0,'...Select Insurance Company...')
--			insert into #tmpInsuranceCompanyNames		
--				SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
--				FROM         tblInsuranceCompany
--				order by 2
			
--			select InsuranceCompany_Id, InsuranceCompany_Name from #tmpInsuranceCompanyNames order by 2
--			drop table #tmpInsuranceCompanyNames
	

			select null as InsuranceCompany_Id,null as InsuranceCompany_Name
			union
			select 0 as InsuranceCompany_Id,'...Select Insurance Company...' as InsuranceCompany_Name
			union
			SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
			FROM         tblInsuranceCompany where  ActiveStatus <> 0  and DomainId=@DomainId--and active <> 0 
			order by 2
	
	END
end

--**************** End of [LCJ_DDL_InsuranceCompanyNamesByUserTypeLogin] **********************

