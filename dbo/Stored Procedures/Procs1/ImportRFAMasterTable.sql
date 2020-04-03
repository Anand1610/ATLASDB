
CREATE PROCEDURE [dbo].[ImportRFAMasterTable] (
	@provider ProviderImport READONLY
	,@DomainID VARCHAR(20)
	,@Flag BIT
	)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @BeforeInsertCount INT
		DECLARE @NewInsertCount INT
		DECLARE @AfterInsertCount INT
		DECLARE @Description VARCHAR(255)

		PRINT '1'

		SELECT *
		INTO #Provider
		FROM @provider

		SET @AfterInsertCount = @@ROWCOUNT
		SET @Description = 'Total Count Of Providers to Import Data is ' + CAST(@AfterInsertCount AS VARCHAR(5))

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@Description)

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = '#tblInsuranceCompanyGroup_rfa_import_temp'
					)
			BEGIN
				DROP TABLE #tblInsuranceCompanyGroup_rfa_import_temp
			END

			SELECT DISTINCT ig.*
			INTO #tblInsuranceCompanyGroup_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.tblInsuranceCompany i ON c.InsuranceCompany_Id = i.InsuranceCompany_Id
			JOIN [RFA_Atlas].dbo.tblInsuranceCompanyGroup ig ON ig.InsuranceCompanyGroup_ID = i.FK_INSURANCE_GROUP_ID
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsuranceCompanyGroup
			WHERE DomainId = @DomainID

			PRINT '8'

			INSERT INTO tblInsuranceCompanyGroup (
				InsuranceCompanyGroup_Name
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT #tblInsuranceCompanyGroup_rfa_import_temp.InsuranceCompanyGroup_Name
				,@DomainID
				,'admin'
				,getdate()
			FROM #tblInsuranceCompanyGroup_rfa_import_temp
			LEFT JOIN tblInsuranceCompanyGroup ON #tblInsuranceCompanyGroup_rfa_import_temp.InsuranceCompanyGroup_Name = tblInsuranceCompanyGroup.InsuranceCompanyGroup_Name
				AND tblInsuranceCompanyGroup.DomainId = @DomainID
			WHERE tblInsuranceCompanyGroup.InsuranceCompanyGroup_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '9'

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblInsuranceCompanyGroup
			WHERE DomainId = @DomainID

			SET @Description = 'tblInsuranceCompanyGroup : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsuranceCompanyGroup
			WHERE DomainId = @DomainID

			SET @Description = 'tblInsuranceCompanyGroup : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = '#tblInsurance_TPA_Group_rfa_import_temp'
					)
			BEGIN
				DROP TABLE #tblInsurance_TPA_Group_rfa_import_temp
			END

			SELECT DISTINCT ig.*
			INTO #tblInsurance_TPA_Group_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.tblInsuranceCompany i ON c.InsuranceCompany_Id = i.InsuranceCompany_Id
			JOIN [RFA_Atlas].dbo.tblInsurance_TPA_Group ig ON ig.PK_TPA_Group_ID = i.fk_TPA_Group_ID
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsurance_TPA_Group
			WHERE DomainId = @DomainID

			PRINT '10'

			INSERT INTO tblInsurance_TPA_Group (
				TPA_Group_Name
				,Address
				,City
				,STATE
				,ZipCode
				,Email
				,created_by_user
				,created_date
				,DomainId
				,IsActive
				)
			SELECT #tblInsurance_TPA_Group_rfa_import_temp.TPA_Group_Name
				,''
				,''
				,''
				,''
				,''
				,'admin'
				,getdate()
				,@DomainID
				,1
			FROM #tblInsurance_TPA_Group_rfa_import_temp
			LEFT JOIN tblInsurance_TPA_Group ON tblInsurance_TPA_Group.TPA_Group_Name = #tblInsurance_TPA_Group_rfa_import_temp.TPA_Group_Name
				AND tblInsurance_TPA_Group.DomainId = @DomainID
			WHERE tblInsurance_TPA_Group.TPA_Group_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '11'

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblInsurance_TPA_Group
			WHERE DomainId = @DomainID

			SET @Description = 'tblInsurance_TPA_Group : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsurance_TPA_Group
			WHERE DomainId = @DomainID

			SET @Description = 'tblInsurance_TPA_Group : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblInsuranceGroup_Type_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblInsuranceGroup_Type_rfa_import_temp
			END

			SELECT *
			INTO tblInsuranceGroup_Type_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblInsuranceGroup_Type

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsuranceGroup_Type
			WHERE DOMAIN_ID = @DomainID

			PRINT '12'

			INSERT INTO tblInsuranceGroup_Type (
				INSURANCE_TYPE_NAME
				,DOMAIN_ID
				)
			SELECT t1.INSURANCE_TYPE_NAME
				,@DomainID
			FROM [RFA_Atlas].dbo.tblInsuranceGroup_Type t1
			LEFT JOIN tblInsuranceGroup_Type t2 ON t1.INSURANCE_TYPE_NAME = t2.INSURANCE_TYPE_NAME
			WHERE t2.INSURANCE_TYPE_NAME IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '13'

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblInsuranceGroup_Type
			WHERE DOMAIN_ID = @DomainID

			SET @Description = 'tblInsuranceGroup_Type : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsuranceGroup_Type
			WHERE DOMAIN_ID = @DomainID

			SET @Description = 'tblInsuranceGroup_Type : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblInsuranceCompany_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblInsuranceCompany_rfa_import_temp
			END

			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblInsuranceCompany_rfa_import_temp1'
					)
			BEGIN
				DROP TABLE tblInsuranceCompany_rfa_import_temp1
			END

			SELECT DISTINCT MAX(tic.InsuranceCompany_Id) [InsuranceCompany_Id]
				,ltrim(rtrim(replace(replace(Replace(tic.InsuranceCompany_Name, ',', ''), '.', ''), '&', ''))) [InsuranceCompany_Name]
				,ltrim(rtrim(replace(replace(Replace(tic.InsuranceCompany_Local_Address, ',', ''), '.', ''), '&', ''))) [InsuranceCompany_Local_Address]
			INTO #tempInsurance
			FROM [RFA_Atlas].dbo.tblCase tc
			JOIN [RFA_Atlas].dbo.tblInsuranceCompany tic(NOLOCK) ON tic.InsuranceCompany_Id = tc.InsuranceCompany_Id
			WHERE tc.Provider_Id IN (
					SELECT RFA_PROVIDER_ID
					FROM dbo.RFA_JL_PROVIDERID_MAPPING
					)
			GROUP BY ltrim(rtrim(replace(replace(Replace(tic.InsuranceCompany_Name, ',', ''), '.', ''), '&', '')))
				,ltrim(rtrim(replace(replace(Replace(tic.InsuranceCompany_Local_Address, ',', ''), '.', ''), '&', '')))
			ORDER BY InsuranceCompany_Name
				,InsuranceCompany_Local_Address

			SELECT DISTINCT i.*
			INTO tblInsuranceCompany_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.tblInsuranceCompany i ON c.InsuranceCompany_Id = i.InsuranceCompany_Id
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT DISTINCT i.*
			INTO tblInsuranceCompany_rfa_import_temp1
			FROM [RFA_Atlas].dbo.tblInsuranceCompany i
			JOIN #tempInsurance ti ON ti.InsuranceCompany_Id = i.InsuranceCompany_Id

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsuranceCompany
			WHERE DomainId = @DomainID

			PRINT '14'

			INSERT INTO tblInsuranceCompany (
				InsuranceCompany_Name
				,InsuranceCompany_SuitName
				,InsuranceCompany_Type
				,InsuranceCompany_Local_Address
				,InsuranceCompany_Local_City
				,InsuranceCompany_Local_State
				,InsuranceCompany_Local_Zip
				,InsuranceCompany_Local_Phone
				,InsuranceCompany_Local_Fax
				,InsuranceCompany_Perm_Address
				,InsuranceCompany_Perm_City
				,InsuranceCompany_Perm_State
				,InsuranceCompany_Perm_Zip
				,InsuranceCompany_Perm_Phone
				,InsuranceCompany_Perm_Fax
				,InsuranceCompany_Contact
				,InsuranceCompany_Email
				,InsuranceCompany_GroupName
				,Active
				,SZ_SHORT_NAME
				,BILLING_ADDRESS
				,BILLING_CITY
				,BILLING_STATE
				,BILLING_ZIP
				,ActiveStatus
				,InsuranceCompany_Initial_Address
				,InsuranceCompany_Initial_City
				,InsuranceCompany_Initial_State
				,InsuranceCompany_Initial_Zip
				,InsuranceCompany_Address2_Address
				,InsuranceCompany_Address2_City
				,InsuranceCompany_Address2_State
				,InsuranceCompany_Address2_Zip
				,InsuranceCompany_Address2_Phone
				,InsuranceCompany_Address2_Fax
				,gbb_status
				,gbb_initial_status
				,RCF_initial_status
				,DomainId
				,InsuranceCompanyGroup_ID
				,fk_TPA_Group_ID
				,Now_Known_As
				,Notes
				)
			--,FK_INSURANCE_TYPE_ID
			SELECT DISTINCT tit.InsuranceCompany_Name
				,tit.InsuranceCompany_SuitName
				,tit.InsuranceCompany_Type
				,tit.InsuranceCompany_Local_Address
				,tit.InsuranceCompany_Local_City
				,tit.InsuranceCompany_Local_State
				,tit.InsuranceCompany_Local_Zip
				,tit.InsuranceCompany_Local_Phone
				,tit.InsuranceCompany_Local_Fax
				,tit.InsuranceCompany_Perm_Address
				,tit.InsuranceCompany_Perm_City
				,tit.InsuranceCompany_Perm_State
				,tit.InsuranceCompany_Perm_Zip
				,tit.InsuranceCompany_Perm_Phone
				,tit.InsuranceCompany_Perm_Fax
				,tit.InsuranceCompany_Contact
				,tit.InsuranceCompany_Email
				,tit.InsuranceCompany_GroupName
				,tit.Active
				,tit.SZ_SHORT_NAME
				,tit.BILLING_ADDRESS
				,tit.BILLING_CITY
				,tit.BILLING_STATE
				,tit.BILLING_ZIP
				,tit.ActiveStatus
				,tit.InsuranceCompany_Initial_Address
				,tit.InsuranceCompany_Initial_City
				,tit.InsuranceCompany_Initial_State
				,tit.InsuranceCompany_Initial_Zip
				,tit.InsuranceCompany_Address2_Address
				,tit.InsuranceCompany_Address2_City
				,tit.InsuranceCompany_Address2_State
				,tit.InsuranceCompany_Address2_Zip
				,tit.InsuranceCompany_Address2_Phone
				,tit.InsuranceCompany_Address2_Fax
				,tit.gbb_status
				,tit.gbb_initial_status
				,tit.RCF_initial_status
				,@DomainID
				,tblInsuranceCompanyGroup.InsuranceCompanyGroup_ID
				,tblInsurance_TPA_Group.PK_TPA_Group_ID
				,tit.Now_Known_As
				,tit.Notes
			--,tblInsuranceGroup_Type.PK_INSURANCE_TYPE_ID
			FROM tblInsuranceCompany_rfa_import_temp1 tit
			--JOIN #tempInsurance ti ON ti.InsuranceCompany_Name = tblInsuranceCompany_rfa_import_temp.InsuranceCompany_Name
			LEFT JOIN tblInsuranceCompany ON tblInsuranceCompany.InsuranceCompany_Name = tit.InsuranceCompany_Name
				--AND tblInsuranceCompany.InsuranceCompany_Local_Address = tblInsuranceCompany_rfa_import_temp.InsuranceCompany_Local_Address
				AND tblInsuranceCompany.DomainId = @DomainID
			LEFT JOIN #tblInsurance_TPA_Group_rfa_import_temp ON #tblInsurance_TPA_Group_rfa_import_temp.PK_TPA_Group_ID = tit.fk_TPA_Group_ID
			LEFT JOIN tblInsurance_TPA_Group ON tblInsurance_TPA_Group.TPA_Group_Name = #tblInsurance_TPA_Group_rfa_import_temp.TPA_Group_Name
				AND tblInsurance_TPA_Group.DomainId = @DomainID
			LEFT JOIN #tblInsuranceCompanyGroup_rfa_import_temp ON #tblInsuranceCompanyGroup_rfa_import_temp.InsuranceCompanyGroup_ID = tit.FK_INSURANCE_GROUP_ID
			LEFT JOIN tblInsuranceCompanyGroup ON #tblInsuranceCompanyGroup_rfa_import_temp.InsuranceCompanyGroup_Name = tblInsuranceCompanyGroup.InsuranceCompanyGroup_Name
				AND tblInsuranceCompanyGroup.DomainId = @DomainID
			LEFT JOIN tblInsuranceGroup_Type_rfa_import_temp ON tblInsuranceGroup_Type_rfa_import_temp.PK_INSURANCE_TYPE_ID = tit.FK_INSURANCE_TYPE_ID
			LEFT JOIN tblInsuranceGroup_Type ON tblInsuranceGroup_Type_rfa_import_temp.INSURANCE_TYPE_NAME = tblInsuranceGroup_Type.INSURANCE_TYPE_NAME
			WHERE tblInsuranceCompany.InsuranceCompany_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '15'

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblInsuranceCompany
			WHERE DomainId = @DomainID

			SET @Description = 'tblInsuranceCompany : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblInsuranceCompany
			WHERE DomainId = @DomainID

			SET @Description = 'tblInsuranceCompany : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblDefendant_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblDefendant_rfa_import_temp
			END

			SELECT DISTINCT d.*
			INTO tblDefendant_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.tblDefendant d ON c.Defendant_Id = d.Defendant_id
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblDefendant
			WHERE DomainId = @DomainID

			PRINT '16'

			INSERT INTO tblDefendant (
				Defendant_Name
				,Defendant_DisplayName
				,Defendant_Address
				,Defendant_City
				,Defendant_State
				,Defendant_Zip
				,Defendant_Phone
				,Defendant_Fax
				,Defendant_Email
				,active
				,created_by_user
				,created_date
				,modified_by_user
				,modified_date
				,DomainId
				)
			SELECT tblDefendant_rfa_import_temp.Defendant_Name
				,tblDefendant_rfa_import_temp.Defendant_DisplayName
				,tblDefendant_rfa_import_temp.Defendant_Address
				,tblDefendant_rfa_import_temp.Defendant_City
				,tblDefendant_rfa_import_temp.Defendant_State
				,tblDefendant_rfa_import_temp.Defendant_Zip
				,tblDefendant_rfa_import_temp.Defendant_Phone
				,tblDefendant_rfa_import_temp.Defendant_Fax
				,tblDefendant_rfa_import_temp.Defendant_Email
				,tblDefendant_rfa_import_temp.active
				,'Admin'
				,Getdate()
				,''
				,NULL
				,@DomainID
			FROM tblDefendant_rfa_import_temp
			LEFT JOIN tblDefendant ON tblDefendant.Defendant_Name = tblDefendant_rfa_import_temp.Defendant_Name
				AND tblDefendant.DomainId = @DomainID
			WHERE tblDefendant.Defendant_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '17'

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblDefendant
			WHERE DomainId = @DomainID

			SET @Description = 'tblDefendant : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblDefendant
			WHERE DomainId = @DomainID

			SET @Description = 'tblDefendant : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'Adjusters_rfa_import_temp'
					)
			BEGIN
				DROP TABLE Adjusters_rfa_import_temp
			END

			SELECT DISTINCT a.*
			INTO Adjusters_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.Adjusters a ON c.Adjuster_Id = a.Adjuster_Id
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT @BeforeInsertCount = COUNT(*)
			FROM Adjusters
			WHERE DomainId = @DomainID

			PRINT '18'

			INSERT INTO Adjusters (
				Adjuster_LastName
				,Adjuster_FirstName
				,InsuranceCompany_Id
				,Adjuster_Phone
				,Adjuster_Fax
				,Adjuster_Email
				,Adjuster_Extension
				,Adjuster_Address
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT Adjusters_rfa_import_temp.Adjuster_LastName
				,Adjusters_rfa_import_temp.Adjuster_FirstName
				,Adjusters_rfa_import_temp.InsuranceCompany_Id
				,Adjusters_rfa_import_temp.Adjuster_Phone
				,Adjusters_rfa_import_temp.Adjuster_Fax
				,Adjusters_rfa_import_temp.Adjuster_Email
				,Adjusters_rfa_import_temp.Adjuster_Extension
				,Adjusters_rfa_import_temp.Adjuster_Address
				,@DomainID
				,'Admin'
				,Getdate()
			FROM Adjusters_rfa_import_temp
			LEFT JOIN Adjusters ON Adjusters.Adjuster_LastName = Adjusters_rfa_import_temp.Adjuster_LastName
				AND Adjusters.Adjuster_FirstName = Adjusters_rfa_import_temp.Adjuster_FirstName
				AND Adjusters.DomainId = @DomainID
			WHERE Adjusters.Adjuster_LastName IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '19'

			SELECT @AfterInsertCount = COUNT(*)
			FROM Adjusters
			WHERE DomainId = @DomainID

			SET @Description = 'Adjusters : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM Adjusters
			WHERE DomainId = @DomainID

			SET @Description = 'Adjusters : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblCourt_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblCourt_rfa_import_temp
			END

			SELECT DISTINCT ct.*
			INTO tblCourt_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.tblCourt ct ON c.Court_Id = ct.Court_Id
			JOIN #Provider m ON c.Provider_Id = m.ProviderId
			WHERE ISNULL(ct.Court_Name, '') <> ''

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblcourt
			WHERE DomainId = @DomainID

			PRINT '20'

			INSERT INTO tblcourt (
				Court_Name
				,Court_Venue
				,Court_Address
				,Court_Basis
				,Court_Misc
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT tblCourt.Court_Name
				,tblCourt.Court_Venue
				,tblCourt.Court_Address
				,tblCourt.Court_Basis
				,tblCourt.Court_Misc
				,@DomainId
				,'admin'
				,getdate()
			FROM tblCourt_rfa_import_temp
			LEFT JOIN tblCourt ON tblCourt.Court_Name = tblCourt_rfa_import_temp.Court_Name
				AND tblCourt.DomainId = @DomainID
			WHERE tblCourt.Court_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '21'

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblcourt
			WHERE DomainId = @DomainID

			SET @Description = 'tblcourt : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblcourt
			WHERE DomainId = @DomainID

			SET @Description = 'tblcourt : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblAttorney_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblAttorney_rfa_import_temp
			END

			SELECT DISTINCT a.*
			INTO tblAttorney_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.tblAttorney a ON c.Attorney_Id = a.Attorney_AutoId
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			PRINT '22'

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.tblAttorney
			WHERE DomainId = @DomainID

			INSERT INTO dbo.tblAttorney (
				Attorney_Id
				,Attorney_LastName
				,Attorney_FirstName
				,Attorney_Address
				,Attorney_City
				,Attorney_State
				,Attorney_Zip
				,Attorney_Phone
				,Attorney_Fax
				,Attorney_Email
				,Defendant_Id
				,DomainId
				,created_by_user
				,created_date
				,modified_by_user
				,modified_date
				)
			SELECT ''
				,t.Attorney_LastName
				,t.Attorney_FirstName
				,t.Attorney_Address
				,t.Attorney_City
				,t.Attorney_State
				,t.Attorney_Zip
				,t.Attorney_Phone
				,t.Attorney_Fax
				,t.Attorney_Email
				,d.Defendant_Id
				,@DomainID
				,'admin'
				,GETDATE()
				,t.modified_by_user
				,t.modified_date
			FROM tblAttorney_rfa_import_temp t
			JOIN tblDefendant_rfa_import_temp t1 ON t1.Defendant_Id = t.Defendant_Id
			LEFT JOIN dbo.tblAttorney a(NOLOCK) ON a.Attorney_LastName = t.Attorney_LastName
				AND a.Attorney_FirstName = t.Attorney_FirstName
				AND a.DomainId = @DomainID
			JOIN dbo.tblDefendant d(NOLOCK) ON d.Defendant_Name = t1.Defendant_Name
			WHERE a.Attorney_LastName IS NULL
				AND a.Attorney_FirstName IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '23'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.tblAttorney
			WHERE DomainId = @DomainID

			SET @Description = 'tblAttorney : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)

			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = '#AttorneyAutoId'
					)
			BEGIN
				DROP TABLE #AttorneyAutoId
			END

			SELECT Attorney_AutoId
			INTO #AttorneyAutoId
			FROM dbo.tblAttorney
			WHERE Attorney_Id = ''
				AND created_date = CONVERT(DATE, GETDATE())

			PRINT '24'

			UPDATE dbo.tblAttorney
			SET Attorney_Id = 'A' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR), 2) + '-' + CAST(i.Attorney_AutoId AS NVARCHAR)
			FROM #AttorneyAutoId i
			JOIN dbo.tblAttorney a ON a.Attorney_AutoId = i.Attorney_AutoId

			SET @AfterInsertCount = @@ROWCOUNT
			SET @Description = 'tblAttorney : Number Of Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Number Of Rows Updated - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			PRINT '25'

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblAttorney
			WHERE DomainId = @DomainID

			SET @Description = 'tblAttorney : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblNotary_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblNotary_rfa_import_temp
			END

			SELECT DISTINCT n.*
			INTO tblNotary_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].dbo.[NotaryPublic] n ON c.Notary_id = n.NotaryPublicID
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.NotaryPublic
			WHERE DomainId = @DomainID

			PRINT '26'

			INSERT INTO [dbo].[NotaryPublic] (
				NPFirstName
				,NPMiddle
				,NPLastName
				,NPCounty
				,NPRegistrationNo
				,NPExpDate
				,NPPriority
				,DomainId
				)
			SELECT t.NPFirstName
				,t.NPMiddle
				,t.NPLastName
				,t.NPCounty
				,t.NPRegistrationNo
				,t.NPExpDate
				,t.NPPriority
				,@DomainID
			FROM tblNotary_rfa_import_temp t
			LEFT JOIN [dbo].[NotaryPublic] n ON n.NPFirstName = t.NPFirstName
				AND n.NPMiddle = t.NPMiddle
				AND n.NPLastName = t.NPLastName
				AND n.DomainId = @DomainID
			WHERE n.NPFirstName IS NULL
				AND n.NPMiddle IS NULL
				AND n.NPLastName IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '27'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.NotaryPublic
			WHERE DomainId = @DomainID

			SET @Description = 'NotaryPublic : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM NotaryPublic
			WHERE DomainId = @DomainID

			SET @Description = 'NotaryPublic : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'TblArbitrator_rfa_import_temp'
					)
			BEGIN
				DROP TABLE TblArbitrator_rfa_import_temp
			END

			SELECT DISTINCT a.*
			INTO TblArbitrator_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].[dbo].[TblArbitrator] a ON c.Arbitrator_ID = a.ARBITRATOR_ID
			JOIN #Provider m ON c.Provider_Id = m.ProviderId
			WHERE ISNULL(a.ARBITRATOR_NAME, '') <> ''

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.TblArbitrator
			WHERE DomainId = @DomainID

			PRINT '28'

			INSERT INTO [dbo].[TblArbitrator] (
				ARBITRATOR_NAME
				,ABITRATOR_LOCATION
				,ARBITRATOR_PHONE
				,ARBITRATOR_FAX
				,IS_AAA
				,ARBITRATOR_Email
				,DomainId
				,created_by_user
				,created_date
				,modified_by_user
				,modified_date
				)
			SELECT t.ARBITRATOR_NAME
				,t.ABITRATOR_LOCATION
				,t.ARBITRATOR_PHONE
				,t.ARBITRATOR_FAX
				,t.IS_AAA
				,t.ARBITRATOR_Email
				,@DomainID
				,'admin'
				,GETDATE()
				,t.modified_by_user
				,t.modified_date
			FROM TblArbitrator_rfa_import_temp t
			LEFT JOIN [dbo].[TblArbitrator] a(NOLOCK) ON a.ARBITRATOR_NAME = t.ARBITRATOR_NAME
				AND a.DomainId = @DomainID
			WHERE a.ARBITRATOR_NAME IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '29'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.TblArbitrator
			WHERE DomainId = @DomainID

			SET @Description = 'TblArbitrator : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM TblArbitrator
			WHERE DomainId = @DomainID

			SET @Description = 'TblArbitrator : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'MST_Service_Rendered_Location_rfa_import_temp'
					)
			BEGIN
				DROP TABLE MST_Service_Rendered_Location_rfa_import_temp
			END

			SELECT DISTINCT a.*
			INTO MST_Service_Rendered_Location_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblcase c
			JOIN [RFA_Atlas].[dbo].[MST_Service_Rendered_Location] a ON c.location_id = a.Location_Id
			JOIN #Provider m ON c.Provider_Id = m.ProviderId

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.MST_Service_Rendered_Location
			WHERE DomainId = @DomainID

			PRINT '30'

			INSERT INTO [MST_Service_Rendered_Location] (
				[Provider_Id]
				,[Location_Address]
				,[Location_City]
				,[Location_State]
				,[Location_Zip]
				,[DomainId]
				)
			SELECT t1.ATLAS_PROVIDER_ID
				,MST_Service_Rendered_Location_rfa_import_temp.Location_Address
				,MST_Service_Rendered_Location_rfa_import_temp.Location_City
				,MST_Service_Rendered_Location_rfa_import_temp.Location_State
				,MST_Service_Rendered_Location_rfa_import_temp.Location_Zip
				,@DomainID
			FROM MST_Service_Rendered_Location_rfa_import_temp
			LEFT JOIN RFA_JL_PROVIDERID_MAPPING t1 ON MST_Service_Rendered_Location_rfa_import_temp.Provider_Id = t1.RFA_PROVIDER_ID
			--LEFT JOIN tblProvider p ON t1.Provider_Name = p.Provider_Name
			--	AND p.DomainId = @DomainID
			LEFT JOIN [dbo].[MST_Service_Rendered_Location] a(NOLOCK) ON a.Location_Address = MST_Service_Rendered_Location_rfa_import_temp.Location_Address
			WHERE a.Location_Address IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '31'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.MST_Service_Rendered_Location
			WHERE DomainId = @DomainID

			SET @Description = 'MST_Service_Rendered_Location : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM MST_Service_Rendered_Location
			WHERE DomainId = @DomainID

			SET @Description = 'MST_Service_Rendered_Location : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF EXISTS (
				SELECT *
				FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'tblTreatment_rfa_import_temp'
				)
		BEGIN
			DROP TABLE tblTreatment_rfa_import_temp
		END

		SELECT DISTINCT d.*
		INTO tblTreatment_rfa_import_temp
		FROM [RFA_Atlas].dbo.tblcase c
		JOIN [RFA_Atlas].dbo.tblTreatment d ON c.Case_Id = d.Case_Id
		JOIN #Provider m ON c.Provider_Id = m.ProviderId

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblOperatingDoctor_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblOperatingDoctor_rfa_import_temp
			END

			SELECT DISTINCT d.*
			INTO tblOperatingDoctor_rfa_import_temp
			FROM tblTreatment_rfa_import_temp c
			JOIN [RFA_Atlas].[dbo].[tblOperatingDoctor] d ON c.TreatingDoctor_ID = d.Doctor_Id

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.tblOperatingDoctor
			WHERE DomainId = @DomainID

			PRINT '34'

			INSERT INTO [dbo].[tblOperatingDoctor] (
				Doctor_Name
				,Active
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT t.Doctor_Name
				,t.Active
				,@DomainID
				,'admin'
				,GETDATE()
			FROM tblOperatingDoctor_rfa_import_temp t
			LEFT JOIN [dbo].[tblOperatingDoctor] s ON s.Doctor_Name = t.Doctor_Name
				AND s.DomainId = @DomainID
			WHERE s.Doctor_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '35'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.tblOperatingDoctor
			WHERE DomainId = @DomainID

			SET @Description = 'tblOperatingDoctor : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblOperatingDoctor
			WHERE DomainId = @DomainID

			SET @Description = 'tblOperatingDoctor : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'TblReviewingDoctor_rfa_import_temp'
					)
			BEGIN
				DROP TABLE TblReviewingDoctor_rfa_import_temp
			END

			SELECT DISTINCT d.*
			INTO TblReviewingDoctor_rfa_import_temp
			FROM tblTreatment_rfa_import_temp c
			JOIN [RFA_Atlas].[dbo].[TblReviewingDoctor] d ON c.PeerReviewDoctor_ID = d.Doctor_id
			WHERE ISNULL(d.Doctor_Name, '') <> ''

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.TblReviewingDoctor
			WHERE DomainId = @DomainID

			PRINT '36'

			INSERT INTO [dbo].[TblReviewingDoctor] (
				Doctor_Name
				,Active
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT t.Doctor_Name
				,t.Active
				,@DomainID
				,'admin'
				,GETDATE()
			FROM TblReviewingDoctor_rfa_import_temp t
			LEFT JOIN [dbo].[TblReviewingDoctor] s ON s.Doctor_Name = t.Doctor_Name
				AND s.DomainId = @DomainID
			WHERE s.Doctor_Name IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '37'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.TblReviewingDoctor
			WHERE DomainId = @DomainID

			SET @Description = 'TblReviewingDoctor : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM TblReviewingDoctor
			WHERE DomainId = @DomainID

			SET @Description = 'TblReviewingDoctor : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblDenialReasons_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblDenialReasons_rfa_import_temp
			END

			SELECT DISTINCT d.*
			INTO tblDenialReasons_rfa_import_temp
			FROM tblTreatment_rfa_import_temp c
			JOIN [RFA_Atlas].[dbo].[tblDenialReasons] d ON c.DenialReason_ID = d.DenialReasons_Id

			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'mst_denial_category_rfa_import_temp'
					)
			BEGIN
				DROP TABLE mst_denial_category_rfa_import_temp
			END

			SELECT DISTINCT d.*
			INTO mst_denial_category_rfa_import_temp
			FROM tblDenialReasons_rfa_import_temp c
			JOIN [RFA_Atlas].[dbo].[MST_DENIAL_CATEGORY] d ON c.I_CATEGORY_ID = d.I_CATEGORY_ID

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.MST_DENIAL_CATEGORY
			WHERE DomainId = @DomainID

			PRINT '38'

			INSERT INTO [dbo].[MST_DENIAL_CATEGORY] (
				SZ_CATEGORY_NAME
				,SZ_CATEGORY_COLOR
				,DomainId
				)
			SELECT t.SZ_CATEGORY_NAME
				,t.SZ_CATEGORY_COLOR
				,@DomainID
			FROM mst_denial_category_rfa_import_temp t
			LEFT JOIN [dbo].[MST_DENIAL_CATEGORY] s ON s.SZ_CATEGORY_NAME = t.SZ_CATEGORY_NAME
				AND s.DomainId = @DomainID
			WHERE s.SZ_CATEGORY_NAME IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '39'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.MST_DENIAL_CATEGORY
			WHERE DomainId = @DomainID

			SET @Description = 'MST_DENIAL_CATEGORY : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.tblDenialReasons
			WHERE DomainId = @DomainID

			PRINT '40'

			INSERT INTO [dbo].[tblDenialReasons] (
				DenialReasons_Type
				,Denial_Colorcode
				,I_CATEGORY_ID
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT t.DenialReasons_Type
				,t.Denial_Colorcode
				,dc.I_CATEGORY_ID
				,@DomainID
				,'admin'
				,GETDATE()
			FROM tblDenialReasons_rfa_import_temp t
			LEFT JOIN [dbo].[tblDenialReasons] s ON s.DenialReasons_Type = t.DenialReasons_Type
				AND s.DomainId = @DomainID
			LEFT JOIN mst_denial_category_rfa_import_temp c ON c.I_CATEGORY_ID = t.I_CATEGORY_ID
			LEFT JOIN [dbo].[MST_DENIAL_CATEGORY] dc ON c.SZ_CATEGORY_NAME = dc.SZ_CATEGORY_NAME
				AND dc.DomainId = @DomainID
			WHERE s.DenialReasons_Type IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '41'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.tblDenialReasons
			WHERE DomainId = @DomainID

			SET @Description = 'tblDenialReasons : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.MST_DENIAL_CATEGORY
			WHERE DomainId = @DomainID

			SET @Description = 'MST_DENIAL_CATEGORY : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)

			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.tblDenialReasons
			WHERE DomainId = @DomainID

			SET @Description = 'tblDenialReasons : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.tblServiceType
			WHERE DomainId = @DomainID

			PRINT '42'

			INSERT INTO tblServiceType (
				ServiceType
				,ServiceDesc
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT t1.ServiceType
				,t1.ServiceDesc
				,@domainID
				,'Admin'
				,GETDATE()
			FROM [RFA_Atlas].[dbo].[tblServiceType] t1
			JOIN tblServiceType t2 ON t1.ServiceType = t2.ServiceType
				AND t2.DomainId = @domainID
			WHERE t2.ServiceType IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '43'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.tblServiceType
			WHERE DomainId = @DomainID

			SET @Description = 'tblServiceType : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblServiceType
			WHERE DomainId = @DomainID

			SET @Description = 'tblServiceType : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF EXISTS (
				SELECT *
				FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'tblcase_rfa_import_temp'
				)
		BEGIN
			DROP TABLE tblcase_rfa_import_temp
		END

		SELECT case_id
		INTO #tempAlready
		FROM (
			SELECT DISTINCT t3.case_id
			FROM tblcase t1(NOLOCK)
			JOIN RFA_JL_PROVIDERID_MAPPING t2 ON t1.Provider_Id = t2.ATLAS_PROVIDER_ID
			JOIN [RFA_Atlas].dbo.tblCase t3(NOLOCK) ON t3.InjuredParty_FirstName = t1.InjuredParty_FirstName
				AND t3.InjuredParty_LastName = t1.InjuredParty_LastName
				AND t3.Provider_Id = t2.RFA_PROVIDER_ID
				AND t1.DomainId = 'jl'
				AND convert(DATE, t3.Accident_Date) = convert(DATE, t1.Accident_Date)
			JOIN tblprovider t4 ON t4.Provider_Id = t1.Provider_Id
			JOIN [RFA_Atlas].dbo.Provider t5 ON t5.Provider_Id = t3.Provider_Id
			JOIN tblTreatment t6 ON t6.Case_Id = t1.Case_Id
			JOIN [RFA_Atlas].dbo.tblTreatment t7 ON t7.Case_Id = t3.Case_Id
				AND convert(DATE, t6.DateOfService_Start) = convert(DATE, t7.DateOfService_Start)
				AND convert(DATE, t6.DateOfService_End) = convert(DATE, t7.DateOfService_End)
				AND convert(MONEY, t6.Claim_Amount) = convert(MONEY, t7.Claim_Amount)
			
			UNION
			
			SELECT DISTINCT t3.case_id
			FROM tblcase t1(NOLOCK)
			JOIN RFA_JL_PROVIDERID_MAPPING t2 ON t1.Provider_Id = t2.ATLAS_PROVIDER_ID
			JOIN [RFA_Atlas].dbo.tblCase t3(NOLOCK) ON t3.InjuredParty_FirstName = t1.InjuredParty_LastName
				AND t3.InjuredParty_LastName = t1.InjuredParty_FirstName
				AND t3.Provider_Id = t2.RFA_PROVIDER_ID
				AND t1.DomainId = 'jl'
				AND convert(DATE, t3.Accident_Date) = convert(DATE, t1.Accident_Date)
			JOIN tblprovider t4 ON t4.Provider_Id = t1.Provider_Id
			JOIN [RFA_Atlas].dbo.Provider t5 ON t5.Provider_Id = t3.Provider_Id
			JOIN tblTreatment t6 ON t6.Case_Id = t1.Case_Id
			JOIN [RFA_Atlas].dbo.tblTreatment t7 ON t7.Case_Id = t3.Case_Id
				AND convert(DATE, t6.DateOfService_Start) = convert(DATE, t7.DateOfService_Start)
				AND convert(DATE, t6.DateOfService_End) = convert(DATE, t7.DateOfService_End)
				AND convert(MONEY, t6.Claim_Amount) = convert(MONEY, t7.Claim_Amount)
			
			UNION
			
			SELECT CaseId [case_id]
			FROM XN_TEMP_GBB_ALL_RFA_JL
			WHERE DomainId = @DomainID
			) A

		SELECT c.*
		INTO tblcase_rfa_import_temp
		FROM [RFA_Atlas].dbo.tblcase c
		JOIN #Provider m ON c.Provider_Id = m.ProviderId
		WHERE c.Case_Id NOT IN (
				SELECT case_id
				FROM #tempAlready
				)

		IF EXISTS (
				SELECT *
				FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'tblTreatment_rfa_import_temp'
				)
		BEGIN
			DROP TABLE tblTreatment_rfa_import_temp
		END

		SELECT t.*
		INTO tblTreatment_rfa_import_temp
		FROM [RFA_Atlas].dbo.tblTreatment t
		JOIN [RFA_Atlas].dbo.tblcase c ON t.Case_Id = c.Case_id
		JOIN #Provider m ON c.Provider_Id = m.ProviderId

		IF EXISTS (
				SELECT *
				FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'TXN_tblTreatment_rfa_import_temp'
				)
		BEGIN
			DROP TABLE TXN_tblTreatment_rfa_import_temp
		END

		SELECT tx.*
		INTO TXN_tblTreatment_rfa_import_temp
		FROM [RFA_Atlas].dbo.TXN_tblTreatment tx
		JOIN [RFA_Atlas].dbo.tblTreatment t(NOLOCK) ON t.Treatment_Id = tx.Treatment_Id
		JOIN [RFA_Atlas].dbo.tblcase c(NOLOCK) ON t.Case_Id = c.Case_id
		JOIN #Provider m ON c.Provider_Id = m.ProviderId

		IF (@Flag = 1)
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM dbo.XN_TEMP_GBB_ALL_RFA_JL
			WHERE DomainId = @DomainID

			PRINT '44'

			INSERT INTO [dbo].[XN_TEMP_GBB_ALL_RFA_JL] (
				CaseId
				,CaseNo
				,PatientFirstName
				,PatientLastName
				,InsuranceName
				,InsuranceAddress
				,InsuranceCity
				,InsuranceState
				,InsuranceZip
				,InsurancePhone
				,InsuranceEmail
				,PatientAddress
				,PatientStreet
				,PatientCity
				,PatientState
				,PatientZip
				,PatientPhone
				,PolicyNumber
				,ClaimNumber
				,BillStatusName
				,AttorneyName
				,AttorneyLastName
				,AttorneyAddress
				,AttorneyCity
				,AttorneyState
				,AttorneyZip
				,AttorneyFax
				,SocialSecurityNo
				,PolicyHolder
				,BillNumber
				,FltBillAmount
				,FltPaid
				,FltBalance
				,FirstVisitDate
				,LastVisitDate
				,CaseTypeName
				,Location
				,CompanyId
				,CompanyName
				,ProviderName
				,ProviderAddress
				,ProviderCity
				,ProviderZip
				,ProviderState
				,ProviderTaxId
				,DoctorTaxId
				,DoctorName
				,Specialty
				,DateofAccident
				,AssignedLawFirmId
				,TransferAmount
				,DateOfTransferred
				,BillDate
				,provider_id
				,insurancecompanyid
				,DenialReason1
				,DenialReason2
				,DenialReason3
				,DomainId
				,AtlasProviderId
				,IsDuplicateCase
				,TreatmentDetails
				,DiagnosisCodes
				,POMStampDate
				,POMGeneratedDate
				,POMId
				,AtlasInsuranceId
				,Transferd_Date
				,Transferd_Status
				,AtlasCaseID
				,AtlasCaseIndexNumber
				,AtlasPrincipalAmountCollected
				,AtlasInterestAmountCollected
				,AtlasCaseStatus
				,AtlasLastTransactionDate
				,IsDataSyncedtoGYB
				,DateSyncedtoGYB
				,STATUS
				,RFA_Treatment_ID
				,Initial_Status
				,GBB_TYPE
				,Balance_On_Policy
				,Balance_On_Policy_Bit
				,CaseFinalStatus
				)
			SELECT DISTINCT t1.Case_Id [CaseId]
				,t1.GB_CASE_NO [CaseNo]
				,t1.InjuredParty_FirstName [PatientFirstName]
				,t1.InjuredParty_LastName [PatientLastName]
				,t2.InsuranceCompany_Name [InsuranceName]
				,t2.InsuranceCompany_Local_Address [InsuranceAddress]
				,t2.InsuranceCompany_Local_City [InsuranceCity]
				,t2.InsuranceCompany_Local_State [InsuranceState]
				,t2.InsuranceCompany_Local_Zip [InsuranceZip]
				,t2.InsuranceCompany_Local_Phone [InsurancePhone]
				,t2.InsuranceCompany_Email [InsuranceEmail]
				,InjuredParty_Address [PatientAddress]
				,' ' [PatientStreet]
				,InjuredParty_City [PatientCity]
				,InjuredParty_State [PatientState]
				,InjuredParty_Zip [PatientZip]
				,InjuredParty_Phone [PatientPhone]
				,Policy_Number [PolicyNumber]
				,Ins_Claim_Number [ClaimNumber]
				,'Transferred' [BillStatusName]
				,t3.Attorney_FirstName [AttorneyName]
				,t3.Attorney_LastName [AttorneyLastName]
				,t3.Attorney_Address [AttorneyAddress]
				,t3.Attorney_City [AttorneyCity]
				,t3.Attorney_State [AttorneyState]
				,t3.Attorney_Zip [AttorneyZip]
				,t3.Attorney_Fax [AttorneyFax]
				,' ' [SocialSecurityNo]
				,InsuredParty_FirstName + ' ' + InsuredParty_LastName [PolicyHolder]
				,t4.BILL_NUMBER [BillNumber]
				,t4.Claim_Amount [FltBillAmount]
				,t4.Paid_Amount [FltPaid]
				,(t4.Claim_Amount - t4.Paid_Amount) [FltBalance]
				,t4.DateOfService_Start [FirstVisitDate]
				,t4.DateOfService_End [LastVisitDate]
				,' ' [CaseTypeName]
				,t6.Location_Address [Location]
				,t1.GB_COMPANY_ID [CompanyId]
				,'' [CompanyName]
				,t9.Provider_Name [ProviderName]
				,t9.Provider_Local_Address [ProviderAddress]
				,t9.Provider_Local_City [ProviderCity]
				,t9.Provider_Local_Zip [ProviderZip]
				,t9.Provider_Local_State [ProviderState]
				,t9.Provider_TaxID [ProviderTaxId]
				,' ' [DoctorTaxId]
				,t7.Doctor_Name [DoctorName]
				,t4.SERVICE_TYPE [Specialty]
				,t1.Accident_Date [DateofAccident]
				,t1.GB_LawFirm_ID [AssignedLawFirmId]
				,' ' [TransferAmount]
				,NULL [DateOfTransferred]
				,t4.Date_BillSent [BillDate]
				,t5.RFA_PROVIDER_ID [provider_id]
				,t2.InsuranceCompany_Id [insurancecompanyid]
				,' ' [DenialReason1]
				,' ' [DenialReason2]
				,' ' [DenialReason3]
				,@domainID [DomainId]
				,t5.ATLAS_PROVIDER_ID [AtlasProviderId]
				,NULL [IsDuplicateCase]
				,' ' [TreatmentDetails]
				,' ' [DiagnosisCodes]
				,NULL [POMStampDate]
				,NULL [POMGeneratedDate]
				,' ' [POMId]
				,t8.InsuranceCompany_Id [AtlasInsuranceId]
				,NULL [Transferd_Date]
				,'' [Transferd_Status]
				,' ' [AtlasCaseID]
				,' ' [AtlasCaseIndexNumber]
				,NULL [AtlasPrincipalAmountCollected]
				,NULL [AtlasInterestAmountCollected]
				,' ' [AtlasCaseStatus]
				,NULL [AtlasLastTransactionDate]
				,' ' [IsDataSyncedtoGYB]
				,NULL [DateSyncedtoGYB]
				,t1.STATUS [Status]
				,t4.Treatment_Id
				,t1.Initial_Status
				,t1.GBB_TYPE
				,t1.Balance_On_Policy
				,t1.Balance_On_Policy_Bit
				,t1.CaseFinalStatus
			FROM tblcase_rfa_import_temp t1
			JOIN tblTreatment_rfa_import_temp t4 ON t1.case_id = t4.case_id
			LEFT JOIN tblInsuranceCompany_rfa_import_temp t2 ON t1.InsuranceCompany_Id = t2.InsuranceCompany_Id
			LEFT JOIN tblInsuranceCompany t8 ON ltrim(rtrim(replace(replace(Replace(t8.InsuranceCompany_Name, ',', ''), '.', ''), '&', ''))) = ltrim(rtrim(replace(replace(Replace(t2.InsuranceCompany_Name, ',', ''), '.', ''), '&', '')))
				--AND ltrim(rtrim(replace(replace(Replace(t2.InsuranceCompany_Local_Address, ',', ''), '.', ''), '&', ''))) = ltrim(rtrim(replace(replace(Replace(t8.InsuranceCompany_Local_Address, ',', ''), '.', ''), '&', '')))
				AND t8.DomainId = @DomainID
			LEFT JOIN RFA_JL_PROVIDERID_MAPPING t5 ON t5.RFA_PROVIDER_ID = t1.provider_id
			LEFT JOIN tblProvider t9 ON t9.Provider_Id = t5.ATLAS_PROVIDER_ID
			--AND t5.Provider_Local_Address = t9.Provider_Local_Address  AND t9.DomainId = @DomainID
			LEFT JOIN tblAttorney_rfa_import_temp t3 ON t1.Attorney_Id = t3.Attorney_Id
			LEFT JOIN MST_Service_Rendered_Location_rfa_import_temp t6 ON t6.Location_Id = t1.Location_Id
			LEFT JOIN tblOperatingDoctor_rfa_import_temp t7 ON t4.TreatingDoctor_ID = t7.Doctor_Id
			ORDER BY t1.InjuredParty_FirstName
				,t1.InjuredParty_LastName

			SET @NewInsertCount = @@ROWCOUNT

			PRINT '45'

			SELECT @AfterInsertCount = COUNT(*)
			FROM dbo.XN_TEMP_GBB_ALL_RFA_JL
			WHERE DomainId = @DomainID

			SET @Description = 'XN_TEMP_GBB_ALL_RFA_JL : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM XN_TEMP_GBB_ALL_RFA_JL
			WHERE DomainId = @DomainID

			SET @Description = 'XN_TEMP_GBB_ALL_RFA_JL : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		--DROP TABLE #Provider
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION

		PRINT '46'

		DECLARE @ErrorMessage VARCHAR(max)

		SET @ErrorMessage = ERROR_MESSAGE()
		SET @Description = 'Exception : ' + @ErrorMessage

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@Description)

		RAISERROR (
				@ErrorMessage
				,16
				,1
				)
	END CATCH
END
