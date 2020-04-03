CREATE PROCEDURE [dbo].[USP_BulkImportCases]
(
  @tblExcelCases dbo.ExcelImportTypes READONLY
 ,@DomainID varchar(50)
 ,@UserID varchar(50)
 ,@Error int output
)

AS BEGIN

	BEGIN TRANSACTION

	DECLARE @TotalCount INT = 0
	DECLARE @Counter INT = 1
	DECLARE @ProviderName VARCHAR(255)
	DECLARE @InsuranceCompany VARCHAR(255)
	DECLARE @InsuranceCompanyGroup VARCHAR(255)
	DECLARE @InsuranceCompanyGroupID INT
	DECLARE @ProviderID INT
	DECLARE @InsuranceCompanyID INT
	DECLARE @CaseId nvarchar(50)
	DECLARE @MaxCase_ID VARCHAR(100)
	DECLARE @MaxCaseAuto_ID INT
	DECLARE @AttorneyId INT
	DECLARE @AttorneyName VARCHAR(200)
    DECLARE @Attorney_Type_ID INT
BEGIN TRY

    Declare @CompanyType varchar(150)=''

	Select TOP 1 @CompanyType = LOWER(LTRIM(RTRIM(CompanyType))) from tbl_Client(NOLOCK) Where DomainId=@DomainID

	SELECT * into #temp FROM @tblExcelCases
	
	DECLARE @Case TABLE
	(
		Id INT IDENTITY(1,1),
		Provider varchar(200),
		PurchaseDate varchar(100),
		Insured varchar(200),
		InsCompany varchar(200),
		InsuranceGroup VARCHAR(255),
		ClaimNo varchar(100),
		DOL varchar(100) null,
		DOS varchar(100) null,
		DOFN varchar(100) null,
		InvoiceAmt varchar(100),
		PartialPmts varchar(150),
		CaseNo varchar(50),
		FilingDate varchar(50) null ,
		Attorney varchar(200) null,
		ProviderID INT,
		InsuranceProviderID INT,
		InsuredFirstName VARCHAR(200),
		InsuredLastName VARCHAR(200),
		AttorneyID INT,
		AttorneyName VARCHAR(200),
		Attorney_FirstName VARCHAR(200),
		Attorney_LastName VARCHAR(200),
		Paid_Amount VARCHAR(50) ,
		AtlasCaseID VARCHAR(50),
		PortfolioId int
		,[Status] varchar(100)

	);


	--Insert data to Table variable @TStudent
	INSERT INTO  @Case
	(
		Provider,
		PurchaseDate,
		Insured,
		InsCompany,
		--InsuranceGroup,
		ClaimNo,
		DOL,
		DOS,
		DOFN,
		InvoiceAmt,
		PartialPmts,
		CaseNo,
		FilingDate,
		Attorney,
		Paid_Amount,
		PortfolioId,
		[Status]
	)
	SELECT Provider,PurchaseDate,Insured,InsCompany,ClaimNo,
			DOL,	DOS,		DOFN,	InvoiceAmt,		PartialPmts,CaseNo,		FilingDate,		Attorney,		Paid_Amount,Portfolioid,Status  FROM #temp


	UPDATE	@Case
	SET		FilingDate = null
	WHERE	FilingDate IN
	(		
		'Settled',
		'Buy Back',
		'Dismissed',
		'Sub'
	)


	UPDATE @Case
	SET		InsuredFirstName = CASE 
				WHEN CHARINDEX(',', Insured) > 0 THEN SUBSTRING(Insured, CHARINDEX(',', Insured) + 2, 200)
				ELSE Insured
				END,
			InsuredLastName = CASE 
				WHEN CHARINDEX(',', Insured) > 0 THEN SUBSTRING(Insured, 1, CHARINDEX(',', Insured) -1)
				ELSE ''
				END
 
	UPDATE	@Case
	SET		[Provider] = LTRIM(RTRIM(Provider)),
			InsCompany = LTRIM(RTRIM(InsCompany)),
			InsuranceGroup = LTRIM(RTRIM(InsuranceGroup)),
			Attorney = LTRIM(RTRIM(Attorney)),
			InsuredFirstName = LTRIM(RTRIM(InsuredFirstName)),
			InsuredLastName = LTRIM(RTRIM(InsuredLastName))

	--Retrieve ProviderID, Insurance COmpnayID and CaseID for Existing Cases
	
	UPDATE	@Case
	SET		status = null
	where status=''
	
	UPDATE @Case
	SET DOFN = null
	WHERE DOFN =''
	

	UPDATE	c
	SET		ProviderID = p.Provider_Id,
			InsuranceProviderID	= i.InsuranceCompany_Id,
			AtlasCaseID = lc.Case_Id
	FROM	@Case c
	JOIN	tblcase lc ON lc.InsuredParty_FirstName = c.InsuredFirstName
							AND InsuredParty_LastName = c.InsuredLastName
							AND Ins_Claim_Number = c.ClaimNo
	JOIN	tblInsuranceCompany i ON i.InsuranceCompany_Name = c.InsCompany
	JOIN	tblProvider p ON p.Provider_Name = c.[Provider]
	WHERE	@DomainID = lc.domainid
	AND		ISNULL(IsDeleted,0) = 0


	--UPDATE EXISTING CASE INFORMATION
	UPDATE	tblTreatment
	SET		Claim_Amount = CASE WHEN ISNUMERIC(c.InvoiceAmt) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), c.InvoiceAmt) END ,
			Paid_Amount = CASE WHEN ISNUMERIC(c.Paid_Amount) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), c.Paid_Amount) END
	FROM	tblTreatment treament 
	JOIN	tblcase cases  ON treament.Case_Id = cases.case_Id
	JOIN	@Case c ON c.AtlasCaseID = cases.Case_Id
					AND c.ClaimNo = cases.Ins_Claim_Number
	WHERE	treament.DomainId = @DomainID
	

	

	SELECT @TotalCount = COUNT(*) FROM @Case
	DECLARE @company varchar(100)
	DECLARE @InsuredFirstName VARCHAR(100)
	DECLARE @InsuredLastName VARCHAR(100)
	DECLARE @ClaimNo VARCHAR(100)
	DECLARE @InvoiceAmt VARCHAR(100)
	DECLARE @PaidAmount VARCHAR(100)
	DECLARE @AtlasCaseID VARCHAR(50)
 
	WHILE(@Counter <= @TotalCount)
	BEGIN
	
		SELECT	@AtlasCaseID = AtlasCaseID
		FROM	@Case WHERE ID = @Counter
		
		IF(ISNULL(@AtlasCaseID, '') = '') -- IF Case ID not found then case data to be inserted
		BEGIN
			--Logic to Insert Case
			SELECT	@ProviderName = [Provider],
					@InsuranceCompany = InsCompany,
					@AttorneyName=Attorney
			FROM	@Case
			WHERE	ID = @Counter
 
			--INSERT Provider if not available
			SELECT	@ProviderID = Provider_Id
			FROM	[dbo].[tblProvider]
			WHERE	Provider_Name = @ProviderName
			AND		ISNULL(@ProviderName,'') <> ''
			AND DomainID = @DomainID
 
			IF(@ProviderID IS NULL AND ISNULL(@ProviderName,'') <> '')
			BEGIN
				INSERT [dbo].[tblProvider]
				(
					Provider_Name,
					Provider_Suitname,
					DomainId,
					Funding_Company
				)
				VALUES
				(
					@ProviderName,
					@ProviderName,
					@DomainID,
					''
				)
 
				SET @ProviderID = SCOPE_IDENTITY()
			END
			
			--INSERT Insurance Company if not available
			SELECT	@InsuranceCompanyID = InsuranceCompany_Id
			FROM	[dbo].[tblInsuranceCompany]
			WHERE	InsuranceCompany_Name = @InsuranceCompany
			AND		ISNULL(@InsuranceCompany,'') <> ''
			AND     DomainID = @DomainID
			
			IF(@InsuranceCompanyID IS NULL AND ISNULL(@InsuranceCompany,'') <> '')
			
			BEGIN
			
			INSERT [dbo].[tblInsuranceCompany]
			(
				InsuranceCompany_Name,
				InsuranceCompany_SuitName,
				DomainId
			)
			VALUES
			(
				@InsuranceCompany,
				@InsuranceCompany,
				@DomainID
			)
			SET @InsuranceCompanyID = SCOPE_IDENTITY()
			
			END
		--END

		--INSERT Assigned Attorney if not available
		IF @CompanyType = 'funding'
		 BEGIN
		    Select TOP 1 @Attorney_Type_ID = Attorney_Type_ID from tblAttorney_Type 
			where LOWER(LTRIM(RTRIM(Attorney_Type))) = 'plaintiff attorney' and DomainID = @DomainID
			PRINT @Attorney_Type_ID
			IF @Attorney_Type_ID IS NULL
			BEGIN
			    Insert into tblAttorney_Type(Attorney_Type,DomainID,created_by_user,created_date)
				Values ('Plaintiff Attorney', @DomainId, @UserID, GETDATE())

				SET @Attorney_Type_ID = SCOPE_IDENTITY()
			END
			PRINT 'ATT'
			PRINT '1 - ' + @AttorneyName
			Select TOP 1 @AttorneyId = Attorney_Id from tblAttorney_Master(NOLOCK) 
			where Attorney_FirstName = LTRIM(RTRIM(ISNULL(@AttorneyName,''))) AND LTRIM(RTRIM(ISNULL(@AttorneyName,''))) <> '' 
			AND Attorney_Type_Id = @Attorney_Type_ID and DomainId = @DomainID
			PRINT '2'
			IF(@AttorneyId IS NULL AND LTRIM(RTRIM(ISNULL(@AttorneyName,''))) <> '')
			 BEGIN
			 PRINT '3'
				Insert into tblAttorney_Master
				(Attorney_Type_Id, Attorney_FirstName, DomainID, created_by_user, created_date)
				Values
				(@Attorney_Type_ID, LTRIM(RTRIM(ISNULL(@AttorneyName,''))), @DomainID, @UserID, GETDATE())

				SET @AttorneyId = SCOPE_IDENTITY()
			 END
		 END
		ELSE
		 BEGIN
		 PRINT '4'
				SELECT	@AttorneyId = PK_Assigned_Attorney_ID
				FROM	[dbo].[Assigned_Attorney]
				WHERE	Assigned_Attorney = LTRIM(RTRIM(ISNULL(@AttorneyName,'')))
				AND		@AttorneyName IS NOT NULL
				AND		@AttorneyName <> ''
				and     DomainId = @DomainID

			IF(@AttorneyId IS NULL AND LTRIM(RTRIM(ISNULL(@AttorneyName,''))) <> '')
				BEGIN
					INSERT [dbo].[Assigned_Attorney]
					(
						Assigned_Attorney,
						DomainID,
						created_by_user,
						created_date
					)
					VALUES
					(
						LTRIM(RTRIM(ISNULL(@AttorneyName,''))),
						@DomainID,
						@UserID,
						GETDATE()
					)
					SET @AttorneyId = SCOPE_IDENTITY()
				END
			END
		--END

				
		--- INSERT CASE DATA
		SET @MaxCase_ID = ISNULL((SELECT TOP 1 Case_ID FROM dbo.tblCase  WHERE DomainId = @DomainID ORDER BY Case_AUTOID DESC),'100000')
		SET @MaxCaseAuto_ID = (SELECT TOP 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') ORDER BY autoid desc)
		SET @CaseId  = UPPER(@DomainID) + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)

		INSERT INTO tblcase
		(
			Case_Id,
			Provider_Id,
			InsuranceCompany_Id,
			InjuredParty_FirstName,
			InjuredParty_LastName,
			InsuredParty_FirstName,
			InsuredParty_LastName,
			Accident_Date,
			purchaseDate,
			DomainId,
			DateOfService_Start,
			Date_Index_Number_Purchased,
			[status],
			IndexOrAAA_Number,
			Assigned_Attorney,
			Ins_Claim_Number
			,PortfolioId
			,Date_Opened
		)

		SELECT       
			@CaseId,
			@ProviderID,
			@InsuranceCompanyID,
			insuredfirstname,
			InsuredLastName,
			insuredfirstname,
			InsuredLastName,						
			CASE WHEN DOL IS NULL THEN CASE WHEN purchaseDate IS NULL THEN NULL ELSE CAST(purchaseDate AS DATETIME) END ELSE CAST(DOL AS DATETIME) END ,
			
			CASE WHEN purchaseDate IS NULL THEN NULL ELSE CAST(purchaseDate AS DATETIME) END,
			@DomainID,
			CASE WHEN DOS IS NULL THEN CASE WHEN purchaseDate IS NULL THEN NULL ELSE CAST(purchaseDate AS DATETIME) END ELSE CAST( DOS AS DATETIME) END,
			CASE WHEN FilingDate IS NULL THEN NULL ELSE CAST(FilingDate AS DATETIME) END,
			Case when  status IS NULL then 'Unknown' ELSE status END,
 			CaseNo,
			@AttorneyId,
			ClaimNo
			,PortfolioId
			,GETDATE()
		FROM @Case WHERE ID = @Counter
        
		IF @CompanyType = 'funding' and @Attorney_Type_ID IS NOT NULL and @AttorneyId IS NOT NULL
		 BEGIN
		     Insert into tblAttorney_Case_Assignment
			 (Attorney_Type_Id, Attorney_Id, Case_Id, DomainId, created_by_user, created_date)
			 Values
			 (@Attorney_Type_ID, @AttorneyId, @CaseId, @DomainID, @UserID, GETDATE())
		 END

		DECLARE @amt VARCHAR(20)
		SET @amt = ''
		SET @amt = (SELECT CASE WHEN ISNUMERIC(invoiceamt) = 0 THEN 0 ELSE CONVERT(NUMERIC(18, 2), invoiceamt) END FROM @Case WHERE ID = @Counter)

		INSERT INTO tblTreatment
		(
			 Case_Id
			,DateOfService_Start
			,Date_BillSent
			,Claim_Amount
			,Paid_Amount
			,DomainId
			,Date_Created
		)
		SELECT 
			@CaseId caseid,
			CASE WHEN DOS IS NULL THEN NULL ELSE CAST(DOS AS DATETIME) END,
			CASE WHEN DOFN IS NULL THEN NULL ELSE CAST(DOFN AS DATETIME) END,
			@amt,
			convert(money,Paid_Amount)Paid_Amount,
			@DomainID domainid,
			GETDATE() 
		FROM @Case WHERE ID = @Counter


		SET @company = null
		SET @InsuredFirstName = null
		SET @InsuredLastName = null
		SET @ClaimNo = null
		
		SET @InsuranceCompanyID = null
		SET @ProviderID = null
		SET @InsuranceCompanyGroupID = null
		SET @company = null
		SET @InsuredFirstName = null
		SET @InsuredLastName = null
		SET @ClaimNo = null

		END

		SET @Counter = @Counter + 1
	END

	
	 
   declare @countInsertUpdate int =0
   set @countInsertUpdate= (select count(Id) total from @case where AtlasCaseID IS NULL or AtlasCaseID IS not NULL)
	
	IF (@countInsertUpdate = 0)
    BEGIN
        SET @Error =0
    END
	else
	  SET @Error = @countInsertUpdate

	Select @Error
	-- SELECT 1/0

	COMMIT TRANSACTION
	--ROLLBACK TRANSACTION
 
END TRY
BEGIN CATCH

 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    SELECT 
   @Error=   ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

PRINT @AttorneyName
RETURN;
ROLLBACK TRANSACTION
END CATCH;

END


