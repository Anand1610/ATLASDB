--**************** Start of procedure [LCJ_DDL_InsuranceCompanyNamesByUserTypeLogin] **********************
/*Previously called LCJ_DDL_InsurerNames */

CREATE PROCEDURE [dbo].[LCJ_DDL_InsuranceCompanyNamesByUserTypeLogin_DE]/* FOR DATA ENTRY SCREEN ONLY */

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
		SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
		FROM         tblInsuranceCompany
		WHERE    (InsuranceCompany_Id = @UserTypeLogin) and Active = 2 and DomainId=@DomainId order by InsuranceCompany_Name
	
	END
	Else
	BEGIN
		select null as InsuranceCompany_Id,null as InsuranceCompany_Name
		union
		select 0 as InsuranceCompany_Id,'...Select Insurance Company...' as InsuranceCompany_Name
		union
		SELECT  DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
		FROM  tblInsuranceCompany  where  ActiveStatus <> 0 and DomainId=@DomainId-- and Active = 2
		order by 2
	END
end

--**************** End of [LCJ_DDL_InsuranceCompanyNamesByUserTypeLogin] **********************

