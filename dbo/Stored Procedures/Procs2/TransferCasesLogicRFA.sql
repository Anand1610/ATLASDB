
CREATE PROCEDURE [dbo].[TransferCasesLogicRFA] -- TransferCasesLogic 'GYB'   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	BEGIN TRY
		BEGIN TRANSACTION

		SET NOCOUNT ON;

		DECLARE @LogDescription VARCHAR(255)
		DECLARE @RowCount INT

		SET @LogDescription = 'TRANSFERRING CASES'

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		DECLARE @Case TABLE (
			[ID] [int] IDENTITY(1, 1) NOT NULL
			,[CaseId] [varchar](50) NOT NULL
			,[CaseNo] [varchar](500) NULL
			,[PatientFirstName] [varchar](800) NULL
			,[PatientLastName] [varchar](800) NULL
			,[InsuranceName] [varchar](800) NULL
			,[InsuranceAddress] [varchar](max) NULL
			,[InsuranceCity] [varchar](800) NULL
			,[InsuranceState] [varchar](800) NOT NULL
			,[InsuranceZip] [varchar](800) NULL
			,[InsurancePhone] [varchar](800) NULL
			,[InsuranceEmail] [varchar](800) NULL
			,[PatientAddress] [varchar](max) NULL
			,[PatientStreet] [varchar](800) NULL
			,[PatientCity] [varchar](800) NULL
			,[PatientState] [varchar](800) NULL
			,[PatientZip] [varchar](800) NULL
			,[PatientPhone] [varchar](800) NULL
			,[PolicyNumber] [varchar](800) NULL
			,[ClaimNumber] [varchar](800) NULL
			,[BillStatusName] [varchar](800) NULL
			,[AttorneyName] [varchar](max) NULL
			,[AttorneyLastName] [varchar](800) NULL
			,[AttorneyAddress] [varchar](max) NULL
			,[AttorneyCity] [varchar](800) NULL
			,[AttorneyState] [varchar](800) NULL
			,[AttorneyZip] [varchar](800) NULL
			,[AttorneyFax] [varchar](800) NULL
			,[SocialSecurityNo] [varchar](800) NULL
			,[PolicyHolder] [varchar](800) NULL
			,[BillNumber] [varchar](800) NULL
			,[FltBillAmount] [varchar](800) NULL
			,[FltPaid] [varchar](800) NULL
			,[FltBalance] [varchar](800) NULL
			,[FirstVisitDate] [datetime] NULL
			,[LastVisitDate] [datetime] NULL
			,[CaseTypeName] [varchar](800) NULL
			,[Location] [varchar](800) NULL
			,[CompanyId] [varchar](800) NULL
			,[CompanyName] [varchar](800) NULL
			,[ProviderName] [varchar](800) NULL
			,[ProviderAddress] [nvarchar](max) NULL
			,[ProviderCity] [varchar](800) NULL
			,[ProviderZip] [varchar](800) NULL
			,[ProviderState] [varchar](800) NULL
			,[ProviderTaxId] [varchar](800) NULL
			,[DoctorTaxId] [varchar](800) NULL
			,[DoctorName] [varchar](1000) NULL
			,[Specialty] [varchar](800) NULL
			,[DateofAccident] [datetime] NULL
			,[AssignedLawFirmId] [varchar](800) NULL
			,[TransferAmount] [varchar](800) NULL
			,[DateOfTransferred] [datetime] NULL
			,[BillDate] [datetime] NULL
			,[provider_id] [varchar](800) NULL
			,[insurancecompanyid] [varchar](800) NULL
			,[DenialReason1] [varchar](8000) NULL
			,[DenialReason2] [varchar](8000) NULL
			,[DenialReason3] [varchar](8000) NULL
			,[DomainId] [varchar](500) NULL
			,[AtlasProviderId] [int] NULL
			,[IsDuplicateCase] [int] NULL
			,[TreatmentDetails] [nvarchar](max) NULL
			,[DiagnosisCodes] [nvarchar](max) NULL
			,[POMStampDate] [datetime] NULL
			,[POMGeneratedDate] [datetime] NULL
			,[POMId] [varchar](40) NULL
			,[AtlasInsuranceId] [int] NULL
			,[GBB_Type] [varchar](10) NULL
			,[Transferd_Date] [date] NULL
			,[Transferd_Status] [varchar](100) NULL
			,[AtlasCaseID] [varchar](40) NULL
			,[AtlasCaseIndexNumber] [varchar](40) NULL
			,[AtlasPrincipalAmountCollected] [decimal](18, 4) NULL
			,[AtlasInterestAmountCollected] [decimal](18, 4) NULL
			,[AtlasCaseStatus] [varchar](80) NULL
			,[AtlasLastTransactionDate] [datetime] NULL
			,[IsDataSyncedtoGYB] [bit] NULL
			,[DateSyncedtoGYB] [datetime] NULL
			,[Status] [varchar](120) NULL
			,[RFA_Treatment_ID] INT NULL
			,[Initial_Status] [varchar](120) NULL
			,[Balance_On_Policy] DECIMAL(10, 2) NULL
			,[Balance_On_Policy_Bit] BIT NULL
			,[CaseFinalStatus] NVARCHAR(510) NULL
			,[XN_TEMP_ID] INT
			)

		PRINT '1'

		INSERT INTO @Case
		SELECT --top 200  
			t.CaseId
			,t.CaseNo
			,t.PatientFirstName
			,t.PatientLastName
			,t.InsuranceName
			,t.InsuranceAddress
			,t.InsuranceCity
			,t.InsuranceState
			,t.InsuranceZip
			,t.InsurancePhone
			,t.InsuranceEmail
			,t.PatientAddress
			,t.PatientStreet
			,t.PatientCity
			,t.PatientState
			,t.PatientZip
			,t.PatientPhone
			,t.PolicyNumber
			,t.ClaimNumber
			,t.BillStatusName
			,t.AttorneyName
			,t.AttorneyLastName
			,t.AttorneyAddress
			,t.AttorneyCity
			,t.AttorneyState
			,t.AttorneyZip
			,t.AttorneyFax
			,t.SocialSecurityNo
			,t.PolicyHolder
			,t.BillNumber
			,t.FltBillAmount
			,t.FltPaid
			,t.FltBalance
			,t.FirstVisitDate
			,t.LastVisitDate
			,t.CaseTypeName
			,t.[Location]
			,t.CompanyId
			,t.CompanyName
			,t.ProviderName
			,t.ProviderAddress
			,t.ProviderCity
			,t.ProviderZip
			,t.ProviderState
			,t.ProviderTaxId
			,t.DoctorTaxId
			,t.DoctorName
			,t.Specialty
			,t.DateofAccident
			,t.AssignedLawFirmId
			,t.TransferAmount
			,t.DateOfTransferred
			,t.BillDate
			,t.provider_id
			,t.insurancecompanyid
			,t.DenialReason1
			,t.DenialReason2
			,t.DenialReason3
			,t.DomainId
			,t.AtlasProviderId
			,t.IsDuplicateCase
			,t.TreatmentDetails
			,t.DiagnosisCodes
			,t.POMStampDate
			,t.POMGeneratedDate
			,t.POMId
			,t.AtlasInsuranceId
			,t.GBB_Type
			,t.Transferd_Date
			,t.Transferd_Status
			,t.AtlasCaseID
			,t.AtlasCaseIndexNumber
			,t.AtlasPrincipalAmountCollected
			,t.AtlasInterestAmountCollected
			,t.AtlasCaseStatus
			,t.AtlasLastTransactionDate
			,t.IsDataSyncedtoGYB
			,t.DateSyncedtoGYB
			,t3.AtlasStatus [STATUS]
			,t.RFA_Treatment_ID
			,t.Initial_Status
			,t.[Balance_On_Policy]
			,t.[Balance_On_Policy_Bit]
			,t.[CaseFinalStatus]
			,t.ID
		FROM [XN_TEMP_GBB_ALL_RFA_JL] t(NOLOCK)
		LEFT JOIN tblcase_rfa_import_temp t2 ON t.caseid = t2.Case_Id
		LEFT JOIN StatusMapping t3 ON t3.RFAStatus = t2.STATUS
		WHERE ISNULL(Transferd_Status, '') = ''

		SET @RowCount = @@ROWCOUNT
		SET @LogDescription = 'Total No Of Cases to Tansfer ' + CAST(@RowCount AS VARCHAR(5))

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		PRINT '2'

		DECLARE @DOMAINID VARCHAR(100)
		DECLARE @SZ_CASE_ID VARCHAR(100)
		DECLARE @SZ_CASE_NO VARCHAR(100)
		DECLARE @InjuredParty_LastName VARCHAR(100)
		DECLARE @InjuredParty_FirstName VARCHAR(100)
		DECLARE @SZ_PATIENT_ADDRESS VARCHAR(1000)
		DECLARE @SZ_PATIENT_CITY VARCHAR(100)
		DECLARE @SZ_PATIENT_STATE VARCHAR(100)
		DECLARE @SZ_PATIENT_ZIP VARCHAR(100)
		DECLARE @SZ_PATIENT_PHONE VARCHAR(50)
		DECLARE @SZ_POLICY_NUMBER VARCHAR(100)
		DECLARE @SZ_CLAIM_NUMBER VARCHAR(100)
		DECLARE @SZ_POLICY_HOLDER VARCHAR(500)
		DECLARE @SZ_BILL_NUMBER VARCHAR(100)
		DECLARE @FLT_BILL_AMOUNT VARCHAR(100)
		DECLARE @FLT_PAID VARCHAR(100)
		DECLARE @DT_START_VISIT_DATE VARCHAR(100)
		DECLARE @DT_END_VISIT_DATE VARCHAR(100)
		DECLARE @CASE_TYPE_NAME VARCHAR(100)
		DECLARE @SZ_COMPANY_ID VARCHAR(100)
		DECLARE @DT_DATE_OF_ACCIDENT DATETIME
		DECLARE @AssignedLawFirmId VARCHAR(200)
		DECLARE @BILL_DATE VARCHAR(100)
		DECLARE @DenialReason1 NVARCHAR(200)
		DECLARE @DenialReason2 NVARCHAR(200)
		DECLARE @DenialReason3 NVARCHAR(200)
		DECLARE @ProviderID INT
		DECLARE @InsuranceCompanyID INT
		DECLARE @GBBType VARCHAR(10)
		DECLARE @IsDuplicateCase INT
		DECLARE @TotalCount INT = 0
		DECLARE @Counter INT = 1
		DECLARE @MaxCaseId INT
		DECLARE @InsuredParty_LastName VARCHAR(100)
		DECLARE @InsuredParty_FirstName VARCHAR(100)
		DECLARE @AtlasCaseID VARCHAR(50)
		DECLARE @NOTES VARCHAR(MAX)
		DECLARE @DoctorName VARCHAR(800)
		DECLARE @Specialty VARCHAR(800)
		DECLARE @POMStampDate DATETIME
		DECLARE @POMGeneratedDate DATETIME
		DECLARE @POMId VARCHAR(40)
		DECLARE @Status [varchar] (120)
		DECLARE @RFA_Treatment_ID INT
		DECLARE @Initial_Status [varchar] (120)
		DECLARE @Balance_On_Policy DECIMAL(10, 2)
		DECLARE @Balance_On_Policy_Bit BIT
		DECLARE @CaseFinalStatus NVARCHAR(512)
		DECLARE @XN_TEMP_ID INT

		SELECT @TotalCount = COUNT(*)
		FROM @Case

		SET @MaxCaseId = (
				SELECT MAX(Case_AutoId)
				FROM tblcase(NOLOCK)
				)

		PRINT '3'

		SELECT *
		FROM @Case

		WHILE (@Counter <= @TotalCount)
		BEGIN
			PRINT '4'

			SELECT @SZ_CASE_ID = CaseId
				,@SZ_CASE_NO = CaseNo
				,@SZ_COMPANY_ID = CompanyId
				,@SZ_BILL_NUMBER = BillNumber
				,@DT_START_VISIT_DATE = FirstVisitDate
				,@DT_END_VISIT_DATE = LastVisitDate
				,@FLT_BILL_AMOUNT = FltBillAmount
				,@FLT_PAID = FltPaid
				,@BILL_DATE = BillDate
				,@DOMAINID = DomainId
				,@InjuredParty_FirstName = PatientFirstName
				,@InjuredParty_LastName = PatientLastName
				,@SZ_POLICY_HOLDER = PolicyHolder
				,@SZ_PATIENT_ADDRESS = PatientAddress
				,@SZ_PATIENT_CITY = PatientCity
				,@SZ_PATIENT_STATE = PatientState
				,@SZ_PATIENT_ZIP = PatientZip
				,@SZ_PATIENT_PHONE = PatientPhone
				,@DT_DATE_OF_ACCIDENT = CONVERT(NVARCHAR(15), DateofAccident, 101)
				,@SZ_POLICY_NUMBER = PolicyNumber
				,@SZ_CLAIM_NUMBER = ClaimNumber
				,@AssignedLawFirmId = AssignedLawFirmId
				,@CASE_TYPE_NAME = CaseTypeName
				,@DoctorName = DoctorName
				,@Specialty = Specialty
				,@POMStampDate = POMStampDate
				,@POMGeneratedDate = POMGeneratedDate
				,@POMId = POMId
				,@DenialReason1 = DenialReason1
				,@DenialReason2 = DenialReason2
				,@DenialReason3 = DenialReason3
				,@IsDuplicateCase = IsDuplicateCase
				,@ProviderID = AtlasProviderId
				,@InsuranceCompanyID = AtlasInsuranceId
				,@GBBType = GBB_TYPE
				,@Status = [Status]
				,@RFA_Treatment_ID = RFA_Treatment_ID
				,@Initial_Status = Initial_Status
				,@Balance_On_Policy = Balance_On_Policy
				,@Balance_On_Policy_Bit = Balance_On_Policy_Bit
				,@CaseFinalStatus = CaseFinalStatus
				,@XN_TEMP_ID = XN_TEMP_ID
			FROM @Case
			WHERE ID = @Counter

			SET @LogDescription = 'Counter - ' + CAST(@Counter AS VARCHAR(5)) + ' RFA CaseID - ' + CAST(@SZ_CASE_ID AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@LogDescription)

			PRINT '5'

			SET @InsuredParty_FirstName = RTRIM(LTRIM(SUBSTRING(@SZ_POLICY_HOLDER, CHARINDEX(',', @SZ_POLICY_HOLDER) + 1, LEN(@SZ_POLICY_HOLDER))))
			SET @InsuredParty_LastName = RTRIM(LTRIM(SUBSTRING(@SZ_POLICY_HOLDER, 0, CHARINDEX(',', @SZ_POLICY_HOLDER))))

			DECLARE @s_l_Initial_Status VARCHAR(50) = 'Transferred from RFA'
			DECLARE @s_l_Current_Status VARCHAR(200) = @Status

			--- Transferd Date  
			SET @LogDescription = 'Updating Transferred date in XN_TEMP_GBB_ALL_RFA_JL table for Bill Number - ' + CAST(@SZ_BILL_NUMBER AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@LogDescription)

			PRINT '6'

			UPDATE XN_TEMP_GBB_ALL_RFA_JL
			SET Transferd_Date = convert(DATE, getdate())
			WHERE ID = @XN_TEMP_ID
				AND Transferd_Date IS NULL

			SET @RowCount = @@ROWCOUNT

			PRINT '7'

			IF (@RowCount > 0)
			BEGIN
				SET @LogDescription = 'Transferred date Updated in XN_TEMP_GBB_ALL_RFA_JL table for Bill Number - ' + CAST(@SZ_BILL_NUMBER AS VARCHAR(5))

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)
			END
			ELSE
			BEGIN
				SET @LogDescription = 'No Records Updated in XN_TEMP_GBB_ALL_RFA_JL table for Bill Number - ' + CAST(@SZ_BILL_NUMBER AS VARCHAR(5))

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)
			END

			PRINT '8'

			IF EXISTS (
					SELECT Case_Id
					FROM tblCase(NOLOCK)
					WHERE old_Case_id = @SZ_CASE_ID
						AND DomainId = @DOMAINID
					)
			BEGIN
				PRINT '9'

				DECLARE @ExistingCaseID VARCHAR(20)

				SELECT @ExistingCaseID = Case_Id
				FROM tblCase(NOLOCK)
				WHERE old_Case_id = @SZ_CASE_ID
					AND DomainId = @DOMAINID

				IF NOT EXISTS (
						SELECT Treatment_Id_old
						FROM TBLTREATMENT t
						WHERE t.Treatment_Id_old = @RFA_Treatment_ID
							AND t.DomainId = @DOMAINID
						)
				BEGIN
					INSERT INTO TBLTREATMENT (
						Case_Id
						,DateOfService_Start
						,DateOfService_End
						,Claim_Amount
						,Paid_Amount
						,BILL_NUMBER
						,Fee_Schedule
						,date_billsent
						,DenialReason_ID
						,DomainId
						,Service_Type
						,DocumentStatus
						,Operating_Doctor
						,pom_created_date
						,pom_id
						,Treatment_Id_old
						)
					VALUES (
						@ExistingCaseID
						,@DT_START_VISIT_DATE
						,@DT_END_VISIT_DATE
						,CASE 
							WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0
								THEN 0
							ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT)
							END
						,CASE 
							WHEN ISNUMERIC(@FLT_PAID) = 0
								THEN 0
							ELSE CONVERT(NUMERIC(18, 2), @FLT_PAID)
							END
						,@SZ_BILL_NUMBER
						,CASE 
							WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0
								THEN 0
							ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT)
							END
						,@BILL_DATE
						,(
							SELECT TOP 1 DenialReasons_Id
							FROM tblDenialReasons(NOLOCK)
							WHERE DENIALREASONS_TYPE = @DenialReason1
								AND DomainId = @DOMAINID
							)
						,@DOMAINID
						,@Specialty
						,'Document Pending'
						,(
							SELECT TOP 1 Doctor_Id
							FROM tblOperatingDoctor(NOLOCK)
							WHERE Doctor_name = @DoctorName
								AND DomainId = @DOMAINID
							)
						,@POMGeneratedDate
						,@POMId
						,@RFA_Treatment_ID
						)

					SET @LogDescription = 'New Treatment Added for Existing CaseID - ' + @ExistingCaseID

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)

					DECLARE @NewTreatmentId INT = (
							SELECT Treatment_Id
							FROM TBLTREATMENT(NOLOCK)
							WHERE CASE_ID = @ExistingCaseID
								AND Treatment_Id_old = @RFA_Treatment_ID
							)

					INSERT TXN_tblTreatment (
						Treatment_Id
						,DenialReasons_Id
						,DomainId
						)
					SELECT @NewTreatmentId
						,dr.DenialReasons_Id
						,@DOMAINID
					FROM tblTreatment_rfa_import_temp t
					JOIN tblcase c(NOLOCK) ON t.Case_Id = c.Case_Id
					JOIN TXN_tblTreatment_rfa_import_temp tx ON tx.Treatment_Id = t.Treatment_Id
					JOIN tblDenialReasons_rfa_import_temp d ON d.DenialReasons_Id = tx.DenialReasons_Id
					JOIN tblDenialReasons dr(NOLOCK) ON dr.DomainId = @DOMAINID
						AND dr.DenialReasons_Type = d.DenialReasons_Type
					WHERE t.Treatment_Id = @RFA_Treatment_ID
						AND dr.DenialReasons_Id IS NOT NULL

					SET @NOTES = 'Bill added for DOS ' + convert(VARCHAR(9), @DT_START_VISIT_DATE) + ' - ' + convert(VARCHAR(9), @DT_END_VISIT_DATE)

					EXEC LCJ_AddNotes @case_id = @ExistingCaseID
						,@notes_type = 'Activity'
						,@Ndesc = @NOTES
						,@User_id = 'system'
						,@Applytogroup = 0
						,@DomainId = @DOMAINID

					SET @Counter = @Counter + 1

					UPDATE X
					SET X.Transferd_Status = 'Partially'
						,X.Treatment_Id = @NewTreatmentId
						,X.AtlasCaseID = @ExistingCaseID
					--AtlasCaseID =  T.Case_Id  
					FROM XN_TEMP_GBB_ALL_RFA_JL X
					WHERE X.ID = @XN_TEMP_ID
				END
				ELSE
				BEGIN
					DECLARE @ExistingTreatmentId INT
					SET @Counter = @Counter + 1
					SET @LogDescription = 'Treatment Already Exists for CaseID - ' + @ExistingCaseID

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)

					SELECT @ExistingTreatmentId = Treatment_Id
						FROM TBLTREATMENT t
						WHERE t.Treatment_Id_old = @RFA_Treatment_ID
							AND t.DomainId = @DOMAINID

					UPDATE X
					SET X.Transferd_Status = 'Already Exist'
						,X.Treatment_Id = @ExistingTreatmentId
						,X.AtlasCaseID = @ExistingCaseID
					--AtlasCaseID =  T.Case_Id  
					FROM XN_TEMP_GBB_ALL_RFA_JL X
					WHERE X.ID = @XN_TEMP_ID
				END
			END
			ELSE
			BEGIN
				DECLARE @MaxCase_ID VARCHAR(100)
				DECLARE @MaxCaseAuto_ID INT

				SET @LogDescription = 'Creating new Case ID '

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				PRINT '22'

				IF (@DOMAINID = 'GLF')
				BEGIN
					PRINT '23'

					SET @MaxCase_ID = ISNULL((
								SELECT TOP 1 tblCase.Case_ID
								FROM tblCase(NOLOCK)
								WHERE DomainId = @DomainID
									AND Case_ID LIKE 'ACT%'
								ORDER BY Case_AUTOID DESC
								), '100000')
					SET @MaxCaseAuto_ID = (
							SELECT TOP 1 items + 1
							FROM dbo.[STRING_SPLIT](@MaxCase_ID, '-')
							ORDER BY autoid DESC
							)
					SET @AtlasCaseID = 'ACT' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR), 2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)

					PRINT '24'
				END
				ELSE
				BEGIN
					PRINT '25'

					SET @MaxCase_ID = ISNULL((
								SELECT TOP 1 tblCase.Case_ID
								FROM tblCase(NOLOCK)
								WHERE DomainId = @DomainID
									AND Case_ID NOT LIKE 'ACT%'
								ORDER BY Case_AUTOID DESC
								), '100000')
					SET @MaxCaseAuto_ID = (
							SELECT TOP 1 items + 1
							FROM dbo.[STRING_SPLIT](@MaxCase_ID, '-')
							ORDER BY autoid DESC
							)
					SET @AtlasCaseID = UPPER(@DomainID) + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR), 2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)

					PRINT '26'
				END

				SET @LogDescription = 'Inserting New CaseID in tblCase - ' + @AtlasCaseID

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				PRINT '27'

				INSERT INTO tblCase (
					Case_Id
					,Provider_Id
					,InsuranceCompany_Id
					,InjuredParty_LastName
					,InjuredParty_FirstName
					,InsuredParty_LastName
					,InsuredParty_FirstName
					,InjuredParty_Address
					,InjuredParty_City
					,InjuredParty_State
					,InjuredParty_Zip
					,InjuredParty_Phone
					,Accident_Date
					,Policy_Number
					,Ins_Claim_Number
					,STATUS
					,Date_Opened
					,Initial_Status
					,original_status
					,GB_CASE_ID
					,GB_CASE_NO
					,GB_COMPANY_ID
					,Bit_FromGB
					,DomainId
					,GB_LawFirm_ID
					,IsDuplicateCase
					,gbb_type
					,opened_by
					,old_Case_id
					)
				VALUES (
					@AtlasCaseID
					,@ProviderID
					,@InsuranceCompanyId
					,@InjuredParty_LastName
					,@InjuredParty_FirstName
					,@InsuredParty_LastName
					,@InsuredParty_FirstName
					,@SZ_PATIENT_ADDRESS
					,@SZ_PATIENT_CITY
					,@SZ_PATIENT_STATE
					,@SZ_PATIENT_ZIP
					,@SZ_PATIENT_PHONE
					,Convert(NVARCHAR(15), @DT_DATE_OF_ACCIDENT, 101)
					,@SZ_POLICY_NUMBER
					,@SZ_CLAIM_NUMBER
					,@s_l_Current_Status
					,GETDATE()
					,@s_l_Initial_Status
					,--'LIT', --'ARB',  
					@s_l_Initial_Status
					,--This is original status  
					@SZ_CASE_ID
					,@SZ_CASE_NO
					,@SZ_COMPANY_ID
					,1
					,@DOMAINID
					,@AssignedLawFirmId
					,@IsDuplicateCase
					,@GBBType
					,'System'
					,@SZ_CASE_ID
					)

				SET @RowCount = @@ROWCOUNT

				PRINT '28'

				IF (@RowCount > 0)
				BEGIN
					SET @LogDescription = 'New Case added in tblCase - ' + @AtlasCaseID

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END
				ELSE
				BEGIN
					SET @LogDescription = 'No Case Added in tblcase'

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END

				EXEC LCJ_AddNotes @Case_Id = @AtlasCaseID
					,@Notes_Type = 'Activity'
					,@NDesc = 'Case Opened'
					,@User_Id = 'System'
					,@ApplyToGroup = 0
					,@DomainId = @DOMAINID

				PRINT '29'

				SET @LogDescription = 'Inserting into TBLTREATMENT'

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				PRINT '30'

				INSERT INTO TBLTREATMENT (
					Case_Id
					,DateOfService_Start
					,DateOfService_End
					,Claim_Amount
					,Paid_Amount
					,BILL_NUMBER
					,Fee_Schedule
					,date_billsent
					,DenialReason_ID
					,DomainId
					,Service_Type
					,DocumentStatus
					,Operating_Doctor
					,pom_created_date
					,pom_id
					,Treatment_Id_old
					)
				VALUES (
					@AtlasCaseID
					,@DT_START_VISIT_DATE
					,@DT_END_VISIT_DATE
					,CASE 
						WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0
							THEN 0
						ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT)
						END
					,CASE 
						WHEN ISNUMERIC(@FLT_PAID) = 0
							THEN 0
						ELSE CONVERT(NUMERIC(18, 2), @FLT_PAID)
						END
					,@SZ_BILL_NUMBER
					,CASE 
						WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0
							THEN 0
						ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT)
						END
					,@BILL_DATE
					,(
						SELECT TOP 1 DenialReasons_Id
						FROM tblDenialReasons(NOLOCK)
						WHERE DENIALREASONS_TYPE = @DenialReason1
							AND DomainId = @DOMAINID
						)
					,@DOMAINID
					,@Specialty
					,'Document Pending'
					,(
						SELECT TOP 1 Doctor_Id
						FROM tblOperatingDoctor(NOLOCK)
						WHERE Doctor_name = @DoctorName
							AND DomainId = @DOMAINID
						)
					,@POMGeneratedDate
					,@POMId
					,@RFA_Treatment_ID
					)

				SET @RowCount = @@ROWCOUNT

				PRINT '31'

				IF (@RowCount > 0)
				BEGIN
					SET @LogDescription = 'Inserted into TBLTREATMENT '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END
				ELSE
				BEGIN
					SET @LogDescription = 'No Records Inserted into TBLTREATMENT '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END

				DECLARE @TreatmentId INT = (
						SELECT Treatment_Id
						FROM TBLTREATMENT(NOLOCK)
						WHERE CASE_ID = @AtlasCaseID
							AND Treatment_Id_old = @RFA_Treatment_ID
						)

				SET @LogDescription = 'Inserting into TXN_tblTreatment for Treatment Id - ' + CAST(@TreatmentId AS VARCHAR(20))

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				PRINT '32'

				INSERT TXN_tblTreatment (
					Treatment_Id
					,DenialReasons_Id
					,DomainId
					)
				SELECT @TreatmentId
					,dr.DenialReasons_Id
					,@DOMAINID
				FROM tblTreatment_rfa_import_temp t
				JOIN tblcase c(NOLOCK) ON t.Case_Id = c.Case_Id
				JOIN TXN_tblTreatment_rfa_import_temp tx ON tx.Treatment_Id = t.Treatment_Id
				JOIN tblDenialReasons_rfa_import_temp d ON d.DenialReasons_Id = tx.DenialReasons_Id
				JOIN tblDenialReasons dr(NOLOCK) ON dr.DomainId = @DOMAINID
					AND dr.DenialReasons_Type = d.DenialReasons_Type
				WHERE t.Treatment_Id = @RFA_Treatment_ID
					AND dr.DenialReasons_Id IS NOT NULL

				SET @RowCount = @@ROWCOUNT

				PRINT '33'

				IF (@RowCount > 0)
				BEGIN
					SET @LogDescription = 'Inserted into TXN_tblTreatment '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END
				ELSE
				BEGIN
					SET @LogDescription = 'No Records Inserted into TXN_tblTreatment '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END

				SET @NOTES = 'Bill added for DOS ' + convert(VARCHAR(9), @DT_START_VISIT_DATE) + ' - ' + convert(VARCHAR(9), @DT_END_VISIT_DATE)

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@NOTES)

				EXEC LCJ_AddNotes @case_id = @AtlasCaseID
					,@notes_type = 'Activity'
					,@Ndesc = @NOTES
					,@User_id = 'system'
					,@Applytogroup = 0
					,@DomainId = @DOMAINID

				SET @LogDescription = 'Inserting into tblCase_Date_Details '

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				PRINT '34'

				INSERT INTO tblCase_Date_Details (
					DomainId
					,Case_Id
					)
				VALUES (
					@DomainID
					,@AtlasCaseID
					)

				SET @RowCount = @@ROWCOUNT

				PRINT '35'

				IF (@RowCount > 0)
				BEGIN
					SET @LogDescription = 'Inserted into tblCase_Date_Details '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END
				ELSE
				BEGIN
					SET @LogDescription = 'No Records Inserted into tblCase_Date_Details '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END

				SET @LogDescription = 'Inserting into tblCase_additional_info '

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				PRINT '36'

				INSERT INTO tblCase_additional_info (
					DomainId
					,Case_Id
					,Balance_On_Policy
					,Balance_On_Policy_Bit
					,CaseFinalStatus
					)
				VALUES (
					@DomainID
					,@AtlasCaseID
					,@Balance_On_Policy
					,@Balance_On_Policy_Bit
					,@CaseFinalStatus
					)

				SET @RowCount = @@ROWCOUNT

				PRINT '37'

				IF (@RowCount > 0)
				BEGIN
					SET @LogDescription = 'Inserted into tblCase_additional_info '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END
				ELSE
				BEGIN
					SET @LogDescription = 'No Records Inserted into tblCase_additional_info '

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)
				END

				PRINT '38'

				EXEC sp_createDefaultDocTypesForTree @DomainId
					,@AtlasCaseID
					,@AtlasCaseID

				PRINT '39'

				SET @Counter = @Counter + 1

			UPDATE X
				SET X.Transferd_Status = 'Partially'
					,X.Treatment_Id = @TreatmentId
					,X.AtlasCaseID = @AtlasCaseID
				--AtlasCaseID =  T.Case_Id  
				FROM XN_TEMP_GBB_ALL_RFA_JL X
				WHERE X.ID = @XN_TEMP_ID
			END
		END

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION

		PRINT '43'

		DECLARE @ErrorMessage VARCHAR(max)

		SET @ErrorMessage = ERROR_MESSAGE()
		SET @LogDescription = 'Exception : ' + @ErrorMessage

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		RAISERROR (
				@ErrorMessage
				,16
				,1
				)
	END CATCH
END
