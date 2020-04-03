CREATE PROCEDURE [dbo].[GET_INSERT_CASE_DETAILS]
	@SZ_COMPANY_ID VARCHAR(100),	
	@SZ_CASE_ID	VARCHAR(100),
	@SZ_CASE_NO	VARCHAR(100),
	@SZ_PATIENT_NAME	VARCHAR(500),
	@SZ_PATIENT_ADDRESS	VARCHAR(1000),
	@SZ_PATIENT_CITY	VARCHAR(100),
	@SZ_PATIENT_STATE VARCHAR(100),
	@SZ_PATIENT_ZIP	VARCHAR(100),
	@SZ_PATIENT_PHONE	VARCHAR(50),
	@DT_DATE_OF_ACCIDENT VARCHAR(100),
	@DT_DOB	VARCHAR(100),
	@SZ_POLICY_HOLDER VARCHAR(500),
	@SZ_POLICY_NUMBER VARCHAR(100),
	@SZ_CLAIM_NUMBER VARCHAR(100),
	@SZ_INSURANCE_NAME VARCHAR(500),
	@SZ_INSURANCE_ADDRESS VARCHAR(1000),
	@SZ_INSURANCE_CITY VARCHAR(100),
	@SZ_STATE VARCHAR(100),
	@SZ_INSURANCE_ZIP VARCHAR(100),
	@SZ_INSURANCE_EMAIL VARCHAR(100),
	@SZ_STATUS_NAME VARCHAR(100),
	@SZ_ATTORNEY_NAME VARCHAR(500),
	@SZ_ATTORNEY_ADDRESS VARCHAR(1000),
	@SZ_ATTORNEY_CITY VARCHAR(100),
	@SZ_ATTORNEY_STATE VARCHAR(100),
	@SZ_ATTORNEY_ZIP VARCHAR(100),
	@SZ_ATTORNEY_FAX VARCHAR(100),
	@SZ_PROVIDER VARCHAR(1000),
	@SZ_BILL_NUMBER VARCHAR(100),
	@DT_START_VISIT_DATE VARCHAR(100),
	@DT_END_VISIT_DATE VARCHAR(100),
	@FLT_BILL_AMOUNT VARCHAR(100),
	@FLT_PAID VARCHAR(100),
	@FLT_BALANCE VARCHAR(10),
	@SZ_SERVICE_TYPE VARCHAR(200),
	@SZ_DENIAL_REASONS VARCHAR(8000),
	@InsuranceCompanyId VARCHAR(50),
	--@DefendantId VARCHAR(50),
	@ProviderId VARCHAR(50),
	@OperationResult INTEGER OUTPUT,
	@NewCaseOutputResult VARCHAR(100) OUTPUT
