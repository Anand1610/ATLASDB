
CREATE PROCEDURE [dbo].[Auto_Case_Rules_Insert] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		TRUNCATE TABLE Auto_Case_Rules

		DECLARE @TotalCount INT = 0
		DECLARE @Counter INT = 1

		DECLARE @s_l_Rule_Desc VARCHAR(max)
		DECLARE @i_l_ProviderID int
		DECLARE @i_l_InsuranceComp_ID int
		DECLARE @s_l_Provider_Group VARCHAR(100)
		DECLARE @s_l_Insurance_Group VARCHAR(100)
		DECLARE @s_l_Category VARCHAR(50)
		DECLARE @s_l_DomainID VARCHAR(50)
		

		DECLARE @t_rules AS TABLE
		(
			ID INT IDENTITY(1,1),
			Rules_ID INT,
			Rule_Desc VARCHAR(max),
			Provider_ID INT,
			InsuranceCompany_ID INT,
			Provider_Group VARCHAR(100),
			InsuranceCompany_Group VARCHAR(100),
			Category VARCHAR(100),
			DomainID VARCHAR(100)
		)

		INSERT INTO @t_rules

		SELECT Rules_ID	
		, Rules_Disc	
		, Provider_ID	
		, InsuranceCompanyID	
		, Provider_Group	
		, Insurance_Group
		, DomainId
		, Category
		FROM Tbl_Rules 
		WHERE ISNULL(Provider_ID,0) <> 0	
			OR ISNULL(InsuranceCompanyID,0) <> 0
			OR ISNULL(Provider_Group, '') <> ''
			OR ISNULL(Insurance_Group,'') <> ''

		
		SELECT @TotalCount = COUNT(*) FROM @t_rules
		WHILE(@Counter <= @TotalCount)
		BEGIN
			DECLARE @i_rule_id int
			SELECT 
			@s_l_Rule_Desc = Rule_Desc,
			@i_l_ProviderID = Provider_ID,
			@i_l_InsuranceComp_ID = InsuranceCompany_ID,
			@s_l_Provider_Group = Provider_Group,
			@s_l_Insurance_Group = InsuranceCompany_Group,
			@s_l_Category = Category,
			@s_l_DomainID = DomainID ,
			@i_rule_id = Rules_ID 
			FROM @t_rules	 WHERE ID = @Counter

			Print @s_l_Rule_Desc
			Print '----'
			print @i_rule_id
			INSERT INTO Auto_Case_Rules (case_id , rule_desc, domainid)
			SELECT case_ID,  @s_l_Rule_Desc, cas.DomainId
			FROM dbo.tblCase cas
			INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id 
			INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id			 
			WHERE 
				(@i_l_ProviderID = 0 OR pro.Provider_Id = @i_l_ProviderID)
			AND (@i_l_InsuranceComp_ID = 0 OR ins.InsuranceCompany_Id = @i_l_InsuranceComp_ID)
			AND (@s_l_Provider_Group = '' OR pro.Provider_GroupName = @s_l_Provider_Group)
			AND (@s_l_Insurance_Group = '' OR ins.InsuranceCompany_GroupName = @s_l_Insurance_Group)
				

			Print @Counter
			-- Reight your logic here		
			SET @Counter = @Counter + 1
			SET @s_l_Rule_Desc = NULL
			SET @i_l_ProviderID = NULL
			SET @i_l_InsuranceComp_ID = NULL
			SET @s_l_Provider_Group = NULL
			SET @s_l_Insurance_Group = NULL 
			SET @s_l_Category = NULL 
			SET @s_l_DomainID = NULL  
		END

	
END
