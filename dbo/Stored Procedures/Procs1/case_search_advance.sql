
/*    ==Scripting Parameters==

    Changed by : Atul.J
	Description : added multiple index number
	Date: 05/21/2020
	Last Change By: Abhay W
*/
CREATE PROCEDURE [dbo].[case_search_advance] -- [case_search_advance]  @DomainID='amt',@s_a_MainDenialID='2'
(
	@DomainID						VARCHAR(50),
	@s_a_MultipleCase_ID			VARCHAR(MAX)	=	'',
	@s_a_ProviderSel				VARCHAR(MAX)	=	'',
	@s_a_InsuranceSel				VARCHAR(MAX)	=	'',
	@s_a_CurrentStatusGroupSel		VARCHAR(500)	=	'',
	@s_a_InitialStatusGroupSel		VARCHAR(500)	=	'',
	@s_a_Case_ID					VARCHAR(100)	=	'',
	@s_a_OldCaseId					VARCHAR(100)	=	'',
	@s_a_InjuredName				VARCHAR(100)	=	'',
	@s_a_InsuredName				VARCHAR(100)	=	'',
	@s_a_PolicyNo					VARCHAR(100)	=	'',
	@s_a_ClaimNo					VARCHAR(100)	=	'',
	@s_a_BillNumber					VARCHAR(500)	=	'',
	@s_a_IndexOrAAANo				VARCHAR(100)	=	'',
	@i_a_DenailReason				VARCHAR(1000)	=	'',
	@i_a_Court						VARCHAR(MAX)          ,
	@i_a_Defendant					INT				=	0,
	@i_a_ReviewingDoctor			INT				=	0,
	@s_a_ProviderGroup				VARCHAR(100)	=	'',
	@s_a_InsuranceGroup				VARCHAR(100)	=	'',
	@s_a_date_opened_from			VARCHAR(10)		=	'',
	@s_a_date_opened_To				VARCHAR(10)		=	'',
	@s_a_DOSFrom					VARCHAR(10)		=	'',
	@s_a_DOSTo						VARCHAR(10)		=	'',	 
	@s_a_date_status_changed_from	VARCHAR(10)		=	'',
	@s_a_date_status_changed_To		VARCHAR(10)		=	'',
	@s_a_FinalStatus				VARCHAR(10)		=	'',
	@s_a_Forum						VARCHAR(10)		=	'',
	@s_a_injuredfirstname			varchar(100)	=	'',
	@s_a_injuredlastname			varchar(100)	=	'',
	@s_a_insuredfirstname			varchar(100)	=	'',
	@s_a_insuredlastname			varchar(100)	=	'',
	@s_a_packetid					varchar(100)	=	'',
	@s_a_adjusterfirstname			varchar(100)	=	'',
	@s_a_adjusterlastname			varchar(100)	=	'',
	@s_a_accidentdate				varchar(10)		=	'',
	@s_a_accountno					varchar(100)	=	'',
	@s_a_checknumber				varchar(100)	=	'',
	@s_a_paymentdatefrom			varchar(10)		=	'',
	@s_a_paymentdateto				varchar(10)		=	'',
	@s_a_filledunfiled				varchar(20)		=	'',
	@s_a_specialityid				varchar(max)	=	'',
	@s_a_attorneyfirmid				varchar(max)	=	'',
	@s_a_rebuttalstatusid			varchar(max)	=	'',
	@s_a_casetypeid					varchar(max)	=	'',
	@s_a_locationid					varchar(max)	=	'',
	@s_file_type					varchar(100)	=	'',
	@s_a_PortfolioId				varchar(max)	=	'0',
	@SZ_USER_ID						int=0  ,
	@AssignedValue					int =0  ,
	@StartIndex						int,
	@EndIndex						int,
	@StatusStart					int,
	@StatusEnd						int,
	@TotalBalStart					decimal(19,2),
	@TotalBalEnd					decimal(19,2),
	@s_a_MainDenialID				VARCHAR(max)=null,
	@IsPacketed                     varchar(200)= NULL,
	@CaseSearch                     CaseSearch  readonly
)
AS
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	  
    SET NOCOUNT ON
	create table #temp(case_id varchar(50))
	if(@s_a_MainDenialID <>'' and @s_a_MainDenialID is not null)
	begin
			;WITH tmp(case_id, DataItem, MainDenialReasonsId) AS
			(
			SELECT 
				case_id,
        
				LEFT(MainDenialReasonsId, CHARINDEX(',', MainDenialReasonsId + ',') - 1),
				STUFF(MainDenialReasonsId, 1, CHARINDEX(',', MainDenialReasonsId + ','), '')
			FROM tblcase  with(NOLOCK) where MainDenialReasonsId is not null and tblcase.DomainId=@DomainID
			UNION all

			SELECT
				case_id,
        
				LEFT(MainDenialReasonsId, CHARINDEX(',', MainDenialReasonsId + ',') - 1),
				STUFF(MainDenialReasonsId, 1, CHARINDEX(',', MainDenialReasonsId + ','), '')
			FROM tmp
			WHERE
				MainDenialReasonsId > ''
			)

			insert #temp(case_id)
			SELECT distinct
			case_id   
   
			FROM tmp 
			where DataItem in (SELECT items FROM dbo.SplitStringInt(@s_a_MainDenialID,','))
			ORDER BY case_id
	end
	else
	begin
	insert #temp(case_id)
	select case_id FROM tblcase with(NOLOCK) where  DomainId = @DomainID
	end
	   
	    DECLARE @Case_Packet_Status table
	   ([DomainId] varchar(50),[Status] varchar(200), [Packet_Indicator] int)

	    INSERT INTO @Case_Packet_Status([DomainId], [Status],[Packet_Indicator])
		select [DomainId], [Status],[Packet_Indicator] from Case_Packet_Status with(nolock) where domainid=@DomainID

		DECLARE @CaseAmounts TABLE
		(
		[Case_Id] varchar(50) INDEX IX1 CLUSTERED,
		[DomainId] varchar(50) NULL,
		[Claim_Amount] float NULL,
		[Fee_Schedule] float NULL,
		[Paid_Amount] float NULL,
		[WriteOff] float NULL,
		--HelperIX int IDENTITY (1,1),
		UNIQUE (DomainId, Claim_Amount, Paid_Amount, Fee_Schedule, WriteOff, Case_Id)
		)

		INSERT INTO @CaseAmounts(Case_ID,DomainId,Claim_Amount,  Paid_Amount,Fee_Schedule,WriteOff)
		SELECT CASE_ID, DomainId,convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Claim_Amount,0.00))))) ,
		convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.Paid_Amount,0.00))))) ,
		convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))),
		convert(decimal(38,2),(convert(money,convert(float,ISNULL(cas.WriteOFF,0.00)))))  
		FROM TBLCASE cas with(NOLOCK)  WHERE DomainId = @DomainID 
		
		DECLARE @CaseDates TABLE
		(
		  [Case_Id] varchar(50) INDEX IX1 CLUSTERED,
		  [Accident_Date] datetime NULL,
		  [Date_AAA_Arb_Filed] datetime NULL,
		  [Date_BillSent] datetime NULL,
		  [Date_Opened] datetime NULL,
		  [Date_Status_Changed] datetime NULL,
		  [DateOfService_End] datetime NULL,
		  [DateOfService_Start] datetime NULL
		  UNIQUE(Accident_Date, Date_AAA_Arb_Filed, Date_BillSent, Date_Opened, Date_Status_Changed,DateOfService_End, DateOfService_Start,Case_Id)
		)

		INSERT INTO @CaseDates(Case_ID,Accident_Date,Date_AAA_Arb_Filed, Date_BillSent, Date_Opened,Date_Status_Changed, DateOfService_End, DateOfService_Start)
		SELECT Case_ID,Accident_Date,Date_AAA_Arb_Filed, Date_BillSent, Date_Opened,Date_Status_Changed, DateOfService_End, DateOfService_Start
		FROM TBLCASE cas with(NOLOCK)  WHERE DomainId = @DomainID   AND ISNULL(cas.IsDeleted, 0) = 0  

		DECLARE @CaseData TABLE
		(
		    [Case_Id] varchar(50) INDEX IX1 CLUSTERED,
			[Adjuster_Id] int NULL,
			[Assigned_Attorney] int NULL,
			[Attorney_Id] varchar(50) NULL,
			[AttorneyFirmId] int NULL,
			[batchcode] varchar(100) NULL,
			[Case_AutoId] int,
			[Case_Code] varchar(100) NULL,
			[Court_Id] int NULL,
			[Defendant_Id] varchar(50) NULL,
			[DenialReasons_Type] varchar(2000) NULL,
			[DomainId] varchar(50) NULL,
			[FK_Packet_ID] int NULL,
			[IndexOrAAA_Number] varchar(40) NULL,
			[Initial_Status] varchar(50) NULL,
			[InjuredParty_FirstName] varchar(100) NULL,
			[InjuredParty_LastName] varchar(100) NULL,
			[Ins_Claim_Number] nvarchar(100) NULL,
			[InsuranceCompany_Id] int NULL,
			[InsuredParty_FirstName] varchar(100) NULL,
			[InsuredParty_LastName] varchar(100) NULL,
			[location_id] int NULL,
			[OPENED_BY] varchar(50) NULL,
			[Policy_Number] varchar(40) NULL,
			[PortfolioId] int NULL,
			[Provider_Id] int NULL,
			[Rebuttal_Status] varchar(200) NULL,
			[Status] varchar(50) NULL,
			[StatusDisposition] varchar(1000) NULL,
			[userId] nvarchar(200) NULL,
			[DefAttorneyFileNo] varchar(100) NULL,
			[Old_Status] varchar(100) NULL

			
				)

        INSERT INTO @CaseData(  Case_Id,
								Adjuster_Id,
								Assigned_Attorney,
								Attorney_Id,
								AttorneyFirmId,
								batchcode,
								Case_AutoId,
								Case_Code,
								Court_Id,
								Defendant_Id,
								DenialReasons_Type,
								DomainId,
								FK_Packet_ID,
								IndexOrAAA_Number,
								Initial_Status,
								InjuredParty_FirstName,
								InjuredParty_LastName,
								Ins_Claim_Number,
								InsuranceCompany_Id,
								InsuredParty_FirstName,
								InsuredParty_LastName,
								location_id,
								OPENED_BY,
								Policy_Number,
								PortfolioId,
								Provider_Id,
								Rebuttal_Status,
								Status,
								StatusDisposition,
								userId,
								DefAttorneyFileNo,
								Old_Status
																								)

								SELECT Case_Id,
								Adjuster_Id,
								Assigned_Attorney,
								Attorney_Id,
								AttorneyFirmId,
								batchcode,
								Case_AutoId,
								Case_Code,
								Court_Id,
								Defendant_Id,
								DenialReasons_Type,
								DomainId,
								FK_Packet_ID,
								IndexOrAAA_Number,
								Initial_Status,
								InjuredParty_FirstName,
								InjuredParty_LastName,
								Ins_Claim_Number,
								InsuranceCompany_Id,
								InsuredParty_FirstName,
								InsuredParty_LastName,
								location_id,
								OPENED_BY,
								Policy_Number,
								PortfolioId,
								Provider_Id,
								Rebuttal_Status,
								Status,
								StatusDisposition,
								userId,
								Attorney_FileNumber,
								Old_Status
								FROM TBLCASE with(NOLOCK) WHERE DomainId=@DomainID


								DECLARE @Settlements TABLE
								(   
								    [Case_Id] nvarchar(100),
									[DomainId] varchar(40),
									[Settlement_Af] money NULL,
									[Settlement_Amount] money NULL,
									[Settlement_Ff] money NULL,
									[Settlement_Int] money NULL,
									[Settlement_Total] money NULL
									
								)

								INSERT INTO @Settlements(Case_Id,
											DomainId,
											Settlement_Af,
											Settlement_Amount,
											Settlement_Ff,
											Settlement_Int,
											Settlement_Total
											) 
											SELECT Case_Id,
											DomainId,
											SUM(ISNULL(Settlement_Af,0.00)),
											SUM(ISNULL(Settlement_Amount,0.00)),
											SUM(ISNULL(Settlement_Ff,0.00)),
											SUM(ISNULL(Settlement_Int,0.00)),
											SUM(ISNULL(Settlement_Total,0.00))
											FROM tblSettlements WITH(NOLOCK)
											GROUP BY Case_Id,DomainId
											
 

	DECLARE @InvestorId AS INT = 0 
	SELECT @InvestorId=InvestorId FROM Tbl_Investor with(NOLOCK)  WHERE UserId = @SZ_USER_ID 
 	
	Declare @CompanyType varchar(150)=''
	Select TOP 1 @CompanyType =  LOWER(LTRIM(RTRIM(CompanyType))) from tbl_Client(NOLOCK) Where DomainId=@DomainID
	IF(@StartIndex > 0 AND	@EndIndex >  0)
	BEGIN

	if @IsPacketed is NOT NULL AND @DomainID='BT'
	BEGIN

	SELECT	* 
	FROM	(
		SELECT distinct 
		TotalRowCount = COUNT(1) OVER(),
		
		ROW_NUMBER() OVER (ORDER BY Case_AutoId DESC) AS ROWID,
		cas.Case_AutoId,
		cas.Case_Id,		
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.IndexOrAAA_Number,  
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount)))) as Claim_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Paid_Amount)))) as Paid_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as Claim_Balance,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule)))) as Fee_Schedule,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as FS_Balance, 
		cas.Status,  
		(CASE	WHEN casDate.Date_Status_Changed IS NULL OR casDate.Date_Status_Changed = '' THEN ''
				ELSE convert(varchar(10),casDate.Date_Status_Changed,101)
				END
		) AS Date_Status_Changed,
		--CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,casDate.Date_Status_Changed,GETDATE()))) as Status_Age,
		cas.Initial_Status,
		cas.Ins_Claim_Number, 
		(CASE	WHEN Accident_Date IS NULL OR Accident_Date = '' THEN ''
				ELSE convert(varchar(10),Accident_Date,101)
				END
		) AS Accident_Date,
		(CASE	WHEN casDate.DateOfService_Start IS NULL OR casDate.DateOfService_Start = '' THEN ''
				ELSE convert(varchar(10),casDate.DateOfService_Start,101)
				END
		) AS DateOfService_Start,
		(CASE	WHEN casDate.DateOfService_End IS NULL OR casDate.DateOfService_End = '' THEN ''
				ELSE convert(varchar(10),casDate.DateOfService_End,101)
				END
		) AS DateOfService_End,
		cas.DenialReasons_Type as DenialReasons,
		dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
		pro.Provider_GroupName,
		ins.InsuranceCompany_GroupName,
		sta.Final_Status,
		sta.forum,
		cas.StatusDisposition,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Amount) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Amount,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total, 
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Int) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Int,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_AF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_AF,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_FF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_FF,
		convert(decimal(38,2), settlements.Settlement_Amount) as Settlement_Amount,
		convert(decimal(38,2), settlements.Settlement_Total)  as Settlement_Total, 
		convert(decimal(38,2),  settlements.Settlement_Int)  as Settlement_Int,
		convert(decimal(38,2), settlements.Settlement_AF) as Settlement_AF,
		convert(decimal(38,2), settlements.Settlement_FF) as Settlement_FF,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay') as Delay_Notes,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay Arb') as Delay_ARB_NOTES,
		PacketID=p.PacketID,
		Rebuttal_Status,
		Policy_Number,
		Voluntary_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK)  where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')),
		Collection_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK) where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),
		bill_number=(select top 1 bill_number from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId),
		Date_Opened=convert(varchar, ISNULL(casDate.Date_Opened,''),101),
		Similar_To_Case_ID=(Select top 1 a.Case_Id FROM  tblCase a (NOLOCK) WHERE a.Provider_Id =cas.Provider_Id  and a.InjuredParty_LastName =cas.InjuredParty_LastName    
																			and a.InjuredParty_FirstName = cas.InjuredParty_FirstName and  a.Accident_Date =casDate.Accident_Date     
																			and a.Case_Id <> cas.case_id),
		Attorney_Name= Case @CompanyType 
					   When 'funding' THEN
		               (SUBSTRING(ISNULL(STUFF((
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId 
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId
							for xml path('')
						),1,0,''),',')))-1))
					   ELSE
		               (SELECT ISNULL(Attorney_LastName,'') +', '+ISNULL(Attorney_FirstName,'') FROM tblAttorney att WHERE att.Attorney_AutoId=cas.Attorney_Id)
					   END,
					  
		Reference_CaseId=ISNULL(cas.case_code,''),
		Settlement_Date= (CASE	WHEN sett.Settlement_Date IS NULL OR sett.Settlement_Date = '' THEN ''
				ELSE convert(varchar(10), max(DISTINCT sett.Settlement_Date),101)
				END
		) ,
		Event_Date= (SELECT convert(varchar(10), max(E.Event_Date),101) 
					FROM	tblEvent E
					WHERE	E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
					) ,
		Assigned_Attorney=cas.Assigned_Attorney,
		cas.Opened_By,
		Doctor_Name=(SELECT dbo.[fncGetPeerReviewDoctor](@domainId, cas.case_id)),
		PF.Name PortfolioName ,
		(CASE WHEN Date_AAA_Arb_Filed IS NULL OR Date_AAA_Arb_Filed = '' THEN ''
				ELSE convert(varchar(10), Date_AAA_Arb_Filed,101)
				END
		) AS Date_AAA_Arb_Filed,
		(ISNULL(adj.Adjuster_FirstName,'') + ' ' + ISNULL(adj.Adjuster_LastName,'')) AS  Adjuster_Name,
		ISNULL(adj.Adjuster_Email,'') AS Adjuster_Email,
		d.Defendant_Name,
		(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel,
		(Select TOP 1 ISNULL(Attorney_Email,'') FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
		inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
		Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId) AS OC_Email,
    Date_BillSent=(CASE WHEN casDate.Date_BillSent IS NULL OR casDate.Date_BillSent = '' THEN ''
					ELSE convert(varchar(10), casDate.Date_BillSent,101)
					END
					),
	tblSettlement_Type.Settlement_Type,
	(CASE WHEN Casdet.Scheduling_Order_Issue_Date IS NULL OR Casdet.Scheduling_Order_Issue_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Scheduling_Order_Issue_Date,101)
			END
	) AS Scheduling_Order_Issue_Date,
	(CASE WHEN Casdet.Facilitation_Summary_Due_Date IS NULL OR Casdet.Facilitation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10), Casdet.Facilitation_Summary_Due_Date,101)
			END
	) AS Facilitation_Summary_Due_Date,
	(CASE WHEN Casdet.Case_Evaluation_Summary_Due_Date IS NULL OR Casdet.Case_Evaluation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Summary_Due_Date,101)
			END
	) AS Case_Evaluation_Summary_Due_Date,
	(CASE WHEN Casdet.Date_Filed IS NULL OR Casdet.Date_Filed = '' THEN ''
			ELSE convert(varchar(10),Casdet.Date_Filed,101)
			END
	) AS Date_Filed,
	(CASE WHEN Casdet.Pretrial_Conf_Date IS NULL OR Casdet.Pretrial_Conf_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Pretrial_Conf_Date,101)
			END
	) AS Pretrial_Conf_Date,
	(CASE WHEN Casdet.Plaintiff_Discovery_Responses_Completed_Date IS NULL OR Casdet.Plaintiff_Discovery_Responses_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Plaintiff_Discovery_Responses_Completed_Date,101)
			END
	) AS Plaintiff_Discovery_Responses_Completed_Date,
	(CASE WHEN Casdet.Defense_Answers_to_our_Discovery_Completed_Date IS NULL OR Casdet.Defense_Answers_to_our_Discovery_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Answers_to_our_Discovery_Completed_Date,101)
			END
	) AS Defense_Answers_to_our_Discovery_Completed_Date,
	(CASE WHEN Casdet.Case_Evaluation_Date IS NULL OR Casdet.Case_Evaluation_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Date,101)
			END
	) AS Case_Evaluation_Date,
	(CASE WHEN Casdet.Discovery_Stip_Sent_Date IS NULL OR Casdet.Discovery_Stip_Sent_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Discovery_Stip_Sent_Date,101)
			END
	) AS Discovery_Stip_Sent_Date,
	(CASE WHEN Casdet.Defense_Discovery_Receipt_Date IS NULL OR Casdet.Defense_Discovery_Receipt_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Discovery_Receipt_Date,101)
			END
	) AS Defense_Discovery_Receipt_Date,
	court.Court_Name,
	cas.batchCode,
	DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) AS Status_Age,
	SUM(ISNULL(tre.Claim_Amount,0.00)) - SUM(ISNULL(tre.Paid_Amount,0.00)) - SUM(ISNULL(tre.WriteOff,0.00)) As Total_Balance,
	DefAttorneyFileNo,
	Old_Status AS Old_Status,
	(SELECT TOP 1 USER_ID FROM TBLNOTES WHERE CASE_ID = cas.CASE_ID AND NOTES_DESC LIKE 'STATUS CHANGED FROM%' ORDER BY NOTES_DATE DESC) [WHO_CHANGE_TO_THE_CURRENT_STATUS]
	FROM
		@CaseData cas 
		INNER JOIN @CaseAmounts casAmt ON cas.Case_Id = casAmt.Case_Id
		INNER JOIN @CaseDates casDate ON cas.Case_Id = casDate.Case_Id
		join #temp tmp on cas.Case_Id=tmp.case_id
		INNER JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id 
		INNER JOIN tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT JOIN dbo.tblStatus sta (NOLOCK) on cas.Status=sta.Status_Type AND cas.DomainId= sta.DomainId
		LEFT OUTER JOIN tblTreatment (NOLOCK) tre on tre.Case_Id= cas.Case_Id
		LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR (NOLOCK) prdoc on prdoc.TREATMENT_ID = tre.treatment_id
		LEFT OUTER JOIN TXN_tblTreatment t_tre (NOLOCK) on t_tre.Treatment_Id = tre.treatment_id
		LEFT JOIN tblPacket p (NOLOCK) on cas.FK_Packet_ID = p.Packet_Auto_ID
		LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id
		LEFT JOIN tblSettlement_Type WITH (NOLOCK) on sett.Settled_Type = tblSettlement_Type.SettlementType_Id
		LEFT JOIN tblAdjusters adj WITH (NOLOCK) ON adj.Adjuster_Id = cas.Adjuster_Id AND cas.DomainId= adj.DomainId
		LEFT JOIN tblTransactions T WITH (NOLOCK) ON T.Case_Id = cas.Case_Id AND T.DomainId = cas.DomainId
		LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ  WITH (NOLOCK) ON p.FK_CaseType_Id = pkt_typ.PK_CaseType_Id 
		--LEFT OUTER JOIN tblEvent E  WITH (NOLOCK) ON E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
		LEFT OUTER JOIN tbl_portfolio PF (NOLOCK)on cas.PortfolioId=PF.id  
		LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id
		LEFT JOIN tblCase_Date_Details Casdet(NOLOCK) ON cas.Case_Id=casdet.case_id
		LEFT JOIN tblCourt court(nolock) ON cas.Court_id=court.court_id
		LEFT OUTER JOIN @Settlements settlements    ON cas.DomainId= settlements.Domainid and cas.Case_Id = settlements.Case_Id
		INNER JOIN @Case_Packet_Status CPS ON cas.DomainId = CPS.DomainId and cas.Status = CPS.Status 
	WHERE
		cas.DomainId = @DomainID
		AND	(@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT CaseId FROM @CaseSearch) or  cas.IndexOrAAA_Number IN (SELECT CaseId FROM @CaseSearch))
		--(SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')))
		AND (@s_a_ProviderSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderSel,',')))
		AND (@s_a_InsuranceSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceSel,',')))	
		AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))	
		AND (@s_a_InitialStatusGroupSel ='' OR cas.Initial_Status IN (SELECT s FROM dbo.SplitString(@s_a_InitialStatusGroupSel,',')))
		--AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
		AND (@s_a_BillNumber ='' OR tre.BILL_NUMBER like '%'+ @s_a_BillNumber + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')

		AND (@s_a_ProviderGroup ='' OR pro.Provider_GroupName = @s_a_ProviderGroup )
		AND (@s_a_InsuranceGroup='' OR ins.InsuranceCompany_GroupName = @s_a_InsuranceGroup )		
		AND (@i_a_DenailReason = '' OR t_tre.DenialReasons_Id IN (SELECT s FROM dbo.SplitString(@i_a_DenailReason,',')))
		AND (@i_a_Court = '' OR cas.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@i_a_Court,',')))

		AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR cas.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = cas.Case_Id and DomainId = @DomainId) > 0))

		AND (@i_a_ReviewingDoctor = 0 OR tre.PeerReviewDoctor_ID = @i_a_ReviewingDoctor)
		AND (@s_a_date_opened_from='' OR (Date_Opened Between convert(datetime,@s_a_date_opened_from) And convert(datetime,@s_a_date_Opened_To)+1))
		AND (@s_a_DOSFrom ='' or (CONVERT(DATETIME,casDate.DateOfService_Start) >=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSFrom,101))  and casDate.DateOfService_Start IS NOT NULL))
		AND (@s_a_DOSTo ='' or (CONVERT(DATETIME,casDate.DateOfService_End) <=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSTo,101))  and casDate.DateOfService_End IS NOT NULL))
		AND (@s_a_date_status_changed_from = '' OR (Date_Status_Changed Between convert(datetime,@s_a_date_status_changed_from) And convert(datetime,@s_a_date_opened_To)+1))
		AND (@s_a_FinalStatus  ='' OR  ISNULL (sta.Final_Status,'')= @s_a_FinalStatus )
		AND (@s_a_Forum  ='' OR ISNULL (sta.forum,'')= @s_a_Forum )

		AND (@s_a_injuredfirstname = '' OR cas.InjuredParty_FirstName like '%'+ @s_a_injuredfirstname + '%')
		AND (@s_a_injuredlastname = '' OR cas.InjuredParty_LastName like '%'+ @s_a_injuredlastname + '%')
		AND (@s_a_insuredfirstname = '' OR cas.InsuredParty_FirstName like '%'+ @s_a_insuredfirstname + '%')
		AND (@s_a_insuredlastname = '' OR cas.InsuredParty_LastName like '%'+ @s_a_insuredlastname + '%')
		AND (@s_a_PacketId= '' OR p.PacketID LIKE '%' + @s_a_PacketId + '%')  			
		AND (@s_a_adjusterfirstname = '' OR adj.Adjuster_FirstName like '%'+ @s_a_adjusterfirstname + '%')
		AND (@s_a_adjusterlastname = '' OR adj.Adjuster_LastName like '%'+ @s_a_adjusterlastname + '%')
		AND (@s_a_accidentdate = '' OR CONVERT(VARCHAR,Accident_Date,101) = @s_a_AccidentDate)
		AND (@s_a_accountno = '' OR tre.account_number like '%' + @s_a_AccountNo +'%' OR tre.bill_number like '%' + @s_a_AccountNo +'%')  
		AND (@s_a_checknumber = '' OR cas.case_id IN (SELECT DISTINCT CASE_ID FROM tblTransactions (NOLOCK) WHERE DomainId = @DomainId and REPLACE(ChequeNo,'-','') LIKE '%' + REPLACE(@s_a_checknumber,'-','') + '%'))  
		AND (@s_a_paymentdatefrom = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) >= @s_a_paymentdatefrom)
		AND (@s_a_paymentdateto = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) <= @s_a_paymentdateto)
		AND (@s_a_filledunfiled = '' OR sta.Filed_Unfiled IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_filledunfiled,','))) 
		AND (@s_a_specialityid = '' OR tre.SERVICE_TYPE IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_specialityid,',')))
		AND (@s_a_attorneyfirmid = '0' OR cas.AttorneyFirmId = CAST(@s_a_attorneyfirmid AS INT)) 
		AND (@s_a_rebuttalstatusid = '' OR Rebuttal_Status = @s_a_rebuttalstatusid)  
		AND (@s_a_casetypeid = 0 OR pkt_typ.PK_CaseType_Id = CAST(@s_a_casetypeid AS INT))
		AND (@s_a_locationid = 0 OR cas.location_id = CAST(@s_a_locationid AS INT))
		AND (@s_a_PortfolioId = '0' OR @s_a_PortfolioId = '' OR cas.PortfolioId  IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@s_a_PortfolioId,',')))   
		--AND (@s_a_PortfolioId=0 OR cas.PortfolioId= @s_a_PortfolioId)  
	    AND (@InvestorId = 0 OR cas.portfolioid in (Select portfolioid from tbl_InvestorPortfolio IP (NOLOCK) WHERE IP.InvestorId =@InvestorId)) 
		AND (@AssignedValue = 0 or cas.UserId = @SZ_USER_ID ) 
		AND	(DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) >= @StatusStart)
		AND	(@StatusEnd = 0 OR DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) <= @StatusEnd)
		AND (ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) >= @TotalBalStart)
		AND	(@TotalBalEnd = 0 OR ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) <= @TotalBalEnd)
		--AND (CPS.Packet_Indicator=@IsPacketed or @IsPacketed is NULL)
		AND (CPS.Packet_Indicator IN (SELECT items FROM dbo.STRING_SPLIT(@IsPacketed,',')) or @IsPacketed is NULL)
	GROUP BY    
	  cas.Case_Id,  
	  cas.Case_AutoId,  
	  cas.InjuredParty_FirstName,  
	  cas.InjuredParty_LastName,  
	  pro.Provider_Name,  
	  ins.InsuranceCompany_Name,  
	  cas.Indexoraaa_number,  
	  casAmt.Claim_Amount,  
	  cas.Status,  
	  pro.Provider_GroupName,  
	  casAmt.Paid_Amount,  
	  casAmt.WriteOff,
	  cas.Ins_Claim_Number,  
	  casDate.Date_Opened,  
	  casDate.Date_Status_Changed,
	  casAmt.Fee_Schedule,
	  cas.Initial_Status,
	  casDate.Accident_Date,
	  casDate.DateOfService_Start,
	  casDate.DateOfService_End,
	  cas.DenialReasons_Type,
	  ins.InsuranceCompany_GroupName,
	  sta.Final_Status,
	  sta.forum,
	  cas.StatusDisposition,
	  p.PacketID,
	  cas.Rebuttal_Status,
	  cas.Policy_Number,
	  cas.DomainId,
	  cas.Provider_Id,
	  cas.Attorney_Id,
	  cas.Case_Code,
	  cas.Assigned_Attorney,
	  cas.Opened_By,
	  --cas.PortfolioId
	  	casDate.Date_BillSent, 
	   PF.Name ,
	   casDate.Date_AAA_Arb_Filed,
	   adj.Adjuster_FirstName,
	   adj.Adjuster_LastName,
	   d.Defendant_Name,
	   adj.Adjuster_Email,
	   tblSettlement_Type.Settlement_Type,
	   	Casdet.Scheduling_Order_Issue_Date,
		casdet.Facilitation_Summary_Due_Date,
		casdet.Case_Evaluation_Summary_Due_Date,
		Casdet.Date_Filed,
		casdet.Pretrial_Conf_Date,
		casdet.Plaintiff_Discovery_Responses_Completed_Date,
		casdet.Defense_Answers_to_our_Discovery_Completed_Date,
		Casdet.Case_Evaluation_Date,
		casdet.Discovery_Stip_Sent_Date,
		casdet.Defense_Discovery_Receipt_Date,
	    court.Court_Name,
		cas.batchCode,
		--tre.Claim_Amount,
		--tre.Paid_Amount,
		--tre.WriteOff,
		sett.Settlement_Date,
		Settlements.Settlement_Amount,
		Settlements.Settlement_Total,
		Settlements.Settlement_Int,
		Settlements.Settlement_Af,
		Settlements.Settlement_Ff,
		casDate.Date_BillSent--,
		,cas.DefAttorneyFileNo,
		cas.Old_Status
		--Event_Date
		) tbl
		WHERE tbl.ROWID >= @StartIndex AND tbl.ROWID <= @EndIndex

		END
	ELSE
	BEGIN
		SELECT	* 
	FROM	(
		SELECT distinct 
		TotalRowCount = COUNT(1) OVER(),
		
		ROW_NUMBER() OVER (ORDER BY Case_AutoId DESC) AS ROWID,
		cas.Case_AutoId,
		cas.Case_Id,		
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.IndexOrAAA_Number,  
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount)))) as Claim_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Paid_Amount)))) as Paid_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as Claim_Balance,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule)))) as Fee_Schedule,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as FS_Balance, 
		cas.Status,  
		(CASE	WHEN casDate.Date_Status_Changed IS NULL OR casDate.Date_Status_Changed = '' THEN ''
				ELSE convert(varchar(10),casDate.Date_Status_Changed,101)
				END
		) AS Date_Status_Changed,
		--CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,casDate.Date_Status_Changed,GETDATE()))) as Status_Age,
		cas.Initial_Status,
		cas.Ins_Claim_Number, 
		(CASE	WHEN Accident_Date IS NULL OR Accident_Date = '' THEN ''
				ELSE convert(varchar(10),Accident_Date,101)
				END
		) AS Accident_Date,
		(CASE	WHEN casDate.DateOfService_Start IS NULL OR casDate.DateOfService_Start = '' THEN ''
				ELSE convert(varchar(10),casDate.DateOfService_Start,101)
				END
		) AS DateOfService_Start,
		(CASE	WHEN casDate.DateOfService_End IS NULL OR casDate.DateOfService_End = '' THEN ''
				ELSE convert(varchar(10),casDate.DateOfService_End,101)
				END
		) AS DateOfService_End,
		cas.DenialReasons_Type as DenialReasons,
		dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
		pro.Provider_GroupName,
		ins.InsuranceCompany_GroupName,
		sta.Final_Status,
		sta.forum,
		cas.StatusDisposition,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Amount) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Amount,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total, 
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_Int) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Int,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_AF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_AF,
		--convert(decimal(38,2),(select sum(DISTINCT Settlement_FF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_FF,
		convert(decimal(38,2), settlements.Settlement_Amount) as Settlement_Amount,
		convert(decimal(38,2), settlements.Settlement_Total)  as Settlement_Total, 
		convert(decimal(38,2),  settlements.Settlement_Int)  as Settlement_Int,
		convert(decimal(38,2), settlements.Settlement_AF) as Settlement_AF,
		convert(decimal(38,2), settlements.Settlement_FF) as Settlement_FF,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay') as Delay_Notes,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay Arb') as Delay_ARB_NOTES,
		PacketID=p.PacketID,
		Rebuttal_Status,
		Policy_Number,
		Voluntary_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK)  where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')),
		Collection_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK) where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),
		bill_number=(select top 1 bill_number from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId),
		Date_Opened=convert(varchar, ISNULL(casDate.Date_Opened,''),101),
		Similar_To_Case_ID=(Select top 1 a.Case_Id FROM  tblCase a (NOLOCK) WHERE a.Provider_Id =cas.Provider_Id  and a.InjuredParty_LastName =cas.InjuredParty_LastName    
																			and a.InjuredParty_FirstName = cas.InjuredParty_FirstName and  a.Accident_Date =casDate.Accident_Date     
																			and a.Case_Id <> cas.case_id),
		Attorney_Name= Case @CompanyType 
					   When 'funding' THEN
		               (SUBSTRING(ISNULL(STUFF((
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId 
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId
							for xml path('')
						),1,0,''),',')))-1))
					   ELSE
		               (SELECT ISNULL(Attorney_LastName,'') +', '+ISNULL(Attorney_FirstName,'') FROM tblAttorney att WHERE att.Attorney_AutoId=cas.Attorney_Id)
					   END,
					  
		Reference_CaseId=ISNULL(cas.case_code,''),
		Settlement_Date= (CASE	WHEN sett.Settlement_Date IS NULL OR sett.Settlement_Date = '' THEN ''
				ELSE convert(varchar(10), max(DISTINCT sett.Settlement_Date),101)
				END
		) ,
		Event_Date= (SELECT convert(varchar(10), max(E.Event_Date),101) 
					FROM	tblEvent E
					WHERE	E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
					) ,
		Assigned_Attorney=cas.Assigned_Attorney,
		cas.Opened_By,
		Doctor_Name=(SELECT dbo.[fncGetPeerReviewDoctor](@domainId, cas.case_id)),
		PF.Name PortfolioName ,
		(CASE WHEN Date_AAA_Arb_Filed IS NULL OR Date_AAA_Arb_Filed = '' THEN ''
				ELSE convert(varchar(10), Date_AAA_Arb_Filed,101)
				END
		) AS Date_AAA_Arb_Filed,
		(ISNULL(adj.Adjuster_FirstName,'') + ' ' + ISNULL(adj.Adjuster_LastName,'')) AS  Adjuster_Name,
		ISNULL(adj.Adjuster_Email,'') AS Adjuster_Email,
		d.Defendant_Name,
		(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel,
		(Select TOP 1 ISNULL(Attorney_Email,'') FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
		inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
		Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId) AS OC_Email,
    Date_BillSent=(CASE WHEN casDate.Date_BillSent IS NULL OR casDate.Date_BillSent = '' THEN ''
					ELSE convert(varchar(10), casDate.Date_BillSent,101)
					END
					),
	tblSettlement_Type.Settlement_Type,
	(CASE WHEN Casdet.Scheduling_Order_Issue_Date IS NULL OR Casdet.Scheduling_Order_Issue_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Scheduling_Order_Issue_Date,101)
			END
	) AS Scheduling_Order_Issue_Date,
	(CASE WHEN Casdet.Facilitation_Summary_Due_Date IS NULL OR Casdet.Facilitation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10), Casdet.Facilitation_Summary_Due_Date,101)
			END
	) AS Facilitation_Summary_Due_Date,
	(CASE WHEN Casdet.Case_Evaluation_Summary_Due_Date IS NULL OR Casdet.Case_Evaluation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Summary_Due_Date,101)
			END
	) AS Case_Evaluation_Summary_Due_Date,
	(CASE WHEN Casdet.Date_Filed IS NULL OR Casdet.Date_Filed = '' THEN ''
			ELSE convert(varchar(10),Casdet.Date_Filed,101)
			END
	) AS Date_Filed,
	(CASE WHEN Casdet.Pretrial_Conf_Date IS NULL OR Casdet.Pretrial_Conf_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Pretrial_Conf_Date,101)
			END
	) AS Pretrial_Conf_Date,
	(CASE WHEN Casdet.Plaintiff_Discovery_Responses_Completed_Date IS NULL OR Casdet.Plaintiff_Discovery_Responses_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Plaintiff_Discovery_Responses_Completed_Date,101)
			END
	) AS Plaintiff_Discovery_Responses_Completed_Date,
	(CASE WHEN Casdet.Defense_Answers_to_our_Discovery_Completed_Date IS NULL OR Casdet.Defense_Answers_to_our_Discovery_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Answers_to_our_Discovery_Completed_Date,101)
			END
	) AS Defense_Answers_to_our_Discovery_Completed_Date,
	(CASE WHEN Casdet.Case_Evaluation_Date IS NULL OR Casdet.Case_Evaluation_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Date,101)
			END
	) AS Case_Evaluation_Date,
	(CASE WHEN Casdet.Discovery_Stip_Sent_Date IS NULL OR Casdet.Discovery_Stip_Sent_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Discovery_Stip_Sent_Date,101)
			END
	) AS Discovery_Stip_Sent_Date,
	(CASE WHEN Casdet.Defense_Discovery_Receipt_Date IS NULL OR Casdet.Defense_Discovery_Receipt_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Discovery_Receipt_Date,101)
			END
	) AS Defense_Discovery_Receipt_Date,
	court.Court_Name,
	cas.batchCode,
	DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) AS Status_Age,
	SUM(ISNULL(tre.Claim_Amount,0.00)) - SUM(ISNULL(tre.Paid_Amount,0.00)) - SUM(ISNULL(tre.WriteOff,0.00)) As Total_Balance,
	DefAttorneyFileNo,
	Old_Status AS Old_Status,
	(SELECT TOP 1 USER_ID FROM TBLNOTES WHERE CASE_ID = cas.CASE_ID AND NOTES_DESC LIKE 'STATUS CHANGED FROM%' ORDER BY NOTES_DATE DESC) [WHO_CHANGE_TO_THE_CURRENT_STATUS]
	FROM
		@CaseData cas 
		INNER JOIN @CaseAmounts casAmt ON cas.Case_Id = casAmt.Case_Id
		INNER JOIN @CaseDates casDate ON cas.Case_Id = casDate.Case_Id
		join #temp tmp on cas.Case_Id=tmp.case_id
		INNER JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id 
		INNER JOIN tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT JOIN dbo.tblStatus sta (NOLOCK) on cas.Status=sta.Status_Type AND cas.DomainId= sta.DomainId
		LEFT OUTER JOIN tblTreatment (NOLOCK) tre on tre.Case_Id= cas.Case_Id
		LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR (NOLOCK) prdoc on prdoc.TREATMENT_ID = tre.treatment_id
		LEFT OUTER JOIN TXN_tblTreatment t_tre (NOLOCK) on t_tre.Treatment_Id = tre.treatment_id
		LEFT JOIN tblPacket p (NOLOCK) on cas.FK_Packet_ID = p.Packet_Auto_ID
		LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id
		LEFT JOIN tblSettlement_Type WITH (NOLOCK) on sett.Settled_Type = tblSettlement_Type.SettlementType_Id
		LEFT JOIN tblAdjusters adj WITH (NOLOCK) ON adj.Adjuster_Id = cas.Adjuster_Id AND cas.DomainId= adj.DomainId
		LEFT JOIN tblTransactions T WITH (NOLOCK) ON T.Case_Id = cas.Case_Id AND T.DomainId = cas.DomainId
		LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ  WITH (NOLOCK) ON p.FK_CaseType_Id = pkt_typ.PK_CaseType_Id 
		--LEFT OUTER JOIN tblEvent E  WITH (NOLOCK) ON E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
		LEFT OUTER JOIN tbl_portfolio PF (NOLOCK)on cas.PortfolioId=PF.id  
		LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id
		LEFT JOIN tblCase_Date_Details Casdet(NOLOCK) ON cas.Case_Id=casdet.case_id
		LEFT JOIN tblCourt court(nolock) ON cas.Court_id=court.court_id
		LEFT OUTER JOIN @Settlements settlements    ON cas.DomainId= settlements.Domainid and cas.Case_Id = settlements.Case_Id
	WHERE
		cas.DomainId = @DomainID
		AND	(@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT CaseId FROM @CaseSearch) or  cas.IndexOrAAA_Number IN (SELECT CaseId FROM @CaseSearch))
		--(SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')))
		AND (@s_a_ProviderSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderSel,',')))
		AND (@s_a_InsuranceSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceSel,',')))	
		AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))	
		AND (@s_a_InitialStatusGroupSel ='' OR cas.Initial_Status IN (SELECT s FROM dbo.SplitString(@s_a_InitialStatusGroupSel,',')))
		--AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
		AND (@s_a_BillNumber ='' OR tre.BILL_NUMBER like '%'+ @s_a_BillNumber + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')

		AND (@s_a_ProviderGroup ='' OR pro.Provider_GroupName = @s_a_ProviderGroup )
		AND (@s_a_InsuranceGroup='' OR ins.InsuranceCompany_GroupName = @s_a_InsuranceGroup )		
		AND (@i_a_DenailReason = '' OR t_tre.DenialReasons_Id IN (SELECT s FROM dbo.SplitString(@i_a_DenailReason,',')))
		AND (@i_a_Court = '' OR cas.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@i_a_Court,',')))

		AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR cas.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = cas.Case_Id and DomainId = @DomainId) > 0))

		AND (@i_a_ReviewingDoctor = 0 OR tre.PeerReviewDoctor_ID = @i_a_ReviewingDoctor)
		AND (@s_a_date_opened_from='' OR (Date_Opened Between convert(datetime,@s_a_date_opened_from) And convert(datetime,@s_a_date_Opened_To)+1))
		AND (@s_a_DOSFrom ='' or (CONVERT(DATETIME,casDate.DateOfService_Start) >=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSFrom,101))  and casDate.DateOfService_Start IS NOT NULL))
		AND (@s_a_DOSTo ='' or (CONVERT(DATETIME,casDate.DateOfService_End) <=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSTo,101))  and casDate.DateOfService_End IS NOT NULL))
		AND (@s_a_date_status_changed_from = '' OR (Date_Status_Changed Between convert(datetime,@s_a_date_status_changed_from) And convert(datetime,@s_a_date_opened_To)+1))
		AND (@s_a_FinalStatus  ='' OR  ISNULL (sta.Final_Status,'')= @s_a_FinalStatus )
		AND (@s_a_Forum  ='' OR ISNULL (sta.forum,'')= @s_a_Forum )

		AND (@s_a_injuredfirstname = '' OR cas.InjuredParty_FirstName like '%'+ @s_a_injuredfirstname + '%')
		AND (@s_a_injuredlastname = '' OR cas.InjuredParty_LastName like '%'+ @s_a_injuredlastname + '%')
		AND (@s_a_insuredfirstname = '' OR cas.InsuredParty_FirstName like '%'+ @s_a_insuredfirstname + '%')
		AND (@s_a_insuredlastname = '' OR cas.InsuredParty_LastName like '%'+ @s_a_insuredlastname + '%')
		AND (@s_a_PacketId= '' OR p.PacketID LIKE '%' + @s_a_PacketId + '%')  			
		AND (@s_a_adjusterfirstname = '' OR adj.Adjuster_FirstName like '%'+ @s_a_adjusterfirstname + '%')
		AND (@s_a_adjusterlastname = '' OR adj.Adjuster_LastName like '%'+ @s_a_adjusterlastname + '%')
		AND (@s_a_accidentdate = '' OR CONVERT(VARCHAR,Accident_Date,101) = @s_a_AccidentDate)
		AND (@s_a_accountno = '' OR tre.account_number like '%' + @s_a_AccountNo +'%' OR tre.bill_number like '%' + @s_a_AccountNo +'%')  
		AND (@s_a_checknumber = '' OR cas.case_id IN (SELECT DISTINCT CASE_ID FROM tblTransactions (NOLOCK) WHERE DomainId = @DomainId and REPLACE(ChequeNo,'-','') LIKE '%' + REPLACE(@s_a_checknumber,'-','') + '%'))  
		AND (@s_a_paymentdatefrom = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) >= @s_a_paymentdatefrom)
		AND (@s_a_paymentdateto = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) <= @s_a_paymentdateto)
		AND (@s_a_filledunfiled = '' OR sta.Filed_Unfiled IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_filledunfiled,','))) 
		AND (@s_a_specialityid = '' OR tre.SERVICE_TYPE IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_specialityid,',')))
		AND (@s_a_attorneyfirmid = '0' OR cas.AttorneyFirmId = CAST(@s_a_attorneyfirmid AS INT)) 
		AND (@s_a_rebuttalstatusid = '' OR Rebuttal_Status = @s_a_rebuttalstatusid)  
		AND (@s_a_casetypeid = 0 OR pkt_typ.PK_CaseType_Id = CAST(@s_a_casetypeid AS INT))
		AND (@s_a_locationid = 0 OR cas.location_id = CAST(@s_a_locationid AS INT))
		AND (@s_a_PortfolioId = '0' OR @s_a_PortfolioId = '' OR cas.PortfolioId  IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@s_a_PortfolioId,',')))   
		--AND (@s_a_PortfolioId=0 OR cas.PortfolioId= @s_a_PortfolioId)  
	    AND (@InvestorId = 0 OR cas.portfolioid in (Select portfolioid from tbl_InvestorPortfolio IP (NOLOCK) WHERE IP.InvestorId =@InvestorId)) 
		AND (@AssignedValue = 0 or cas.UserId = @SZ_USER_ID ) 
		AND	(DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) >= @StatusStart)
		AND	(@StatusEnd = 0 OR DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) <= @StatusEnd)
		AND (ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) >= @TotalBalStart)
		AND	(@TotalBalEnd = 0 OR ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) <= @TotalBalEnd)
	GROUP BY    
	  cas.Case_Id,  
	  cas.Case_AutoId,  
	  cas.InjuredParty_FirstName,  
	  cas.InjuredParty_LastName,  
	  pro.Provider_Name,  
	  ins.InsuranceCompany_Name,  
	  cas.Indexoraaa_number,  
	  casAmt.Claim_Amount,  
	  cas.Status,  
	  pro.Provider_GroupName,  
	  casAmt.Paid_Amount,  
	  casAmt.WriteOff,
	  cas.Ins_Claim_Number,  
	  casDate.Date_Opened,  
	  casDate.Date_Status_Changed,
	  casAmt.Fee_Schedule,
	  cas.Initial_Status,
	  casDate.Accident_Date,
	  casDate.DateOfService_Start,
	  casDate.DateOfService_End,
	  cas.DenialReasons_Type,
	  ins.InsuranceCompany_GroupName,
	  sta.Final_Status,
	  sta.forum,
	  cas.StatusDisposition,
	  p.PacketID,
	  cas.Rebuttal_Status,
	  cas.Policy_Number,
	  cas.DomainId,
	  cas.Provider_Id,
	  cas.Attorney_Id,
	  cas.Case_Code,
	  cas.Assigned_Attorney,
	  cas.Opened_By,
	  --cas.PortfolioId
	  	casDate.Date_BillSent, 
	   PF.Name ,
	   casDate.Date_AAA_Arb_Filed,
	   adj.Adjuster_FirstName,
	   adj.Adjuster_LastName,
	   d.Defendant_Name,
	   adj.Adjuster_Email,
	   tblSettlement_Type.Settlement_Type,
	   	Casdet.Scheduling_Order_Issue_Date,
		casdet.Facilitation_Summary_Due_Date,
		casdet.Case_Evaluation_Summary_Due_Date,
		Casdet.Date_Filed,
		casdet.Pretrial_Conf_Date,
		casdet.Plaintiff_Discovery_Responses_Completed_Date,
		casdet.Defense_Answers_to_our_Discovery_Completed_Date,
		Casdet.Case_Evaluation_Date,
		casdet.Discovery_Stip_Sent_Date,
		casdet.Defense_Discovery_Receipt_Date,
	    court.Court_Name,
		cas.batchCode,
		--tre.Claim_Amount,
		--tre.Paid_Amount,
		--tre.WriteOff,
		sett.Settlement_Date,
		Settlements.Settlement_Amount,
		Settlements.Settlement_Total,
		Settlements.Settlement_Int,
		Settlements.Settlement_Af,
		Settlements.Settlement_Ff,
		casDate.Date_BillSent--,
		,cas.DefAttorneyFileNo,
		cas.Old_Status
		--Event_Date
		) tbl
		WHERE tbl.ROWID >= @StartIndex AND tbl.ROWID <= @EndIndex
	 END
		
	END
	ELSE

	if @IsPacketed is NOT NULL AND @DomainID='BT'
	BEGIN

	BEGIN
	SELECT distinct 
		TotalRowCount = COUNT(*) OVER(),
		cas.Case_AutoId,
		cas.Case_Id,		
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.IndexOrAAA_Number,  
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount)))) as Claim_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Paid_Amount)))) as Paid_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as Claim_Balance,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule)))) as Fee_Schedule,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as FS_Balance, 
		cas.Status,  
		(CASE	WHEN casDate.Date_Status_Changed IS NULL OR casDate.Date_Status_Changed = '' THEN ''
				ELSE convert(varchar(10),casDate.Date_Status_Changed,101)
				END
		) AS Date_Status_Changed,
		--CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,casDate.Date_Status_Changed,GETDATE()))) as Status_Age,
		cas.Initial_Status,
		cas.Ins_Claim_Number, 
		(CASE	WHEN Accident_Date IS NULL OR Accident_Date = '' THEN ''
				ELSE convert(varchar(10),Accident_Date,101)
				END
		) AS Accident_Date,
		(CASE	WHEN casDate.DateOfService_Start IS NULL OR casDate.DateOfService_Start = '' THEN ''
				ELSE convert(varchar(10),casDate.DateOfService_Start,101)
				END
		) AS DateOfService_Start,
		(CASE	WHEN casDate.DateOfService_End IS NULL OR casDate.DateOfService_End = '' THEN ''
				ELSE convert(varchar(10), casDate.DateOfService_End,101)
				END
		) AS DateOfService_End,
		cas.DenialReasons_Type as DenialReasons,
		dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
		pro.Provider_GroupName,
		ins.InsuranceCompany_GroupName,
		sta.Final_Status,
		sta.forum,
		cas.StatusDisposition,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_Amount) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Amount,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total, 
		convert(decimal(38,2),(select sum(DISTINCT Settlement_Int) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Int,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_AF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_AF,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_FF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_FF,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay') as Delay_Notes,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay Arb') as Delay_ARB_NOTES,
		PacketID=p.PacketID,
		Rebuttal_Status,
		Policy_Number,
		Voluntary_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK)  where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')),
		Collection_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK) where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),
		bill_number=(select top 1 bill_number from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId),
		Date_Opened=convert(varchar, ISNULL(casDate.Date_Opened,''),101),
		Similar_To_Case_ID=(Select top 1 a.Case_Id FROM  tblCase a (NOLOCK) WHERE a.Provider_Id =cas.Provider_Id  and a.InjuredParty_LastName =cas.InjuredParty_LastName    
																			and a.InjuredParty_FirstName = cas.InjuredParty_FirstName and  a.Accident_Date =casDate.Accident_Date     
																			and a.Case_Id <> cas.case_id),
		Attorney_Name= Case @CompanyType 
					   When 'funding' THEN
		               (SUBSTRING(ISNULL(STUFF((
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId 
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId
							for xml path('')
						),1,0,''),',')))-1))
					   ELSE
		               (SELECT ISNULL(Attorney_LastName,'') +', '+ISNULL(Attorney_FirstName,'') FROM tblAttorney att WHERE att.Attorney_AutoId=cas.Attorney_Id)
					   END,
					  
		Reference_CaseId=ISNULL(cas.case_code,''),
		Settlement_Date= (CASE	WHEN sett.Settlement_Date IS NULL OR sett.Settlement_Date = '' THEN ''
				ELSE convert(varchar(10), max(DISTINCT sett.Settlement_Date),101)
				END
		) ,
		Event_Date= (SELECT convert(varchar(10), max(E.Event_Date),101) 
					FROM	tblEvent E
					WHERE	E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
					) ,
		Assigned_Attorney=cas.Assigned_Attorney,
		cas.Opened_By,
		Doctor_Name=(SELECT dbo.[fncGetPeerReviewDoctor](@domainId, cas.case_id)),
		PF.Name PortfolioName ,
		(CASE WHEN Date_AAA_Arb_Filed IS NULL OR Date_AAA_Arb_Filed = '' THEN ''
				ELSE convert(varchar(10), Date_AAA_Arb_Filed,101)
				END
		) AS Date_AAA_Arb_Filed,
		(ISNULL(adj.Adjuster_FirstName,'') + ' ' + ISNULL(adj.Adjuster_LastName,'')) AS  Adjuster_Name,
		ISNULL(adj.Adjuster_Email,'') AS Adjuster_Email,
		d.Defendant_Name,
		(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel,
		(Select TOP 1 ISNULL(Attorney_Email,'') FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
		inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
		Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId) AS OC_Email,
    Date_BillSent=CASE WHEN casDate.Date_BillSent IS NULL OR casDate.Date_BillSent = '' THEN ''
					ELSE convert(varchar(10),casDate.Date_BillSent,101)
					END,
	tblSettlement_Type.Settlement_Type,
	(CASE WHEN Casdet.Scheduling_Order_Issue_Date IS NULL OR Casdet.Scheduling_Order_Issue_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Scheduling_Order_Issue_Date,101)
			END
	) AS Scheduling_Order_Issue_Date,
	(CASE WHEN Casdet.Facilitation_Summary_Due_Date IS NULL OR Casdet.Facilitation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10), Casdet.Facilitation_Summary_Due_Date,101)
			END
	) AS Facilitation_Summary_Due_Date,
	(CASE WHEN Casdet.Case_Evaluation_Summary_Due_Date IS NULL OR Casdet.Case_Evaluation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Summary_Due_Date,101)
			END
	) AS Case_Evaluation_Summary_Due_Date,
	(CASE WHEN Casdet.Date_Filed IS NULL OR Casdet.Date_Filed = '' THEN ''
			ELSE convert(varchar(10),Casdet.Date_Filed,101)
			END
	) AS Date_Filed,
	(CASE WHEN Casdet.Pretrial_Conf_Date IS NULL OR Casdet.Pretrial_Conf_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Pretrial_Conf_Date,101)
			END
	) AS Pretrial_Conf_Date,
	(CASE WHEN Casdet.Plaintiff_Discovery_Responses_Completed_Date IS NULL OR Casdet.Plaintiff_Discovery_Responses_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Plaintiff_Discovery_Responses_Completed_Date,101)
			END
	) AS Plaintiff_Discovery_Responses_Completed_Date,
	(CASE WHEN Casdet.Defense_Answers_to_our_Discovery_Completed_Date IS NULL OR Casdet.Defense_Answers_to_our_Discovery_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Answers_to_our_Discovery_Completed_Date,101)
			END
	) AS Defense_Answers_to_our_Discovery_Completed_Date,
	(CASE WHEN Casdet.Case_Evaluation_Date IS NULL OR Casdet.Case_Evaluation_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Date,101)
			END
	) AS Case_Evaluation_Date,
	(CASE WHEN Casdet.Discovery_Stip_Sent_Date IS NULL OR Casdet.Discovery_Stip_Sent_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Discovery_Stip_Sent_Date,101)
			END
	) AS Discovery_Stip_Sent_Date,
	(CASE WHEN Casdet.Defense_Discovery_Receipt_Date IS NULL OR Casdet.Defense_Discovery_Receipt_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Discovery_Receipt_Date,101)
			END
	) AS Defense_Discovery_Receipt_Date,
	court.Court_Name,
	cas.batchCode,
	DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) AS Status_Age,
	SUM(ISNULL(tre.Claim_Amount,0.00)) - SUM(ISNULL(tre.Paid_Amount,0.00)) - SUM(ISNULL(tre.WriteOff,0.00)) As Total_Balance,
	DefAttorneyFileNo,
	Old_Status AS Old_Status,
	(SELECT TOP 1 USER_ID FROM TBLNOTES WHERE CASE_ID = cas.CASE_ID AND NOTES_DESC LIKE 'STATUS CHANGED FROM%' ORDER BY NOTES_DATE DESC) [WHO_CHANGE_TO_THE_CURRENT_STATUS]
	FROM
		@CaseData cas 
		INNER JOIN @CaseAmounts casAmt ON cas.Case_Id = casAmt.Case_Id
	    INNER JOIN @CaseDates casDate ON cas.Case_Id = casDate.Case_Id
		join #temp tmp on cas.Case_Id=tmp.case_id
		INNER JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id 
		INNER JOIN tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT JOIN dbo.tblStatus sta (NOLOCK) on cas.Status=sta.Status_Type AND cas.DomainId= sta.DomainId
		LEFT OUTER JOIN tblTreatment (NOLOCK) tre on tre.Case_Id= cas.Case_Id
		LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR (NOLOCK) prdoc on prdoc.TREATMENT_ID = tre.treatment_id
		LEFT OUTER JOIN TXN_tblTreatment t_tre (NOLOCK) on t_tre.Treatment_Id = tre.treatment_id
		LEFT JOIN tblPacket p (NOLOCK) on cas.FK_Packet_ID = p.Packet_Auto_ID
		LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id
		LEFT JOIN tblSettlement_Type (NOLOCK) on sett.Settled_Type = tblSettlement_Type.SettlementType_Id
		LEFT JOIN tblAdjusters adj (NOLOCK) ON adj.Adjuster_Id = cas.Adjuster_Id AND cas.DomainId= adj.DomainId
		LEFT JOIN tblTransactions T (NOLOCK) ON T.Case_Id = cas.Case_Id AND T.DomainId = cas.DomainId
		LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ  WITH (NOLOCK) ON p.FK_CaseType_Id = pkt_typ.PK_CaseType_Id 
		--LEFT OUTER JOIN tblEvent E  WITH (NOLOCK) ON E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
		LEFT OUTER JOIN tbl_portfolio PF (NOLOCK)on cas.PortfolioId=PF.id  
		LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id
		LEFT JOIN tblCase_Date_Details Casdet(NOLOCK) ON cas.Case_Id=casdet.case_id
		LEFT JOIN tblCourt court(nolock) ON cas.Court_id=court.court_id
		INNER JOIN @Case_Packet_Status CPS ON cas.DomainId = CPS.DomainId and cas.Status = CPS.Status 
	WHERE
		cas.DomainId = @DomainID
		AND	(@s_a_MultipleCase_ID ='' OR --cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')))
		cas.Case_Id IN (SELECT CaseID FROM @CaseSearch) or  cas.IndexOrAAA_Number IN (SELECT CaseId FROM @CaseSearch) )
		AND (@s_a_ProviderSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderSel,',')))
		AND (@s_a_InsuranceSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceSel,',')))	
		AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))	
		AND (@s_a_InitialStatusGroupSel ='' OR cas.Initial_Status IN (SELECT s FROM dbo.SplitString(@s_a_InitialStatusGroupSel,',')))
		--AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
		AND (@s_a_BillNumber ='' OR tre.BILL_NUMBER like '%'+ @s_a_BillNumber + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')

		AND (@s_a_ProviderGroup ='' OR pro.Provider_GroupName = @s_a_ProviderGroup )
		AND (@s_a_InsuranceGroup='' OR ins.InsuranceCompany_GroupName = @s_a_InsuranceGroup )		
		AND (@i_a_DenailReason = '' OR t_tre.DenialReasons_Id IN (SELECT s FROM dbo.SplitString(@i_a_DenailReason,',')))
		AND (@i_a_Court = '' OR cas.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@i_a_Court,',')))

		AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR cas.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = cas.Case_Id and DomainId = @DomainId) > 0))

		AND (@i_a_ReviewingDoctor = 0 OR tre.PeerReviewDoctor_ID = @i_a_ReviewingDoctor)
		AND (@s_a_date_opened_from='' OR (Date_Opened Between convert(datetime,@s_a_date_opened_from) And convert(datetime,@s_a_date_Opened_To)+1))
		AND (@s_a_DOSFrom ='' or (CONVERT(DATETIME,casDate.DateOfService_Start) >=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSFrom,101))  and casDate.DateOfService_Start IS NOT NULL))
		AND (@s_a_DOSTo ='' or (CONVERT(DATETIME,casDate.DateOfService_End) <=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSTo,101))  and casDate.DateOfService_End IS NOT NULL))
		AND (@s_a_date_status_changed_from = '' OR (Date_Status_Changed Between convert(datetime,@s_a_date_status_changed_from) And convert(datetime,@s_a_date_opened_To)+1))
		AND (@s_a_FinalStatus  ='' OR  ISNULL (sta.Final_Status,'')= @s_a_FinalStatus )
		AND (@s_a_Forum  ='' OR ISNULL (sta.forum,'')= @s_a_Forum )

		AND (@s_a_injuredfirstname = '' OR cas.InjuredParty_FirstName like '%'+ @s_a_injuredfirstname + '%')
		AND (@s_a_injuredlastname = '' OR cas.InjuredParty_LastName like '%'+ @s_a_injuredlastname + '%')
		AND (@s_a_insuredfirstname = '' OR cas.InsuredParty_FirstName like '%'+ @s_a_insuredfirstname + '%')
		AND (@s_a_insuredlastname = '' OR cas.InsuredParty_LastName like '%'+ @s_a_insuredlastname + '%')
		AND (@s_a_PacketId= '' OR p.PacketID LIKE '%' + @s_a_PacketId + '%')  			
		AND (@s_a_adjusterfirstname = '' OR adj.Adjuster_FirstName like '%'+ @s_a_adjusterfirstname + '%')
		AND (@s_a_adjusterlastname = '' OR adj.Adjuster_LastName like '%'+ @s_a_adjusterlastname + '%')
		AND (@s_a_accidentdate = '' OR CONVERT(VARCHAR,Accident_Date,101) = @s_a_AccidentDate)
		AND (@s_a_accountno = '' OR tre.account_number like '%' + @s_a_AccountNo +'%' OR tre.bill_number like '%' + @s_a_AccountNo +'%')  
		AND (@s_a_checknumber = '' OR cas.case_id IN (SELECT DISTINCT CASE_ID FROM tblTransactions (NOLOCK) WHERE DomainId = @DomainId and REPLACE(ChequeNo,'-','') LIKE '%' + REPLACE(@s_a_checknumber,'-','') + '%'))  
		AND (@s_a_paymentdatefrom = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) >= @s_a_paymentdatefrom)
		AND (@s_a_paymentdateto = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) <= @s_a_paymentdateto)
		AND (@s_a_filledunfiled = '' OR sta.Filed_Unfiled IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_filledunfiled,','))) 
		AND (@s_a_specialityid = '' OR tre.SERVICE_TYPE IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_specialityid,',')))
		AND (@s_a_attorneyfirmid = '0' OR cas.AttorneyFirmId = CAST(@s_a_attorneyfirmid AS INT)) 
		AND (@s_a_rebuttalstatusid = '' OR Rebuttal_Status = @s_a_rebuttalstatusid)  
		AND (@s_a_casetypeid = 0 OR pkt_typ.PK_CaseType_Id = CAST(@s_a_casetypeid AS INT))
		AND (@s_a_locationid = 0 OR cas.location_id = CAST(@s_a_locationid AS INT))
		AND (@s_a_PortfolioId = '0' OR @s_a_PortfolioId = '' OR cas.PortfolioId  IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@s_a_PortfolioId,',')))  
		--AND (@s_a_PortfolioId=0 OR cas.PortfolioId= @s_a_PortfolioId)  
	    AND (@InvestorId = 0 OR cas.portfolioid in (Select portfolioid from tbl_InvestorPortfolio IP (NOLOCK) WHERE IP.InvestorId =@InvestorId)) 
		AND (@AssignedValue = 0 or cas.UserId = @SZ_USER_ID ) 
		AND	(DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) >= @StatusStart)
		AND	(@StatusEnd = 0 OR DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) <= @StatusEnd)
		AND (ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) >= @TotalBalStart)
		AND	(@TotalBalEnd = 0 OR ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) <= @TotalBalEnd)
		--AND (CPS.Packet_Indicator=@IsPacketed or @IsPacketed is NULL)
		AND (CPS.Packet_Indicator IN (SELECT items FROM dbo.STRING_SPLIT(@IsPacketed,',')) or @IsPacketed is NULL)
	GROUP BY    
	  cas.Case_Id,  
	  cas.Case_AutoId,  
	  cas.InjuredParty_FirstName,  
	  cas.InjuredParty_LastName,  
	  pro.Provider_Name,  
	  ins.InsuranceCompany_Name,  
	  cas.Indexoraaa_number,  
	  casAmt.Claim_Amount,  
	  cas.Status,  
	  pro.Provider_GroupName,  
	  casAmt.Paid_Amount,  
	  casAmt.WriteOff,
	  cas.Ins_Claim_Number,  
	  casDate.Date_Opened,  
	  casDate.Date_Status_Changed,
	  casAmt.Fee_Schedule,
	  cas.Initial_Status,
	  casDate.Accident_Date,
	  casDate.DateOfService_Start,
	  casDate.DateOfService_End,
	  cas.DenialReasons_Type,
	  ins.InsuranceCompany_GroupName,
	  sta.Final_Status,
	  sta.forum,
	  cas.StatusDisposition,
	  p.PacketID,
	  cas.Rebuttal_Status,
	  cas.Policy_Number,
	  cas.DomainId,
	  cas.Provider_Id,
	  cas.Attorney_Id,
	  cas.Case_Code,
	  cas.Assigned_Attorney,
	  cas.Opened_By,
	  --cas.PortfolioId
	  	casDate.Date_BillSent, 
	   PF.Name ,
	   casDate.Date_AAA_Arb_Filed,
	   adj.Adjuster_FirstName,
	   adj.Adjuster_LastName,
	   d.Defendant_Name,
	   adj.Adjuster_Email,
	   tblSettlement_Type.Settlement_Type,
	   Casdet.Scheduling_Order_Issue_Date,
	   casdet.Facilitation_Summary_Due_Date,
	   casdet.Case_Evaluation_Summary_Due_Date,
	   Casdet.Date_Filed,
		casdet.Pretrial_Conf_Date,
		casdet.Plaintiff_Discovery_Responses_Completed_Date,
		casdet.Defense_Answers_to_our_Discovery_Completed_Date,
		Casdet.Case_Evaluation_Date,
		casdet.Discovery_Stip_Sent_Date,
		casdet.Defense_Discovery_Receipt_Date,
	   court.Court_Name,
		cas.batchCode,
		--tre.Claim_Amount,
		--tre.Paid_Amount,
		--tre.WriteOff,
		sett.Settlement_Date,
		casDate.Date_BillSent--,
		--Event_Date
		,cas.DefAttorneyFileNo,
		cas.Old_Status
	ORDER BY 
		Case_AutoId	desc
		END
		END
		ELSE
		BEGIN
	SELECT distinct 
		TotalRowCount = COUNT(*) OVER(),
		cas.Case_AutoId,
		cas.Case_Id,		
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.IndexOrAAA_Number,  
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount)))) as Claim_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Paid_Amount)))) as Paid_Amount,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Claim_Amount) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as Claim_Balance,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule)))) as Fee_Schedule,
		convert(decimal(38,2),(convert(money,convert(float,casAmt.Fee_Schedule) - convert(float,casAmt.Paid_Amount) - ISNULL(casAmt.WriteOff,0)))) as FS_Balance, 
		cas.Status,  
		(CASE	WHEN casDate.Date_Status_Changed IS NULL OR casDate.Date_Status_Changed = '' THEN ''
				ELSE convert(varchar(10),casDate.Date_Status_Changed,101)
				END
		) AS Date_Status_Changed,
		--CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,casDate.Date_Status_Changed,GETDATE()))) as Status_Age,
		cas.Initial_Status,
		cas.Ins_Claim_Number, 
		(CASE	WHEN Accident_Date IS NULL OR Accident_Date = '' THEN ''
				ELSE convert(varchar(10),Accident_Date,101)
				END
		) AS Accident_Date,
		(CASE	WHEN casDate.DateOfService_Start IS NULL OR casDate.DateOfService_Start = '' THEN ''
				ELSE convert(varchar(10),casDate.DateOfService_Start,101)
				END
		) AS DateOfService_Start,
		(CASE	WHEN casDate.DateOfService_End IS NULL OR casDate.DateOfService_End = '' THEN ''
				ELSE convert(varchar(10), casDate.DateOfService_End,101)
				END
		) AS DateOfService_End,
		cas.DenialReasons_Type as DenialReasons,
		dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
		pro.Provider_GroupName,
		ins.InsuranceCompany_GroupName,
		sta.Final_Status,
		sta.forum,
		cas.StatusDisposition,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_Amount) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Amount,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_Total) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Total, 
		convert(decimal(38,2),(select sum(DISTINCT Settlement_Int) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_Int,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_AF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_AF,
		convert(decimal(38,2),(select sum(DISTINCT Settlement_FF) FROM tblsettlements  (NOLOCK) WHERE Case_Id = cas.case_id)) as Settlement_FF,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay') as Delay_Notes,
		(select top 1 Notes_Desc FROM tblNotes (NOLOCK) WHERE Case_Id = cas.case_id and Notes_Type = 'Delay Arb') as Delay_ARB_NOTES,
		PacketID=p.PacketID,
		Rebuttal_Status,
		Policy_Number,
		Voluntary_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK)  where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('PreC','PreCToP')),
		Collection_Payment=(select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK) where tblTransactions.case_id=cas.Case_Id and DomainId=@DomainId and Transactions_Type in ('C','I')),
		bill_number=(select top 1 bill_number from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = cas.case_id and domainid = cas.DomainId),
		Date_Opened=convert(varchar, ISNULL(casDate.Date_Opened,''),101),
		Similar_To_Case_ID=(Select top 1 a.Case_Id FROM  tblCase a (NOLOCK) WHERE a.Provider_Id =cas.Provider_Id  and a.InjuredParty_LastName =cas.InjuredParty_LastName    
																			and a.InjuredParty_FirstName = cas.InjuredParty_FirstName and  a.Accident_Date =casDate.Accident_Date     
																			and a.Case_Id <> cas.case_id),
		Attorney_Name= Case @CompanyType 
					   When 'funding' THEN
		               (SUBSTRING(ISNULL(STUFF((
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId 
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @DomainId
							for xml path('')
						),1,0,''),',')))-1))
					   ELSE
		               (SELECT ISNULL(Attorney_LastName,'') +', '+ISNULL(Attorney_FirstName,'') FROM tblAttorney att WHERE att.Attorney_AutoId=cas.Attorney_Id)
					   END,
					  
		Reference_CaseId=ISNULL(cas.case_code,''),
		Settlement_Date= (CASE	WHEN sett.Settlement_Date IS NULL OR sett.Settlement_Date = '' THEN ''
				ELSE convert(varchar(10), max(DISTINCT sett.Settlement_Date),101)
				END
		) ,
		Event_Date= (SELECT convert(varchar(10), max(E.Event_Date),101) 
					FROM	tblEvent E
					WHERE	E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
					) ,
		Assigned_Attorney=cas.Assigned_Attorney,
		cas.Opened_By,
		Doctor_Name=(SELECT dbo.[fncGetPeerReviewDoctor](@domainId, cas.case_id)),
		PF.Name PortfolioName ,
		(CASE WHEN Date_AAA_Arb_Filed IS NULL OR Date_AAA_Arb_Filed = '' THEN ''
				ELSE convert(varchar(10), Date_AAA_Arb_Filed,101)
				END
		) AS Date_AAA_Arb_Filed,
		(ISNULL(adj.Adjuster_FirstName,'') + ' ' + ISNULL(adj.Adjuster_LastName,'')) AS  Adjuster_Name,
		ISNULL(adj.Adjuster_Email,'') AS Adjuster_Email,
		d.Defendant_Name,
		(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId 
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId
					AND (@i_a_Defendant = 0 OR aa.Attorney_Id = @i_a_Defendant) AND @CompanyType = 'funding'
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel,
		(Select TOP 1 ISNULL(Attorney_Email,'') FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
		inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
		Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DomainId) AS OC_Email,
    Date_BillSent=CASE WHEN casDate.Date_BillSent IS NULL OR casDate.Date_BillSent = '' THEN ''
					ELSE convert(varchar(10),casDate.Date_BillSent,101)
					END,
	tblSettlement_Type.Settlement_Type,
	(CASE WHEN Casdet.Scheduling_Order_Issue_Date IS NULL OR Casdet.Scheduling_Order_Issue_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Scheduling_Order_Issue_Date,101)
			END
	) AS Scheduling_Order_Issue_Date,
	(CASE WHEN Casdet.Facilitation_Summary_Due_Date IS NULL OR Casdet.Facilitation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10), Casdet.Facilitation_Summary_Due_Date,101)
			END
	) AS Facilitation_Summary_Due_Date,
	(CASE WHEN Casdet.Case_Evaluation_Summary_Due_Date IS NULL OR Casdet.Case_Evaluation_Summary_Due_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Summary_Due_Date,101)
			END
	) AS Case_Evaluation_Summary_Due_Date,
	(CASE WHEN Casdet.Date_Filed IS NULL OR Casdet.Date_Filed = '' THEN ''
			ELSE convert(varchar(10),Casdet.Date_Filed,101)
			END
	) AS Date_Filed,
	(CASE WHEN Casdet.Pretrial_Conf_Date IS NULL OR Casdet.Pretrial_Conf_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Pretrial_Conf_Date,101)
			END
	) AS Pretrial_Conf_Date,
	(CASE WHEN Casdet.Plaintiff_Discovery_Responses_Completed_Date IS NULL OR Casdet.Plaintiff_Discovery_Responses_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Plaintiff_Discovery_Responses_Completed_Date,101)
			END
	) AS Plaintiff_Discovery_Responses_Completed_Date,
	(CASE WHEN Casdet.Defense_Answers_to_our_Discovery_Completed_Date IS NULL OR Casdet.Defense_Answers_to_our_Discovery_Completed_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Answers_to_our_Discovery_Completed_Date,101)
			END
	) AS Defense_Answers_to_our_Discovery_Completed_Date,
	(CASE WHEN Casdet.Case_Evaluation_Date IS NULL OR Casdet.Case_Evaluation_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Case_Evaluation_Date,101)
			END
	) AS Case_Evaluation_Date,
	(CASE WHEN Casdet.Discovery_Stip_Sent_Date IS NULL OR Casdet.Discovery_Stip_Sent_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Discovery_Stip_Sent_Date,101)
			END
	) AS Discovery_Stip_Sent_Date,
	(CASE WHEN Casdet.Defense_Discovery_Receipt_Date IS NULL OR Casdet.Defense_Discovery_Receipt_Date = '' THEN ''
			ELSE convert(varchar(10),Casdet.Defense_Discovery_Receipt_Date,101)
			END
	) AS Defense_Discovery_Receipt_Date,
	court.Court_Name,
	cas.batchCode,
	DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) AS Status_Age,
	SUM(ISNULL(tre.Claim_Amount,0.00)) - SUM(ISNULL(tre.Paid_Amount,0.00)) - SUM(ISNULL(tre.WriteOff,0.00)) As Total_Balance,
	DefAttorneyFileNo,
	Old_Status AS Old_Status,
	(SELECT TOP 1 USER_ID FROM TBLNOTES WHERE CASE_ID = cas.CASE_ID AND NOTES_DESC LIKE 'STATUS CHANGED FROM%' ORDER BY NOTES_DATE DESC) [WHO_CHANGE_TO_THE_CURRENT_STATUS]
	FROM
		@CaseData cas 
		INNER JOIN @CaseAmounts casAmt ON cas.Case_Id = casAmt.Case_Id
	    INNER JOIN @CaseDates casDate ON cas.Case_Id = casDate.Case_Id
		join #temp tmp on cas.Case_Id=tmp.case_id
		INNER JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id 
		INNER JOIN tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT JOIN dbo.tblStatus sta (NOLOCK) on cas.Status=sta.Status_Type AND cas.DomainId= sta.DomainId
		LEFT OUTER JOIN tblTreatment (NOLOCK) tre on tre.Case_Id= cas.Case_Id
		LEFT OUTER JOIN TXN_CASE_PEER_REVIEW_DOCTOR (NOLOCK) prdoc on prdoc.TREATMENT_ID = tre.treatment_id
		LEFT OUTER JOIN TXN_tblTreatment t_tre (NOLOCK) on t_tre.Treatment_Id = tre.treatment_id
		LEFT JOIN tblPacket p (NOLOCK) on cas.FK_Packet_ID = p.Packet_Auto_ID
		LEFT OUTER JOIN tblSettlements sett  WITH (NOLOCK) ON sett.DomainId= cas.Domainid and cas.Case_Id = sett.Case_Id
		LEFT JOIN tblSettlement_Type (NOLOCK) on sett.Settled_Type = tblSettlement_Type.SettlementType_Id
		LEFT JOIN tblAdjusters adj (NOLOCK) ON adj.Adjuster_Id = cas.Adjuster_Id AND cas.DomainId= adj.DomainId
		LEFT JOIN tblTransactions T (NOLOCK) ON T.Case_Id = cas.Case_Id AND T.DomainId = cas.DomainId
		LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ  WITH (NOLOCK) ON p.FK_CaseType_Id = pkt_typ.PK_CaseType_Id 
		--LEFT OUTER JOIN tblEvent E  WITH (NOLOCK) ON E.DomainId= cas.Domainid and cas.Case_Id = E.Case_Id
		LEFT OUTER JOIN tbl_portfolio PF (NOLOCK)on cas.PortfolioId=PF.id  
		LEFT JOIN tblDefendant d(NOLOCK) ON d.Defendant_id = cas.Defendant_Id
		LEFT JOIN tblCase_Date_Details Casdet(NOLOCK) ON cas.Case_Id=casdet.case_id
		LEFT JOIN tblCourt court(nolock) ON cas.Court_id=court.court_id
	WHERE
		cas.DomainId = @DomainID
		AND	(@s_a_MultipleCase_ID ='' OR --cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')))
		cas.Case_Id IN (SELECT CaseID FROM @CaseSearch) or  cas.IndexOrAAA_Number IN (SELECT CaseId FROM @CaseSearch))
		AND (@s_a_ProviderSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderSel,',')))
		AND (@s_a_InsuranceSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceSel,',')))	
		AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))	
		AND (@s_a_InitialStatusGroupSel ='' OR cas.Initial_Status IN (SELECT s FROM dbo.SplitString(@s_a_InitialStatusGroupSel,',')))
		--AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
		AND (@s_a_BillNumber ='' OR tre.BILL_NUMBER like '%'+ @s_a_BillNumber + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')

		AND (@s_a_ProviderGroup ='' OR pro.Provider_GroupName = @s_a_ProviderGroup )
		AND (@s_a_InsuranceGroup='' OR ins.InsuranceCompany_GroupName = @s_a_InsuranceGroup )		
		AND (@i_a_DenailReason = '' OR t_tre.DenialReasons_Id IN (SELECT s FROM dbo.SplitString(@i_a_DenailReason,',')))
		AND (@i_a_Court = '' OR cas.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@i_a_Court,',')))

		AND ((@CompanyType != 'funding' AND (@i_a_Defendant = 0 OR cas.defendant_Id = @i_a_Defendant)) OR
		     @CompanyType = 'funding' AND(@i_a_Defendant = 0 OR (Select Count(*) from tblAttorney_Case_Assignment aca where
			aca.Attorney_Id = @i_a_Defendant and Case_Id = cas.Case_Id and DomainId = @DomainId) > 0))

		AND (@i_a_ReviewingDoctor = 0 OR tre.PeerReviewDoctor_ID = @i_a_ReviewingDoctor)
		AND (@s_a_date_opened_from='' OR (Date_Opened Between convert(datetime,@s_a_date_opened_from) And convert(datetime,@s_a_date_Opened_To)+1))
		AND (@s_a_DOSFrom ='' or (CONVERT(DATETIME,casDate.DateOfService_Start) >=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSFrom,101))  and casDate.DateOfService_Start IS NOT NULL))
		AND (@s_a_DOSTo ='' or (CONVERT(DATETIME,casDate.DateOfService_End) <=CONVERT(DATETIME, CONVERT(VARCHAR, @s_a_DOSTo,101))  and casDate.DateOfService_End IS NOT NULL))
		AND (@s_a_date_status_changed_from = '' OR (Date_Status_Changed Between convert(datetime,@s_a_date_status_changed_from) And convert(datetime,@s_a_date_opened_To)+1))
		AND (@s_a_FinalStatus  ='' OR  ISNULL (sta.Final_Status,'')= @s_a_FinalStatus )
		AND (@s_a_Forum  ='' OR ISNULL (sta.forum,'')= @s_a_Forum )

		AND (@s_a_injuredfirstname = '' OR cas.InjuredParty_FirstName like '%'+ @s_a_injuredfirstname + '%')
		AND (@s_a_injuredlastname = '' OR cas.InjuredParty_LastName like '%'+ @s_a_injuredlastname + '%')
		AND (@s_a_insuredfirstname = '' OR cas.InsuredParty_FirstName like '%'+ @s_a_insuredfirstname + '%')
		AND (@s_a_insuredlastname = '' OR cas.InsuredParty_LastName like '%'+ @s_a_insuredlastname + '%')
		AND (@s_a_PacketId= '' OR p.PacketID LIKE '%' + @s_a_PacketId + '%')  			
		AND (@s_a_adjusterfirstname = '' OR adj.Adjuster_FirstName like '%'+ @s_a_adjusterfirstname + '%')
		AND (@s_a_adjusterlastname = '' OR adj.Adjuster_LastName like '%'+ @s_a_adjusterlastname + '%')
		AND (@s_a_accidentdate = '' OR CONVERT(VARCHAR,Accident_Date,101) = @s_a_AccidentDate)
		AND (@s_a_accountno = '' OR tre.account_number like '%' + @s_a_AccountNo +'%' OR tre.bill_number like '%' + @s_a_AccountNo +'%')  
		AND (@s_a_checknumber = '' OR cas.case_id IN (SELECT DISTINCT CASE_ID FROM tblTransactions (NOLOCK) WHERE DomainId = @DomainId and REPLACE(ChequeNo,'-','') LIKE '%' + REPLACE(@s_a_checknumber,'-','') + '%'))  
		AND (@s_a_paymentdatefrom = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) >= @s_a_paymentdatefrom)
		AND (@s_a_paymentdateto = '' OR CONVERT(VARCHAR,T.Transactions_Date,101) <= @s_a_paymentdateto)
		AND (@s_a_filledunfiled = '' OR sta.Filed_Unfiled IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_filledunfiled,','))) 
		AND (@s_a_specialityid = '' OR tre.SERVICE_TYPE IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_specialityid,',')))
		AND (@s_a_attorneyfirmid = '0' OR cas.AttorneyFirmId = CAST(@s_a_attorneyfirmid AS INT)) 
		AND (@s_a_rebuttalstatusid = '' OR Rebuttal_Status = @s_a_rebuttalstatusid)  
		AND (@s_a_casetypeid = 0 OR pkt_typ.PK_CaseType_Id = CAST(@s_a_casetypeid AS INT))
		AND (@s_a_locationid = 0 OR cas.location_id = CAST(@s_a_locationid AS INT))
		AND (@s_a_PortfolioId = '0' OR @s_a_PortfolioId = '' OR cas.PortfolioId  IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@s_a_PortfolioId,',')))  
		--AND (@s_a_PortfolioId=0 OR cas.PortfolioId= @s_a_PortfolioId)  
	    AND (@InvestorId = 0 OR cas.portfolioid in (Select portfolioid from tbl_InvestorPortfolio IP (NOLOCK) WHERE IP.InvestorId =@InvestorId)) 
		AND (@AssignedValue = 0 or cas.UserId = @SZ_USER_ID ) 
		AND	(DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) >= @StatusStart)
		AND	(@StatusEnd = 0 OR DateDiff(dd, ISNULL(casDate.Date_Status_Changed, casDate.Date_Opened), GETDATE()) <= @StatusEnd)
		AND (ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) >= @TotalBalStart)
		AND	(@TotalBalEnd = 0 OR ISNULL(tre.Claim_Amount,0.00) - ISNULL(tre.Paid_Amount,0.00) - ISNULL(tre.WriteOff,0.00) <= @TotalBalEnd)
	GROUP BY    
	  cas.Case_Id,  
	  cas.Case_AutoId,  
	  cas.InjuredParty_FirstName,  
	  cas.InjuredParty_LastName,  
	  pro.Provider_Name,  
	  ins.InsuranceCompany_Name,  
	  cas.Indexoraaa_number,  
	  casAmt.Claim_Amount,  
	  cas.Status,  
	  pro.Provider_GroupName,  
	  casAmt.Paid_Amount,  
	  casAmt.WriteOff,
	  cas.Ins_Claim_Number,  
	  casDate.Date_Opened,  
	  casDate.Date_Status_Changed,
	  casAmt.Fee_Schedule,
	  cas.Initial_Status,
	  casDate.Accident_Date,
	  casDate.DateOfService_Start,
	  casDate.DateOfService_End,
	  cas.DenialReasons_Type,
	  ins.InsuranceCompany_GroupName,
	  sta.Final_Status,
	  sta.forum,
	  cas.StatusDisposition,
	  p.PacketID,
	  cas.Rebuttal_Status,
	  cas.Policy_Number,
	  cas.DomainId,
	  cas.Provider_Id,
	  cas.Attorney_Id,
	  cas.Case_Code,
	  cas.Assigned_Attorney,
	  cas.Opened_By,
	  --cas.PortfolioId
	  	casDate.Date_BillSent, 
	   PF.Name ,
	   casDate.Date_AAA_Arb_Filed,
	   adj.Adjuster_FirstName,
	   adj.Adjuster_LastName,
	   d.Defendant_Name,
	   adj.Adjuster_Email,
	   tblSettlement_Type.Settlement_Type,
	   Casdet.Scheduling_Order_Issue_Date,
	   casdet.Facilitation_Summary_Due_Date,
	   casdet.Case_Evaluation_Summary_Due_Date,
	   Casdet.Date_Filed,
		casdet.Pretrial_Conf_Date,
		casdet.Plaintiff_Discovery_Responses_Completed_Date,
		casdet.Defense_Answers_to_our_Discovery_Completed_Date,
		Casdet.Case_Evaluation_Date,
		casdet.Discovery_Stip_Sent_Date,
		casdet.Defense_Discovery_Receipt_Date,
	   court.Court_Name,
		cas.batchCode,
		--tre.Claim_Amount,
		--tre.Paid_Amount,
		--tre.WriteOff,
		sett.Settlement_Date,
		casDate.Date_BillSent--,
		--Event_Date
		,cas.DefAttorneyFileNo,
		cas.Old_Status
	ORDER BY 
		Case_AutoId	desc

		END
	END
	 SET NOCOUNT OFF