AS
BEGIN
	DECLARE @Case_Id AS NVARCHAR(20)
	DECLARE @CurrentDate AS SMALLDATETIME  
	DECLARE @Date_Opened AS DATETIME
	DECLARE @InjuredParty_LastName AS VARCHAR(100)
	DECLARE @InjuredParty_FirstName AS VARCHAR(100)
	DECLARE @InsuredParty_LastName AS VARCHAR(100)
	DECLARE @InsuredParty_FirstName AS VARCHAR(100)
	DECLARE @DR_1 VARCHAR(max)
	DECLARE @TREATMENTID INT
	DECLARE @DENIAL_ID INT
	DECLARE @COUNT INT
	DECLARE @NOTES AS VARCHAR(MAX)
	
	CREATE TABLE #TEMP
	(
		SZ_DENIALREASONS VARCHAR(8000)
	)
	INSERT INTO #TEMP
	select * from ufn_CSVToTable(@SZ_DENIAL_REASONS)

	-- Remove Leading and ending spaces from the input parameters  
	SET @InjuredParty_LastName = RTRIM(LTRIM(SUBSTRING(@SZ_PATIENT_NAME,CHARINDEX(' ',@SZ_PATIENT_NAME) + 1,LEN(@SZ_PATIENT_NAME))))
	SET @InjuredParty_FirstName = RTRIM(LTRIM(SUBSTRING(@SZ_PATIENT_NAME,0,CHARINDEX(' ',@SZ_PATIENT_NAME)))) 

	SET @InsuredParty_FirstName = RTRIM(LTRIM(SUBSTRING(@SZ_POLICY_HOLDER,CHARINDEX(',',@SZ_POLICY_HOLDER) + 1,LEN(@SZ_POLICY_HOLDER))))
	SET @InsuredParty_LastName = RTRIM(LTRIM(SUBSTRING(@SZ_POLICY_HOLDER,0,CHARINDEX(',',@SZ_POLICY_HOLDER)))) 

	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	SET @Case_Id = (Select Case_Id    
		FROM  tblCase  
		WHERE   
		Provider_Id = @ProviderId and   
		InjuredParty_LastName = @InjuredParty_LastName and   
		InjuredParty_FirstName = @InjuredParty_FirstName and  
		Accident_Date = @DT_DATE_OF_ACCIDENT and   
		Policy_Number = @SZ_POLICY_NUMBER)

	IF @Case_Id != '' OR @Case_Id IS NOT NULL
	BEGIN
		DECLARE @BILLNUM AS INT
		DECLARE @CASE_CURRENT_STATUS AS NVARCHAR(100)
		SET @CASE_CURRENT_STATUS = (SELECT STATUS FROM TBLCASE WHERE CASE_ID = @Case_Id)
		IF @CASE_CURRENT_STATUS = 'GB-OPEN'
		BEGIN
			IF EXISTS(SELECT BILL_NUMBER FROM TBLTREATMENT WHERE BILL_NUMBER = @SZ_BILL_NUMBER AND CASE_ID = @Case_Id)
			BEGIN			
				UPDATE
					TBLTREATMENT
				SET
					DateOfService_Start = @DT_START_VISIT_DATE,
					DateOfService_End = @DT_END_VISIT_DATE,
					Claim_Amount = @FLT_BILL_AMOUNT,
					Paid_Amount = @FLT_PAID,
					SERVICE_TYPE = @SZ_SERVICE_TYPE
				WHERE
					CASE_ID = @Case_Id
					and
					BILL_NUMBER = @SZ_BILL_NUMBER
				SET @NOTES = 'Bill updated for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
				exec LCJ_AddNotes @case_id=@Case_Id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0	
			END
			ELSE
			BEGIN
				IF EXISTS(SELECT TOP 1 SZ_DENIALREASONS FROM #TEMP)
				BEGIN
					SET @DR_1 = (SELECT TOP 1 SZ_DENIALREASONS FROM #TEMP)
					INSERT INTO TBLTREATMENT
					(
						Case_Id,
						DateOfService_Start,
						DateOfService_End,
						Claim_Amount,
						Paid_Amount,
						BILL_NUMBER,
						SERVICE_TYPE
					)
					VALUES
					(
						@Case_Id,
						@DT_START_VISIT_DATE,
						@DT_END_VISIT_DATE,
						@FLT_BILL_AMOUNT,
						@FLT_PAID,
						@SZ_BILL_NUMBER,
						@SZ_SERVICE_TYPE
						
					)
					
					
					SET @TREATMENTID = (SELECT MAX(TREATMENT_ID) FROM TBLTREATMENT WHERE CASE_ID = @Case_Id)
					
					INSERT INTO TXN_tblTreatment (DenialReasons_Id,Treatment_Id)
					SELECT @DR_1,@TREATMENTID
					
					SET @COUNT = 0
					DECLARE BILL_CURSOR_1 CURSOR FOR
					SELECT SZ_DENIALREASONS FROM #TEMP
					OPEN BILL_CURSOR_1
					FETCH NEXT FROM BILL_CURSOR_1
					INTO @DR_1
					WHILE @@FETCH_STATUS = 0
					BEGIN
						IF @COUNT <> 0
						BEGIN
							EXEC GET_INSERT_DENIAL_REASONS_DETAILS @SZ_DENIAL_REASON = @DR_1,@SZ_DENIAL_ID = @DENIAL_ID OUTPUT
							EXEC Insert_Denial_Reasons @Treatment_Id = @TREATMENTID,@DenialReasons_Id = @DENIAL_ID
						END
						SET @COUNT = 1
						FETCH NEXT FROM BILL_CURSOR_1
						INTO @DR_1
					END			
					CLOSE BILL_CURSOR_1
					DEALLOCATE BILL_CURSOR_1
					
					SET @NOTES = 'Bill added for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
					exec LCJ_AddNotes @case_id=@Case_Id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0


				END
				ELSE
				BEGIN
					INSERT INTO TBLTREATMENT
					(
						Case_Id,
						DateOfService_Start,
						DateOfService_End,
						Claim_Amount,
						Paid_Amount,
						BILL_NUMBER,
						SERVICE_TYPE
					)
					VALUES
					(
						@Case_Id,
						@DT_START_VISIT_DATE,
						@DT_END_VISIT_DATE,
						@FLT_BILL_AMOUNT,
						@FLT_PAID,
						@SZ_BILL_NUMBER,
						@SZ_SERVICE_TYPE
					)
					SET @NOTES = 'Bill added for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
					exec LCJ_AddNotes @case_id=@Case_Id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0
				END
				
			END
			SET @OperationResult = 2
		END
	END  
   
	ELSE  
	BEGIN     
		DECLARE @MaxCase_Id INTEGER  
		DECLARE @Case_Id_IDENTITY INTEGER  
		DECLARE @MaxCase_AUTOID INTEGER  

		SELECT  @MaxCase_AUTOID=MAX(Case_AUTOID)+1 FROM TBLCASE
		Insert INTO tblCase   
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
			Initial_Status 
		)       
		VALUES  
		(  
			'',
			@ProviderId,  
			@InsuranceCompanyId,  
			@InjuredParty_LastName,  
			@InjuredParty_FirstName,  
			@InsuredParty_LastName,  
			@InsuredParty_FirstName,  
			Convert(nvarchar(15), @DT_DATE_OF_ACCIDENT, 101),  
			@SZ_POLICY_NUMBER,  
			@SZ_CLAIM_NUMBER, 
			'GB-OPEN',  
			Convert(nvarchar(15), getdate(),101),
			'GB-LIT'
		)

		SET  @Case_Id_IDENTITY = @@IDENTITY   
		SET @Case_Id  = 'RFA' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@Case_Id_IDENTITY AS NVARCHAR)  
		UPDATE tblCase SET Case_Id = @Case_Id where Case_AutoId = @Case_Id_IDENTITY
		EXEC LCJ_AddNotes @Case_Id = @Case_Id,@Notes_Type='A',@NDesc='Case Opened',@User_Id='system',@ApplyToGroup=0
		
		IF EXISTS(SELECT TOP 1 SZ_DENIALREASONS FROM #TEMP)
		BEGIN
			SET @DR_1 = (SELECT TOP 1 SZ_DENIALREASONS FROM #TEMP)
			INSERT INTO TBLTREATMENT
			(
				Case_Id,
				DateOfService_Start,
				DateOfService_End,
				Claim_Amount,
				Paid_Amount,
				BILL_NUMBER,
				SERVICE_TYPE
			)
			VALUES
			(
				@Case_Id,
				@DT_START_VISIT_DATE,
				@DT_END_VISIT_DATE,
				@FLT_BILL_AMOUNT,
				@FLT_PAID,
				@SZ_BILL_NUMBER,
				@SZ_SERVICE_TYPE
			)
			SET @TREATMENTID = (SELECT MAX(TREATMENT_ID) FROM TBLTREATMENT WHERE CASE_ID = @Case_Id)
			INSERT INTO TXN_tblTreatment (DenialReasons_Id,Treatment_Id)
			SELECT @DR_1,@TREATMENTID
					
			SET @COUNT = 0
			DECLARE BILL_CURSOR_2 CURSOR FOR
			SELECT SZ_DENIALREASONS FROM #TEMP
			OPEN BILL_CURSOR_2
			FETCH NEXT FROM BILL_CURSOR_2
			INTO @DR_1
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @COUNT <> 0
				BEGIN
					EXEC GET_INSERT_DENIAL_REASONS_DETAILS @SZ_DENIAL_REASON = @DR_1,@SZ_DENIAL_ID = @DENIAL_ID OUTPUT
					EXEC Insert_Denial_Reasons @Treatment_Id = @TREATMENTID,@DenialReasons_Id = @DENIAL_ID
				END
				SET @COUNT = 1
				FETCH NEXT FROM BILL_CURSOR_2
				INTO @DR_1
			END			
			CLOSE BILL_CURSOR_2
			DEALLOCATE BILL_CURSOR_2
			SET @NOTES = 'Bill added for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
					exec LCJ_AddNotes @case_id=@Case_Id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0
		END
		ELSE
		BEGIN
			INSERT INTO TBLTREATMENT
			(
				Case_Id,
				DateOfService_Start,
				DateOfService_End,
				Claim_Amount,
				Paid_Amount,
				BILL_NUMBER,
				SERVICE_TYPE
			)
			VALUES
			(
				@Case_Id,
				@DT_START_VISIT_DATE,
				@DT_END_VISIT_DATE,
				@FLT_BILL_AMOUNT,
				@FLT_PAID,
				@SZ_BILL_NUMBER,
				@SZ_SERVICE_TYPE
			)
			SET @NOTES = 'Bill added for DOS ' + convert(varchar(9),@DT_START_VISIT_DATE) + ' - ' + convert(varchar(9),@DT_END_VISIT_DATE)
					exec LCJ_AddNotes @case_id=@Case_Id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='system',@Applytogroup=0
		END
		UPDATE GREENBILLSCASES SET FHKP_CASE_ID = @Case_Id WHERE SZ_COMPANY_ID = @SZ_COMPANY_ID AND SZ_CASE_ID = @SZ_CASE_ID		
	END
	SET @NewCaseOutputResult = @Case_Id 
	DROP TABLE #TEMP
END

