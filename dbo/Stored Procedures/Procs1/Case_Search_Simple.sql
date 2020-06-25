CREATE PROCEDURE [dbo].[Case_Search_Simple] ( 
	@strCaseId VARCHAR(50) = ''
	,@Status VARCHAR(50) = ''
	,@InjuredParty_LastName VARCHAR(50) = ''
	,@InjuredParty_FirstName VARCHAR(50) = ''
	,@InsuredParty_LastName VARCHAR(50) = ''
	,@InsuredParty_FirstName VARCHAR(50) = ''
	,@Policy_Number VARCHAR(100) = ''
	,@Ins_Claim_Number VARCHAR(100) = ''
	,@IndexOrAAA_Number VARCHAR(100) = ''
	,@Provider_Id INT = 0
	,@InsuranceCompany_Id INT = 0
	,@SZ_USER_ID INT = 0
	,@AssignedValue INT = 0
	,@DenialReasons_Id INT = 0
	,@s_a_Rebuttal_Status VARCHAR(100) = ''
	,@DomainId VARCHAR(50) = 'test'
	,@PortfolioId INT = 0
	,@AttorneyFirmId INT = 0
	,@Reference_CaseId VARCHAR(50) = ''
	,@InitialStatus VARCHAR(100) = ''
	,@AccidentDate VARCHAR(100) = ''
	,@strBill_No VARCHAR(100) = ''
	,@Provider_Group VARCHAR(100) = ''
	,@ProviderName VARCHAR(200) = ''
	,@InsuranceName VARCHAR(200) = ''
	,@s_a_FinalStatus VARCHAR(100) = ''
	,@s_a_Forum VARCHAR(100) = ''
	,@s_a_PacketId VARCHAR(100) = ''
	,@ChequeNo VARCHAR(100) = ''
	,@Attorney_FirstName VARCHAR(50) = ''
	,@Attorney_LastName VARCHAR(50) = ''
	,@Adjuster_LastName VARCHAR(50) = ''
	,@Adjuster_FirstName VARCHAR(50) = ''
	,@StartIndex INT
	,@EndIndex INT
	,@SortBy VARCHAR(50) = 'Case_Id'    
    ,@SortOrder VARCHAR(50)='Descending' 
	,@i_a_Court	VARCHAR(MAX) ='0'      
	,@i_a_Defendant	INT	=	0
	)
	WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET @strCaseId = (LTRIM(RTRIM(@strCaseId)))

	

	DECLARE @strsql AS VARCHAR(max)
	DECLARE @InvestorId AS INT = 0

	SELECT @InvestorId = InvestorId
	FROM Tbl_Investor
	WHERE UserId = @SZ_USER_ID
		AND DomainId = @DomainId

	DECLARE @CompanyType VARCHAR(150) = ''

	SELECT TOP 1 @CompanyType = LOWER(LTRIM(RTRIM(CompanyType)))
	FROM tbl_Client(NOLOCK)
	WHERE DomainId = @DomainID

	IF (
			@StartIndex > 0
			AND @EndIndex > 0
			)
	BEGIN
		SELECT  *
		FROM (
			SELECT
				--TotalRowCount = COUNT(*) OVER (),
				ROW_NUMBER() OVER (
					--ORDER BY case_autoid DESC
					  ORDER BY    
          
    
					   CASE WHEN @SortBy  = 'Case_Id' and  @SortOrder = 'Descending' THEN tblcase.Case_AutoID END DESC,    
					   CASE WHEN @SortBy  = 'Case_Age' and  @SortOrder = 'Descending' THEN DateDiff(dd, Date_Opened, GETDATE()) END DESC,    
					   CASE WHEN @SortBy  = 'Status_Age' and  @SortOrder = 'Descending' THEN DateDiff(dd, ISNULL(Date_Status_Changed, Date_Opened), GETDATE()) END DESC,  
					   --CASE WHEN @SortBy  = 'InjuredParty_Name' and  @SortOrder = 'Descending' THEN InjuredParty_LastName END DESC, 
					   CASE WHEN @SortBy  = 'InjuredParty_Name' and  @SortOrder = 'Descending' THEN (LTRIM(InjuredParty_LastName) + ',' + LTRIM(InjuredParty_FirstName)) END DESC,    
					   CASE WHEN @SortBy  = 'Provider_Name' and  @SortOrder = 'Descending' THEN Provider_Name END DESC,    
           
           
					   CASE @SortBy WHEN 'Case_Id' THEN tblcase.Case_AutoID END,    
					   CASE @SortBy WHEN 'Case_Age' THEN DateDiff(dd, Date_Opened, GETDATE()) END,    
					   CASE @SortBy WHEN 'Status_Age' THEN DateDiff(dd, ISNULL(Date_Status_Changed, Date_Opened), GETDATE()) END,    
					   CASE @SortBy WHEN 'InjuredParty_Name' THEN (LTRIM(InjuredParty_LastName) + ',' + LTRIM(InjuredParty_FirstName)) END ASC,  
					  -- CASE @SortBy WHEN 'InjuredParty_Name' THEN InjuredParty_LastName  END,
					   CASE @SortBy WHEN 'Provider_Name' THEN Provider_Name END    







					) AS ROWID
				,tblcase.Case_Id
				,(LTRIM(InjuredParty_LastName) + ',' + LTRIM(InjuredParty_FirstName)) AS InjuredParty_Name
				,(Attorney_LastName + ',' + Attorney_FirstName) AS Attorney_Name
				,(Adjuster_LastName + ',' + Adjuster_FirstName) AS Adjuster_Name
				,iif(@CompanyType != 'funding', a_att.Assigned_Attorney, SUBSTRING(ISNULL(STUFF((
									SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull(Attorney_LastName, '') + ', ', ' - ')
									FROM tblAttorney_Case_Assignment aa(NOLOCK)
									INNER JOIN tblAttorney_Master am(NOLOCK) ON am.Attorney_Id = aa.Attorney_Id
									INNER JOIN tblAttorney_Type atp(NOLOCK) ON atp.Attorney_Type_ID = am.Attorney_Type_Id
									WHERE aa.Case_Id = tblcase.Case_Id
										AND Lower(Attorney_Type) = 'plaintiff attorney'
										AND aa.DomainId = @DomainId
										AND (
											@Attorney_FirstName = ''
											OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
											)
										AND (
											@Attorney_LastName = ''
											OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
											)
									FOR XML path('')
									), 1, 0, ''), ','), 1, (
							LEN(ISNULL(STUFF((
											SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull(Attorney_LastName, '') + ', ', ' - ')
											FROM tblAttorney_Case_Assignment aa(NOLOCK)
											INNER JOIN tblAttorney_Master am(NOLOCK) ON am.Attorney_Id = aa.Attorney_Id
											INNER JOIN tblAttorney_Type atp(NOLOCK) ON atp.Attorney_Type_ID = am.Attorney_Type_Id
											WHERE aa.Case_Id = tblcase.Case_Id
												AND Lower(Attorney_Type) = 'plaintiff attorney'
												AND aa.DomainId = @DomainId
												AND (
													@Attorney_FirstName = ''
													OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
													)
												AND (
													@Attorney_LastName = ''
													OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
													)
											FOR XML path('')
											), 1, 0, ''), ','))
							) - 1)) AS Assigned_Attorney
				,Provider_Name
				,tblprovider.Provider_GroupName
				,InsuranceCompany_Name


				--,(CASE	WHEN Accident_Date IS NULL OR Accident_Date = '' THEN ''
				--		ELSE convert(varchar(10), Accident_Date,101)
				--		END
				--) AS Accident_Date

				,convert(varchar(10), Accident_Date,101) AS Accident_Date

				,(CASE	WHEN tblCase.DateOfService_Start IS NULL OR tblCase.DateOfService_Start = '' THEN ''
						ELSE convert(varchar(10), tblCase.DateOfService_Start,101)
						END
				) AS DateOfService_Start
				,(CASE	WHEN tblCase.DateOfService_End IS NULL OR tblCase.DateOfService_End = '' THEN ''
						ELSE convert(varchar(10), tblCase.DateOfService_End,101)
						END
				) AS DateOfService_End
				,STATUS
				,Rebuttal_Status

				,Ins_Claim_Number
				,Policy_Number
				,
				--convert(varchar, Date_BillSent, 101) as Date_BillSent,        
				(CASE	WHEN tblCase.Date_BillSent IS NULL OR tblCase.Date_BillSent = '' THEN ''
						ELSE convert(varchar(10), tblCase.Date_BillSent,101)
						END
				) AS Date_BillSent
				,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Claim_Amount)))) AS Claim_Amount
				,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Paid_Amount)))) AS Paid_Amount
				,(
					SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(transactions_amount)))))
					FROM tblTransactions(NOLOCK)
					WHERE tblTransactions.case_id = tblcase.Case_Id
						AND DomainId = @DomainId
						AND Transactions_Type IN (
							'PreC'
							,'PreCToP'
							)
					) [Voluntary_Payment]
				,(
					SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(transactions_amount)))))
					FROM tblTransactions(NOLOCK)
					WHERE tblTransactions.case_id = tblcase.Case_Id
						AND DomainId = @DomainId
						AND Transactions_Type IN (
							'C'
							,'I'
							)
					) [Collection_Payment]
				,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Claim_Amount) - convert(FLOAT, Paid_Amount) - ISNULL(WriteOff, 0)))) AS Claim_Balance
				,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Fee_Schedule)))) AS FS_Amount
				,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Fee_Schedule) - convert(FLOAT, Paid_Amount) - ISNULL(WriteOff, 0)))) AS FS_Balance
				,(
					SELECT TOP 1 bill_number
					FROM tblTreatment(NOLOCK)
					WHERE ISNULL(bill_number, '') <> ''
						AND case_id = tblcase.case_id
						AND domainid = tblcase.DomainId
					) AS BillNumber
				,convert(VARCHAR, ISNULL(tblCase.Date_Opened, ''), 101) AS Date_Opened
				,IndexOrAAA_Number
				,tblCase.Initial_Status
				,(
					SELECT TOP 1 a.Case_Id
					FROM tblCase a(NOLOCK)
					WHERE a.Provider_Id = tblcase.Provider_Id
						AND a.InjuredParty_LastName = tblcase.InjuredParty_LastName
						AND a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName
						AND a.Accident_Date = tblcase.Accident_Date
						AND a.Case_Id <> tblcase.case_id
					) AS Similar_To_Case_ID
				,AF.Name AttorneyFirmName
				,PF.Name PortfolioName
				,ISNULL(tblCase.case_code, '') AS Reference_CaseId
				,DenialReasons_Type AS DenialReasons
				,sta.forum
				,sta.Final_Status
				,p.PacketID
				,StatusDisposition
				,DateDiff(dd, ISNULL(Date_Status_Changed, Date_Opened), GETDATE()) AS Status_Age
				,DateDiff(dd, Date_Opened, GETDATE()) AS Case_Age
				,(
					SELECT TOP 1 ChequeNo
					FROM tblTransactions(NOLOCK)
					WHERE ISNULL(ChequeNo, '') <> ''
						AND case_id = tblcase.case_id
						AND domainid = tblcase.DomainID
					) AS ChequeNo,
					court.Court_Name,
								(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = tblcase.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = tblcase.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel,

		   convert(decimal(38,2),(select  ISNULL(sum(DISTINCT ISNULL(Settlement_AF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = tblcase.case_id)) as  [ATTORNEYFEE],    
           convert(decimal(38,2),(select ISNULL(sum(DISTINCT ISNULL(Settlement_FF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = tblcase.case_id)) as [FILINGFEE]
			FROM tblcase AS tblcase(NOLOCK)
			LEFT JOIN tblprovider AS tblprovider(NOLOCK) ON tblcase.provider_id = tblprovider.provider_id
			LEFT JOIN tblinsurancecompany AS tblinsurancecompany(NOLOCK) ON tblcase.insurancecompany_id = tblinsurancecompany.insurancecompany_id
			LEFT JOIN tbl_portfolio PF(NOLOCK) ON tblcase.PortfolioId = PF.id
			LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON tblcase.AttorneyFirmId = AF.id
			LEFT JOIN dbo.tblStatus sta(NOLOCK) ON tblcase.STATUS = sta.Status_Type
				AND tblcase.DomainId = sta.DomainId
			LEFT JOIN tblPacket p(NOLOCK) ON tblcase.FK_Packet_ID = p.Packet_Auto_ID
			LEFT JOIN tblAttorney att(NOLOCK) ON tblcase.Attorney_Id = att.Attorney_Id
			LEFT JOIN tblAdjusters adj(NOLOCK) ON tblcase.Adjuster_Id = adj.Adjuster_Id
			LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON tblcase.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
			LEFT JOIN tblCourt court(nolock) ON tblcase.Court_id=court.court_id
			LEFT JOIN tblDefendant d(NOLOCK) ON tblcase.Defendant_id = d.Defendant_Id
			WHERE tblcase.DomainId = @DomainId
				AND ISNULL(tblcase.IsDeleted, 0) = 0
				AND (tblcase.domainid = 'DK' OR tblCase.STATUS <> 'IN ARB OR LIT')
				
				AND (
					@strCaseId = ''
					OR tblcase.Case_Id LIKE '%' + @strCaseId + '%'
					)
				AND (
					@Reference_CaseId = ''
					OR tblCase.case_code LIKE '%' + @Reference_CaseId + '%'
					)
				AND (
					STATUS = @Status
					OR @Status = ''
					OR @Status = '0'
					OR @Status = 'all'
					OR @Status = 'all'
					)
				AND (
					@s_a_Rebuttal_Status = ''
					OR Rebuttal_Status = @s_a_Rebuttal_Status
					)
				AND (
					@InjuredParty_LastName = ''
					OR InjuredParty_LastName LIKE '%' + @InjuredParty_LastName + '%'
					)
				AND (
					@InjuredParty_FirstName = ''
					OR InjuredParty_FirstName LIKE '%' + @InjuredParty_FirstName + '%'
					)
				AND (
					@InsuredParty_LastName = ''
					OR InsuredParty_LastName LIKE '%' + @InsuredParty_LastName + '%'
					)
				AND (
					@InsuredParty_FirstName = ''
					OR InsuredParty_FirstName LIKE '%' + @InsuredParty_FirstName + '%'
					)
				AND (
					(
						@CompanyType != 'funding'
						AND (
							@Attorney_FirstName = ''
							OR Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
							)
						AND (
							@Attorney_LastName = ''
							OR Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
							)
						)
					OR (
						@CompanyType = 'funding'
						AND (
							(
								SELECT Count(*)
								FROM tblAttorney_Case_Assignment(NOLOCK) ACA
								INNER JOIN tblAttorney_Master AM(NOLOCK) ON AM.Attorney_Id = ACA.Attorney_Id
								INNER JOIN tblAttorney_Type ATP ON AM.Attorney_Type_Id = ATP.Attorney_Type_ID
								WHERE ACA.Case_Id = tblcase.Case_Id
									AND ACA.DomainId = @DomainId
									AND LOWER(Attorney_Type) = 'plaintiff attorney'
									AND (
										@Attorney_FirstName = ''
										OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
										)
									AND (
										@Attorney_LastName = ''
										OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
										)
								) > 0
							OR (
								@Attorney_FirstName = ''
								AND @Attorney_LastName = ''
								)
							)
						)
					)
				AND (
					@Adjuster_FirstName = ''
					OR Adjuster_FirstName LIKE '%' + @Adjuster_FirstName + '%'
					)
				AND (
					@Adjuster_LastName = ''
					OR Adjuster_LastName LIKE '%' + @Adjuster_LastName + '%'
					)
				AND (
					@ProviderName = ''
					OR Provider_Name LIKE '%' + @ProviderName + '%'
					)
				AND (
					@InsuranceName = ''
					OR InsuranceCompany_Name LIKE '%' + @InsuranceName + '%'
					)
				AND (
					@Policy_Number = ''
					OR Policy_Number = @Policy_Number
					)
				AND (
					@Ins_Claim_Number = ''
					OR Replace(Ins_Claim_Number, '-', '') LIKE '%' + Replace(@Ins_Claim_Number, '-', '') + '%'
					)
				AND (
					@IndexOrAAA_Number = ''
					OR Replace(IndexOrAAA_Number, '-', '') LIKE '%' + Replace(@IndexOrAAA_Number, '-', '') + '%'
					)
				AND (
					@Provider_Id = 0
					OR tblcase.Provider_ID = @Provider_Id
					)
				AND (
					@InsuranceCompany_Id = 0
					OR tblcase.InsuranceCompany_Id = @InsuranceCompany_Id
					)
				AND (
					@AssignedValue = 0
					OR tblCase.UserId = @SZ_USER_ID
					)
				AND (
					@strBill_No = ''
					OR tblcase.Case_Id IN (
						SELECT Case_Id
						FROM tbltreatment
						WHERE BILL_NUMBER LIKE '%' + @strBill_No + '%'
						)
					)
				AND (
					@Provider_Group = ''
					OR tblprovider.Provider_GroupName = @Provider_Group
					)
				AND (
					@DenialReasons_Id = 0
					OR tblcase.case_id IN (
						SELECT DISTINCT case_id
						FROM tbltreatment(NOLOCK)
						WHERE DenialReason_Id = @DenialReasons_Id
							AND DomainId = @DomainId
							OR treatment_id IN (
								SELECT treatment_id
								FROM TXN_tblTreatment(NOLOCK)
								WHERE DenialReasons_id = @DenialReasons_Id
									AND DomainId = @DomainId
								)
						)
					)
				AND (
					@PortfolioId = 0
					OR tblcase.PortfolioId = @PortfolioId
					)
				AND (
					@AttorneyFirmId = 0
					OR tblcase.AttorneyFirmId = @AttorneyFirmId
					)
				AND (
					@InitialStatus = ''
					OR Initial_Status LIKE '%' + @InitialStatus + '%'
					)
				AND (
					@AccidentDate = ''
					OR convert(VARCHAR, Accident_Date, 101) LIKE '%' + @AccidentDate + '%'
					)
				AND (
					@s_a_FinalStatus = ''
					OR ISNULL(sta.Final_Status, '') = @s_a_FinalStatus OR 
					(ISNULL(sta.Final_Status, '') = (Case when @s_a_FinalStatus= 'OPEN AND CLOSED'   then  ('OPEN')   end)
					OR ISNULL(sta.Final_Status, '') = (Case when @s_a_FinalStatus= 'OPEN AND CLOSED' then  ('CLOSED') end))
					
					)
				AND (
					@s_a_Forum = ''
					OR ISNULL(sta.forum, '') = @s_a_Forum
					)
			     AND (@i_a_Court = '0' OR tblcase.Court_Id =@i_a_Court)

				 AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR tblcase.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = tblcase.Case_Id and DomainId = @DomainId) > 0))


				AND (
					@s_a_PacketId = ''
					OR p.PacketID LIKE '%' + @s_a_PacketId + '%'
					)
				AND (
					@ChequeNo = ''
					OR tblcase.case_id IN (
						SELECT DISTINCT CASE_ID
						FROM tblTransactions(NOLOCK)
						WHERE DomainId = @DomainId
							AND Replace(ChequeNo, '-', '') LIKE '%' + Replace(@ChequeNo, '-', '') + '%'
						)
					)
			) AS tbl
		WHERE tbl.ROWID >= @StartIndex
			AND tbl.ROWID <= @EndIndex

		SELECT TotalRowCount = COUNT(case_autoid)
		FROM tblcase AS tblcase(NOLOCK)
		LEFT JOIN tblprovider AS tblprovider(NOLOCK) ON tblcase.provider_id = tblprovider.provider_id
		LEFT JOIN tblinsurancecompany AS tblinsurancecompany(NOLOCK) ON tblcase.insurancecompany_id = tblinsurancecompany.insurancecompany_id
		LEFT JOIN tbl_portfolio PF(NOLOCK) ON tblcase.PortfolioId = PF.id
		LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON tblcase.AttorneyFirmId = AF.id
		LEFT JOIN dbo.tblStatus sta(NOLOCK) ON tblcase.STATUS = sta.Status_Type
			AND tblcase.DomainId = sta.DomainId
		LEFT JOIN tblPacket p(NOLOCK) ON tblcase.FK_Packet_ID = p.Packet_Auto_ID
		LEFT JOIN tblAttorney att(NOLOCK) ON tblcase.Attorney_Id = att.Attorney_Id
		LEFT JOIN tblAdjusters adj(NOLOCK) ON tblcase.Adjuster_Id = adj.Adjuster_Id
		LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON tblcase.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		LEFT JOIN tblCourt court(nolock) ON tblcase.Court_id=court.court_id
		LEFT JOIN tblDefendant d(NOLOCK) ON tblcase.Defendant_id = d.Defendant_Id
		WHERE tblcase.DomainId = @DomainId
			AND ISNULL(tblcase.IsDeleted, 0) = 0
			--AND (tblcase.domainid = 'DK' OR )
			
			-- tblCase.STATUS <> 'IN ARB OR LIT'
			AND (tblcase.domainid = 'DK' OR tblCase.STATUS <> 'IN ARB OR LIT')
			
			AND (
				@strCaseId = ''
				OR tblcase.Case_Id LIKE '%' + @strCaseId + '%'
				)
			AND (
				@Reference_CaseId = ''
				OR tblCase.case_code LIKE '%' + @Reference_CaseId + '%'
				)
			AND (
				STATUS = @Status
				OR @Status = ''
				OR @Status = '0'
				OR @Status = 'all'
				)
			AND (
				@s_a_Rebuttal_Status = ''
				OR Rebuttal_Status = @s_a_Rebuttal_Status
				)
			AND (
				@InjuredParty_LastName = ''
				OR InjuredParty_LastName LIKE '%' + @InjuredParty_LastName + '%'
				)
			AND (
				@InjuredParty_FirstName = ''
				OR InjuredParty_FirstName LIKE '%' + @InjuredParty_FirstName + '%'
				)
			AND (
				@InsuredParty_LastName = ''
				OR InsuredParty_LastName LIKE '%' + @InsuredParty_LastName + '%'
				)
			AND (
				@InsuredParty_FirstName = ''
				OR InsuredParty_FirstName LIKE '%' + @InsuredParty_FirstName + '%'
				)
			AND (
				(
					@CompanyType != 'funding'
					AND (
						@Attorney_FirstName = ''
						OR Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
						)
					AND (
						@Attorney_LastName = ''
						OR Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
						)
					)
				OR (
					@CompanyType = 'funding'
					AND (
						(
							SELECT Count(*)
							FROM tblAttorney_Case_Assignment(NOLOCK) ACA
							INNER JOIN tblAttorney_Master AM(NOLOCK) ON AM.Attorney_Id = ACA.Attorney_Id
							INNER JOIN tblAttorney_Type ATP ON AM.Attorney_Type_Id = ATP.Attorney_Type_ID
							WHERE ACA.Case_Id = tblcase.Case_Id
								AND ACA.DomainId = @DomainId
								AND LOWER(Attorney_Type) = 'plaintiff attorney'
								AND (
									@Attorney_FirstName = ''
									OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
									)
								AND (
									@Attorney_LastName = ''
									OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
									)
							) > 0
						OR (
							@Attorney_FirstName = ''
							AND @Attorney_LastName = ''
							)
						)
					)
				)
			AND (
				@Adjuster_FirstName = ''
				OR Adjuster_FirstName LIKE '%' + @Adjuster_FirstName + '%'
				)
			AND (
				@Adjuster_LastName = ''
				OR Adjuster_LastName LIKE '%' + @Adjuster_LastName + '%'
				)
			AND (
				@ProviderName = ''
				OR Provider_Name LIKE '%' + @ProviderName + '%'
				)
			AND (
				@InsuranceName = ''
				OR InsuranceCompany_Name LIKE '%' + @InsuranceName + '%'
				)
			AND (
				@Policy_Number = ''
				OR Policy_Number = @Policy_Number
				)
			AND (
				@Ins_Claim_Number = ''
				OR Replace(Ins_Claim_Number, '-', '') LIKE '%' + Replace(@Ins_Claim_Number, '-', '') + '%'
				)
			AND (
				@IndexOrAAA_Number = ''
				OR Replace(IndexOrAAA_Number, '-', '') LIKE '%' + Replace(@IndexOrAAA_Number, '-', '') + '%'
				)
			AND (
				@Provider_Id = 0
				OR tblcase.Provider_ID = @Provider_Id
				)
			AND (
				@InsuranceCompany_Id = 0
				OR tblcase.InsuranceCompany_Id = @InsuranceCompany_Id
				)
			AND (
				@AssignedValue = 0
				OR tblCase.UserId = @SZ_USER_ID
				)
			AND (
				@strBill_No = ''
				OR tblcase.Case_Id IN (
					SELECT Case_Id
					FROM tbltreatment
					WHERE BILL_NUMBER LIKE '%' + @strBill_No + '%'
					)
				)
			AND (
				@Provider_Group = ''
				OR tblprovider.Provider_GroupName = @Provider_Group
				)
			AND (
				@DenialReasons_Id = 0
				OR tblcase.case_id IN (
					SELECT DISTINCT case_id
					FROM tbltreatment(NOLOCK)
					WHERE DenialReason_Id = @DenialReasons_Id
						AND DomainId = @DomainId
						OR treatment_id IN (
							SELECT treatment_id
							FROM TXN_tblTreatment(NOLOCK)
							WHERE DenialReasons_id = @DenialReasons_Id
								AND DomainId = @DomainId
							)
					)
				)
			AND (
				@PortfolioId = 0
				OR tblcase.PortfolioId = @PortfolioId
				)
			AND (
				@AttorneyFirmId = 0
				OR tblcase.AttorneyFirmId = @AttorneyFirmId
				)
			AND (
				@InitialStatus = ''
				OR Initial_Status LIKE '%' + @InitialStatus + '%'
				)
			AND (
				@AccidentDate = ''
				OR convert(VARCHAR, Accident_Date, 101) LIKE '%' + @AccidentDate + '%'
				)
			AND (
					@s_a_FinalStatus = ''
					OR ISNULL(sta.Final_Status, '') = @s_a_FinalStatus OR 
					(ISNULL(sta.Final_Status, '') = (Case when @s_a_FinalStatus= 'OPEN AND CLOSED'   then  ('OPEN')   end)
					OR ISNULL(sta.Final_Status, '') = (Case when @s_a_FinalStatus= 'OPEN AND CLOSED' then  ('CLOSED') end))
					
					)
			AND (
				@s_a_Forum = ''
				OR ISNULL(sta.forum, '') = @s_a_Forum
				)
	        AND (@i_a_Court = '0' OR tblcase.Court_Id =@i_a_Court)
			AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR tblcase.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = tblcase.Case_Id and DomainId = @DomainId) > 0))

			AND (
				@s_a_PacketId = ''
				OR p.PacketID LIKE '%' + @s_a_PacketId + '%'
				)
			AND (
				@ChequeNo = ''
				OR tblcase.case_id IN (
					SELECT DISTINCT CASE_ID
					FROM tblTransactions(NOLOCK)
					WHERE DomainId = @DomainId
						AND Replace(ChequeNo, '-', '') LIKE '%' + Replace(@ChequeNo, '-', '') + '%'
					)
				)

				--OPTION (RECOMPILE);
			--	OPTION (OPTIMIZE FOR (@DomainID='AF'));
	END
	ELSE
	BEGIN
		SELECT tblcase.Case_Id
			,(LTRIM(REPLACE(InjuredParty_LastName, char(9), '')  ) + ',' + LTRIM(REPLACE(InjuredParty_FirstName, char(9), '') )) AS InjuredParty_Name


			
			,(Attorney_LastName + ',' + Attorney_FirstName) AS Attorney_Name
			,(Adjuster_LastName + ',' + Adjuster_FirstName) AS Adjuster_Name
			,iif(@CompanyType != 'funding', a_att.Assigned_Attorney, SUBSTRING(ISNULL(STUFF((
								SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull(Attorney_LastName, '') + ', ', ' - ')
								FROM tblAttorney_Case_Assignment aa(NOLOCK)
								INNER JOIN tblAttorney_Master am(NOLOCK) ON am.Attorney_Id = aa.Attorney_Id
								INNER JOIN tblAttorney_Type atp(NOLOCK) ON atp.Attorney_Type_ID = am.Attorney_Type_Id
								WHERE aa.Case_Id = tblcase.Case_Id
									AND Lower(Attorney_Type) = 'plaintiff attorney'
									AND aa.DomainId = @DomainId
									AND (
										@Attorney_FirstName = ''
										OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
										)
									AND (
										@Attorney_LastName = ''
										OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
										)
								FOR XML path('')
								), 1, 0, ''), ','), 1, (
						LEN(ISNULL(STUFF((
										SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull(Attorney_LastName, '') + ', ', ' - ')
										FROM tblAttorney_Case_Assignment aa(NOLOCK)
										INNER JOIN tblAttorney_Master am(NOLOCK) ON am.Attorney_Id = aa.Attorney_Id
										INNER JOIN tblAttorney_Type atp(NOLOCK) ON atp.Attorney_Type_ID = am.Attorney_Type_Id
										WHERE aa.Case_Id = tblcase.Case_Id
											AND Lower(Attorney_Type) = 'plaintiff attorney'
											AND aa.DomainId = @DomainId
											AND (
												@Attorney_FirstName = ''
												OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
												)
											AND (
												@Attorney_LastName = ''
												OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
												)
										FOR XML path('')
										), 1, 0, ''), ','))
						) - 1)) AS Assigned_Attorney
			,REPLACE(Provider_Name, char(9), '')  as Provider_Name
			,tblprovider.Provider_GroupName
			,InsuranceCompany_Name
			--,(CASE	WHEN Accident_Date IS NULL OR Accident_Date = '' THEN ''
			--		ELSE convert(varchar(10), Accident_Date,101)
			--		END
			--) AS Accident_Date

				,convert(varchar(10), Accident_Date,101)
					 AS Accident_Date

			,(CASE	WHEN tblCase.DateOfService_Start IS NULL OR tblCase.DateOfService_Start = '' THEN ''
					ELSE convert(varchar(10), tblCase.DateOfService_Start,101)
					END
			) AS DateOfService_Start
			,(CASE	WHEN tblCase.DateOfService_End IS NULL OR tblCase.DateOfService_End = '' THEN ''
					ELSE convert(varchar(10), tblCase.DateOfService_End,101)
					END
			) AS DateOfService_End
			,STATUS
			,Rebuttal_Status
			--,Ins_Claim_Number
			, REPLACE(Ins_Claim_Number, char(9), '')  Ins_Claim_Number
			--,Policy_Number
			, REPLACE(Policy_Number, char(9), '')  Policy_Number
			,
			--convert(varchar, Date_BillSent, 101) as Date_BillSent,        
			(CASE	WHEN tblCase.Date_BillSent IS NULL OR tblCase.Date_BillSent = '' THEN ''
					ELSE convert(varchar(10), tblCase.Date_BillSent,101)
					END
			) AS Date_BillSent
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Claim_Amount)))) AS Claim_Amount
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Paid_Amount)))) AS Paid_Amount
			,(
				SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(transactions_amount)))))
				FROM tblTransactions(NOLOCK)
				WHERE tblTransactions.case_id = tblcase.Case_Id
					AND DomainId = @DomainId
					AND Transactions_Type IN (
						'PreC'
						,'PreCToP'
						)
				) [Voluntary_Payment]
			,(
				SELECT convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, sum(transactions_amount)))))
				FROM tblTransactions(NOLOCK)
				WHERE tblTransactions.case_id = tblcase.Case_Id
					AND DomainId = @DomainId
					AND Transactions_Type IN (
						'C'
						,'I'
						)
				) [Collection_Payment]
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Claim_Amount) - convert(FLOAT, Paid_Amount) - ISNULL(WriteOff, 0)))) AS Claim_Balance
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Fee_Schedule)))) AS FS_Amount
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, Fee_Schedule) - convert(FLOAT, Paid_Amount) - ISNULL(WriteOff, 0)))) AS FS_Balance
			,(
				SELECT TOP 1 bill_number
				FROM tblTreatment(NOLOCK)
				WHERE ISNULL(bill_number, '') <> ''
					AND case_id = tblcase.case_id
					AND domainid = tblcase.DomainId
				) AS BillNumber
			,convert(VARCHAR, ISNULL(tblCase.Date_Opened, ''), 101) AS Date_Opened
			, REPLACE(IndexOrAAA_Number, char(9), '')  IndexOrAAA_Number
			,tblCase.Initial_Status
			,(
				SELECT TOP 1 a.Case_Id
				FROM tblCase a(NOLOCK)
				WHERE a.Provider_Id = tblcase.Provider_Id
					AND a.InjuredParty_LastName = tblcase.InjuredParty_LastName
					AND a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName
					AND a.Accident_Date = tblcase.Accident_Date
					AND a.Case_Id <> tblcase.case_id
				) AS Similar_To_Case_ID
			,AF.Name AttorneyFirmName
			,PF.Name PortfolioName
			,ISNULL(tblCase.case_code, '') AS Reference_CaseId
			,DenialReasons_Type AS DenialReasons
			,sta.forum
			,sta.Final_Status
			,p.PacketID
			,REPLACE(StatusDisposition, char(9), '')   StatusDisposition
			,DateDiff(dd, ISNULL(Date_Status_Changed, Date_Opened), GETDATE()) AS Status_Age
			,DateDiff(dd, Date_Opened, GETDATE()) AS Case_Age
			
			,(
				SELECT TOP 1 REPLACE(ChequeNo, char(9), '') 
				FROM tblTransactions(NOLOCK)
				WHERE ISNULL(ChequeNo, '') <> ''
					AND case_id = tblcase.case_id
					AND domainid = tblcase.DomainID
				) 
				AS ChequeNo,
				--AS 
			
				--'Check Number'
					Court.Court_Name,

					(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = tblcase.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = tblcase.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel,

		 convert(decimal(38,2),(select  ISNULL(sum(DISTINCT ISNULL(Settlement_AF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = tblcase.case_id)) as  [ATTORNEYFEE],    
          convert(decimal(38,2),(select ISNULL(sum(DISTINCT ISNULL(Settlement_FF,0.00)),0.00) FROM tblsettlements  (NOLOCK) WHERE Case_Id = tblcase.case_id)) as [FILINGFEE]

		FROM tblcase AS tblcase(NOLOCK)
		LEFT JOIN tblprovider AS tblprovider(NOLOCK) ON tblcase.provider_id = tblprovider.provider_id
		LEFT JOIN tblinsurancecompany AS tblinsurancecompany(NOLOCK) ON tblcase.insurancecompany_id = tblinsurancecompany.insurancecompany_id
		LEFT JOIN tbl_portfolio PF(NOLOCK) ON tblcase.PortfolioId = PF.id
		LEFT JOIN tbl_AttorneyFirm AF(NOLOCK) ON tblcase.AttorneyFirmId = AF.id
		LEFT JOIN dbo.tblStatus sta(NOLOCK) ON tblcase.STATUS = sta.Status_Type
			AND tblcase.DomainId = sta.DomainId
		LEFT JOIN tblPacket p(NOLOCK) ON tblcase.FK_Packet_ID = p.Packet_Auto_ID
		LEFT JOIN tblAttorney att(NOLOCK) ON tblcase.Attorney_Id = att.Attorney_Id
		LEFT JOIN tblAdjusters adj(NOLOCK) ON tblcase.Adjuster_Id = adj.Adjuster_Id
		LEFT OUTER JOIN dbo.Assigned_Attorney a_att(NOLOCK) ON tblcase.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
		LEFT JOIN tblCourt court(nolock) ON tblcase.Court_id=court.court_id
		LEFT JOIN tblDefendant d(NOLOCK) ON tblcase.Defendant_id = d.Defendant_Id
		WHERE tblcase.DomainId = @DomainId
			AND ISNULL(tblcase.IsDeleted, 0) = 0
			--AND tblCase.STATUS <> 'IN ARB OR LIT'
			AND (tblcase.domainid = 'DK' OR tblCase.STATUS <> 'IN ARB OR LIT')
			AND (
				@strCaseId = ''
				OR tblcase.Case_Id LIKE '%' + @strCaseId + '%'
				)
			AND (
				@Reference_CaseId = ''
				OR tblCase.case_code LIKE '%' + @Reference_CaseId + '%'
				)
			AND (
				STATUS = @Status
				OR @Status = ''
				OR @Status = '0'
				OR @Status = 'all'
				)
			AND (
				@s_a_Rebuttal_Status = ''
				OR Rebuttal_Status = @s_a_Rebuttal_Status
				)
			AND (
				@InjuredParty_LastName = ''
				OR InjuredParty_LastName LIKE '%' + @InjuredParty_LastName + '%'
				)
			AND (
				@InjuredParty_FirstName = ''
				OR InjuredParty_FirstName LIKE '%' + @InjuredParty_FirstName + '%'
				)
			AND (
				@InsuredParty_LastName = ''
				OR InsuredParty_LastName LIKE '%' + @InsuredParty_LastName + '%'
				)
			AND (
				@InsuredParty_FirstName = ''
				OR InsuredParty_FirstName LIKE '%' + @InsuredParty_FirstName + '%'
				)
			AND (
				(
					@CompanyType != 'funding'
					AND (
						@Attorney_FirstName = ''
						OR Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
						)
					AND (
						@Attorney_LastName = ''
						OR Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
						)
					)
				OR (
					@CompanyType = 'funding'
					AND (
						(
							SELECT Count(*)
							FROM tblAttorney_Case_Assignment(NOLOCK) ACA
							INNER JOIN tblAttorney_Master AM(NOLOCK) ON AM.Attorney_Id = ACA.Attorney_Id
							INNER JOIN tblAttorney_Type ATP ON AM.Attorney_Type_Id = ATP.Attorney_Type_ID
							WHERE ACA.Case_Id = tblcase.Case_Id
								AND ACA.DomainId = @DomainId
								AND LOWER(Attorney_Type) = 'plaintiff attorney'
								AND (
									@Attorney_FirstName = ''
									OR AM.Attorney_FirstName LIKE '%' + @Attorney_FirstName + '%'
									)
								AND (
									@Attorney_LastName = ''
									OR AM.Attorney_LastName LIKE '%' + @Attorney_LastName + '%'
									)
							) > 0
						OR (
							@Attorney_FirstName = ''
							AND @Attorney_LastName = ''
							)
						)
					)
				)
			AND (
				@Adjuster_FirstName = ''
				OR Adjuster_FirstName LIKE '%' + @Adjuster_FirstName + '%'
				)
			AND (
				@Adjuster_LastName = ''
				OR Adjuster_LastName LIKE '%' + @Adjuster_LastName + '%'
				)
			AND (
				@ProviderName = ''
				OR Provider_Name LIKE '%' + @ProviderName + '%'
				)
			AND (
				@InsuranceName = ''
				OR InsuranceCompany_Name LIKE '%' + @InsuranceName + '%'
				)
			AND (
				@Policy_Number = ''
				OR Policy_Number = @Policy_Number
				)
			AND (
				@Ins_Claim_Number = ''
				OR Replace(Ins_Claim_Number, '-', '') LIKE '%' + Replace(@Ins_Claim_Number, '-', '') + '%'
				)
			AND (
				@IndexOrAAA_Number = ''
				OR Replace(IndexOrAAA_Number, '-', '') LIKE '%' + Replace(@IndexOrAAA_Number, '-', '') + '%'
				)
			AND (
				@Provider_Id = 0
				OR tblcase.Provider_ID = @Provider_Id
				)
			AND (
				@InsuranceCompany_Id = 0
				OR tblcase.InsuranceCompany_Id = @InsuranceCompany_Id
				)
			AND (
				@AssignedValue = 0
				OR tblCase.UserId = @SZ_USER_ID
				)
			AND (
				@strBill_No = ''
				OR tblcase.Case_Id IN (
					SELECT Case_Id
					FROM tbltreatment
					WHERE BILL_NUMBER LIKE '%' + @strBill_No + '%'
					)
				)
			AND (
				@Provider_Group = ''
				OR tblprovider.Provider_GroupName = @Provider_Group
				)
			AND (
				@DenialReasons_Id = 0
				OR tblcase.case_id IN (
					SELECT DISTINCT case_id
					FROM tbltreatment(NOLOCK)
					WHERE DenialReason_Id = @DenialReasons_Id
						AND DomainId = @DomainId
						OR treatment_id IN (
							SELECT treatment_id
							FROM TXN_tblTreatment(NOLOCK)
							WHERE DenialReasons_id = @DenialReasons_Id
								AND DomainId = @DomainId
							)
					)
				)
			AND (
				@PortfolioId = 0
				OR tblcase.PortfolioId = @PortfolioId
				)
			AND (
				@AttorneyFirmId = 0
				OR tblcase.AttorneyFirmId = @AttorneyFirmId
				)
			AND (
				@InitialStatus = ''
				OR Initial_Status LIKE '%' + @InitialStatus + '%'
				)
			AND (
				@AccidentDate = ''
				OR convert(VARCHAR, Accident_Date, 101) LIKE '%' + @AccidentDate + '%'
				)
			AND (
					@s_a_FinalStatus = ''
					OR ISNULL(sta.Final_Status, '') = @s_a_FinalStatus OR 
					(ISNULL(sta.Final_Status, '') = (Case when @s_a_FinalStatus= 'OPEN AND CLOSED'   then  ('OPEN')   end)
					OR ISNULL(sta.Final_Status, '') = (Case when @s_a_FinalStatus= 'OPEN AND CLOSED' then  ('CLOSED') end))
					
					)
			AND (
				@s_a_Forum = ''
				OR ISNULL(sta.forum, '') = @s_a_Forum
				)
		    AND (@i_a_Court = '0' OR tblcase.Court_Id =@i_a_Court)

			AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR tblcase.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = tblcase.Case_Id and DomainId = @DomainId) > 0))


			AND (
				@s_a_PacketId = ''
				OR p.PacketID LIKE '%' + @s_a_PacketId + '%'
				)
			AND (
				@ChequeNo = ''
				OR tblcase.case_id IN (
					SELECT DISTINCT CASE_ID
					FROM tblTransactions(NOLOCK)
					WHERE DomainId = @DomainId
						AND Replace(ChequeNo, '-', '') LIKE '%' + Replace(@ChequeNo, '-', '') + '%'
					)
				)
		--ORDER BY Case_AutoId DESC
		ORDER BY
	   CASE WHEN @SortBy  = 'Case_Id' and  @SortOrder = 'Descending' THEN Case_AutoID END DESC,    
       CASE WHEN @SortBy  = 'Case_Age' and  @SortOrder = 'Descending' THEN DateDiff(dd, Date_Opened, GETDATE()) END DESC,    
       CASE WHEN @SortBy  = 'Status_Age' and  @SortOrder = 'Descending' THEN DateDiff(dd, ISNULL(Date_Status_Changed, Date_Opened), GETDATE()) END DESC,    
       CASE WHEN @SortBy  = 'InjuredParty_Name' and  @SortOrder = 'Descending' THEN (LTRIM(InjuredParty_LastName) + ',' + LTRIM(InjuredParty_FirstName)) END DESC,   
	   --CASE WHEN @SortBy  = 'InjuredParty_Name' and  @SortOrder = 'Descending' THEN InjuredParty_LastName END DESC,   
       CASE WHEN @SortBy  = 'Provider_Name' and  @SortOrder = 'Descending' THEN Provider_Name END DESC,    
    
	  CASE @SortBy WHEN 'Case_Id' then Case_AutoID  END,    
	  CASE @SortBy WHEN 'Case_Age' THEN DateDiff(dd, Date_Opened, GETDATE()) END,    
	  CASE @SortBy WHEN 'Status_Age' THEN DateDiff(dd, ISNULL(Date_Status_Changed, Date_Opened), GETDATE()) END,    
	  CASE @SortBy WHEN 'InjuredParty_Name' THEN (LTRIM(InjuredParty_LastName) + ',' + LTRIM(InjuredParty_FirstName)) END,  
	  --CASE @SortBy WHEN 'InjuredParty_Name' THEN InjuredParty_LastName   END, 
	  CASE @SortBy WHEN 'Provider_Name' THEN Provider_Name END  
	END
END
