
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TransferCasesLogicMcCollum] -- TransferCasesLogic 'GYB'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   	DECLARE @Case TABLE
		(
			ID INT IDENTITY(1,1),
			[AutoID] INT,
			[Provider] [nvarchar](255) NULL,
			[Patient ID] [nvarchar](255) NULL,
			[PatientLastName] [nvarchar](255) NULL,
			[PatientFirstName] [nvarchar](255) NULL,
			[PatientDOB] [datetime] NULL,
			[CaseTypeName] [nvarchar](255) NULL,
			[InsuranceName] [nvarchar](255) NULL,
			[DateofAccident] [datetime] NULL,
			[Claim Number] [nvarchar](255) NULL,
			[PolicyNumber] [nvarchar](255) NULL,
			[BillType] [nvarchar](255) NULL,
			[TreatingProvider] [nvarchar](255) NULL,
			[FirstVisitDate] [datetime] NULL,
			[LastVisitDate] [datetime] NULL,
			[BillDate] [datetime] NULL,
			[FltBillAmount] [money] NULL,
			[FltPaid] [money] NULL,
			[FltBalance] [money] NULL,
			[InitialStatus] [nvarchar](255) NULL,
			[Notes] [nvarchar](255) NULL,
			[DomainId] [varchar](500) NULL,
			[AtlasProviderId] [int] NULL,
			[AtlasInsuranceId] [int] NULL
	)

		INSERT INTO @Case
		SELECT 
			 ID
			, Provider
			, [Patient ID]	
			, PatientLastName	
			, PatientFirstName	
			, PatientDOB	
			, CaseTypeName	
			, InsuranceName	
			, DateofAccident	
			, [Claim Number]	
			, PolicyNumber	
			, BillType	
			, TreatingProvider	
			, FirstVisitDate	
			, LastVisitDate	
			, BillDate	
			, FltBillAmount	
			, FltPaid	
			, FltBalance	
			, InitialStatus	
			, Notes		
			, DomainId	
			, AtlasProviderId	
			, AtlasInsuranceId	

		FROM XN_TEMP_McCollum
		WHERE ISNULL(AtlasProviderId,'') <>''
			AND ISNULL(AtlasInsuranceId,'') <> ''
			AND ISNULL(Transferd_Status,'') =''
			--AND ID < 1707


         
		 DECLARE @s_l_ID INT
		DECLARE @i_l_AutoID INT
		DECLARE @s_l_Provider nvarchar(255) 
		DECLARE @s_l_Patient_ID nvarchar(255) 
		DECLARE @InjuredParty_LastName nvarchar(255) 
		DECLARE @InjuredParty_FirstName nvarchar(255) 
		DECLARE @s_l_PatientDOB datetime 
		DECLARE @s_l_CaseTypeName nvarchar(255) 
		DECLARE @s_l_InsuranceName nvarchar(255) 
		DECLARE @DT_DATE_OF_ACCIDENT datetime 
		DECLARE @SZ_CLAIM_NUMBER nvarchar(255) 
		DECLARE @s_l_PolicyNumber nvarchar(255) 
		DECLARE @DoctorName VARCHAR(800)
		DECLARE @Specialty VARChar(800)
		DECLARE @DT_END_VISIT_DATE datetime 
		DECLARE @DT_START_VISIT_DATE datetime 
		DECLARE @BILL_DATE datetime 
		DECLARE @FLT_CLAIM money 
		DECLARE @FLT_PAID money 
		DECLARE @FLT_BILL_AMOUNT money 
		DECLARE @s_l_InitialStatus nvarchar(255) 
		DECLARE @s_l_Notes nvarchar(255) 
		DECLARE @DOMAINID varchar(500) 
		DECLARE @ProviderID int 
		DECLARE @InsuranceCompanyId int

		DECLARE @TotalCount INT = 0
		DECLARE @Counter INT = 1
		DECLARE @MaxCaseId INT
		DECLARE	@InsuredParty_LastName	VARCHAR(100)
		DECLARE	@InsuredParty_FirstName	VARCHAR(100)
		DECLARE	@AtlasCaseID	VARCHAR(50)
		DECLARE	@NOTES	VARCHAR(MAX)
		

		SELECT @TotalCount = COUNT(*) FROM @Case
		SET @MaxCaseId = (SELECT MAX(Case_AutoId) from tblcase)
		WHILE(@Counter <= @TotalCount)
		BEGIN
			SELECT
			@i_l_AutoID = AutoID , @s_l_Patient_ID = [Patient ID] , @InjuredParty_LastName = PatientLastName , @InjuredParty_FirstName = PatientFirstName , @s_l_PatientDOB = PatientDOB ,
			@s_l_CaseTypeName = CaseTypeName , @DT_DATE_OF_ACCIDENT = DateofAccident ,
			@SZ_CLAIM_NUMBER = [Claim Number] , @s_l_PolicyNumber = PolicyNumber ,
			@Specialty = BillType ,@DoctorName = TreatingProvider , @DT_END_VISIT_DATE = FirstVisitDate , @DT_START_VISIT_DATE = LastVisitDate ,
			@BILL_DATE = BillDate , @FLT_CLAIM = FltBillAmount , @FLT_PAID = FltPaid , @FLT_BILL_AMOUNT = FltBalance , @s_l_InitialStatus = InitialStatus , @s_l_Notes = Notes , 
			@DOMAINID = DomainId , @ProviderID = AtlasProviderId , @InsuranceCompanyId = AtlasInsuranceId
			FROM	@Case WHERE ID = @Counter

			
				SET @AtlasCaseID = NULL	
				SET @AtlasCaseID = (SELECT TOP 1 CASE_ID FROM  tblCase  
								WHERE InjuredParty_LastName = @InjuredParty_LastName
								AND InjuredParty_FirstName = @InjuredParty_FirstName
								AND provider_id = @ProviderID
								AND DomainId = @DOMAINID
								AND Case_AutoId > @MaxCaseId)

			IF(ISNULL(@AtlasCaseID, '') <> '')
			BEGIN
						INSERT INTO TBLTREATMENT
						(
							Case_Id,
							DateOfService_Start,
							DateOfService_End,
							Claim_Amount,
							Paid_Amount,
							BILL_NUMBER,
							Fee_Schedule,
							Date_BillSent,
							DenialReason_ID,
							DomainId,
							Service_Type,
							DocumentStatus,
							TreatingDoctor_ID
						)
						VALUES
						(
							@AtlasCaseID,
							@DT_START_VISIT_DATE,
							@DT_END_VISIT_DATE,
							CASE WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT) END,
							CASE WHEN ISNUMERIC(@FLT_PAID) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), @FLT_PAID) END,
							NULL,
							CASE WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT) END,
							@BILL_DATE,
							NULL,
							@DOMAINID,
							@Specialty,
							NULL,
							(SELECT TOP 1 Doctor_Id from tblOperatingDoctor WHERE Doctor_name = @DoctorName  and DomainId = @DOMAINID)
						)
	

	  if exists(select top 1 * from tbltreatment where case_id=@AtlasCaseID and DenialReason_Id is not null)
					 BEGIN
					 EXEC Update_Denial_Case @Caseid =@AtlasCaseID
					 END
					
				SET @NOTES = 'Bill added for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
				exec LCJ_AddNotes @case_id=@AtlasCaseID,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0 ,@DomainId = @DOMAINID
											
			END		
			ELSE 
			BEGIN
	
					DECLARE @MaxCase_ID VARCHAR(100)   
					DECLARE @MaxCaseAuto_ID INT 

					IF(@s_l_InitialStatus = 'ACTIVE' AND @DOMAINID = 'GLF' )
					BEGIN
						SET @MaxCase_ID=ISNULL((SELECT top 1 tblCase.Case_ID FROM tblCase  WHERE DomainId=@DomainID and Case_ID like 'ACT%' ORDER BY Case_AUTOID DESC),'100000')
						SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
						SET @AtlasCaseID  = 'ACT' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)
					END
					ELSE IF(@s_l_InitialStatus = 'ACTIVE')
					BEGIN
						SET @MaxCase_ID=ISNULL((SELECT top 1 tblCase.Case_ID FROM tblCase  WHERE DomainId=@DomainID and Case_ID like 'ACT%' ORDER BY Case_AUTOID DESC),'100000')
						SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
						SET @AtlasCaseID  = 'ACT-'+ @DomainID + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)
					END
					ELSE
					BEGIN
						SET @MaxCase_ID=ISNULL((SELECT top 1 tblCase.Case_ID FROM tblCase  WHERE DomainId=@DomainID And Case_Id not like  'ACT%' ORDER BY Case_AUTOID DESC),'100000')
						SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
						SET @AtlasCaseID  = UPPER(@DomainID) + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)
					END
						
					INSERT INTO tblCase   
					(  
						Case_Id,  
						Provider_Id,  
						InsuranceCompany_Id,  
						InjuredParty_LastName,  
						InjuredParty_FirstName,  
						InsuredParty_LastName,  
						InsuredParty_FirstName, 
						Accident_Date,  
						Policy_Number,  
						Ins_Claim_Number,
						Status,  						
						Date_Opened,  
						Initial_Status,
						original_status,
						DomainId
					)       
					VALUES  
					(  
						@AtlasCaseID,
						@ProviderID,  
						@InsuranceCompanyId, 
						@InjuredParty_LastName, 
						@InjuredParty_FirstName,  
						@InsuredParty_LastName,  
						@InsuredParty_FirstName, 
						Convert(nvarchar(15), @DT_DATE_OF_ACCIDENT, 101),  
						@s_l_PolicyNumber,  
						@SZ_CLAIM_NUMBER, 
						'NEW CASE ENTERED' , --'AAA - NEW CASE ENTERED',--'AAA OPEN',  
						GETDATE(),
						@s_l_InitialStatus, --'LIT', --'ARB',
						@s_l_InitialStatus,--This is original status
						@DOMAINID
					)

					EXEC LCJ_AddNotes @Case_Id = @AtlasCaseID,@Notes_Type='Activity',@NDesc='Case Opened',@User_Id='System',@ApplyToGroup=0 ,@DomainId = @DOMAINID
					


					INSERT INTO TBLTREATMENT
					(
						Case_Id,
						DateOfService_Start,
						DateOfService_End,
						Claim_Amount,
						Paid_Amount,
						BILL_NUMBER,
						Fee_Schedule,
						date_billsent,
						DenialReason_ID,
						DomainId,
						Service_Type,
						DocumentStatus,
						Operating_Doctor
					)
					VALUES
					(
						@AtlasCaseID,
						@DT_START_VISIT_DATE,
						@DT_END_VISIT_DATE,
						CASE WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT) END,
						CASE WHEN ISNUMERIC(@FLT_PAID) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), @FLT_PAID) END,
						NULL,
						CASE WHEN ISNUMERIC(@FLT_BILL_AMOUNT) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), @FLT_BILL_AMOUNT) END,
						@BILL_DATE,
						NULL,
						@DOMAINID,
						@Specialty,
						'Document Pending',
						(SELECT TOP 1 Doctor_Id from tblOperatingDoctor WHERE Doctor_name = @DoctorName  and DomainId = @DOMAINID)
					)
			
						
				     if exists(select top 1 * from tbltreatment where case_id=@AtlasCaseID and DenialReason_Id is not null)
					 BEGIN
					 EXEC Update_Denial_Case @Caseid =@AtlasCaseID
					 END

					
					SET @NOTES = 'Bill added for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
					exec LCJ_AddNotes @case_id=@AtlasCaseID,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0 ,@DomainId = @DOMAINID				
			END	

			--- Transferd Date
			UPDATE XN_TEMP_McCollum
			SET Transferd_Date = convert(Date,getdate()),
				Transferd_Status = @AtlasCaseID
			WHERE  ID = @i_l_AutoID AND Transferd_Date IS NULL
		
			SET @DT_START_VISIT_DATE = NULL
			SET @DT_END_VISIT_DATE = NULL
			SET @FLT_BILL_AMOUNT = NULL
			SET @FLT_PAID = NULL
			SET @BILL_DATE = NULL
			SET @DOMAINID = NULL
			SET @InjuredParty_FirstName = NULL
			SET @InjuredParty_LastName = NULL
			SET @DT_DATE_OF_ACCIDENT = NULL
			SET @s_l_PolicyNumber = NULL
			SET @SZ_CLAIM_NUMBER = NULL
			SET @ProviderID = NULL
			SET @InsuranceCompanyID = NULL

			SET @Counter = @Counter + 1
		END	
END
