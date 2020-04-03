CREATE TABLE [dbo].[tblTreatment] (
    [Treatment_Id]         INT             IDENTITY (1, 1) NOT NULL,
    [Case_Id]              NVARCHAR (100)  NULL,
    [DateOfService_Start]  DATETIME        NULL,
    [DateOfService_End]    DATETIME        NULL,
    [Claim_Amount]         NUMERIC (19, 2) NULL,
    [Paid_Amount]          NUMERIC (19, 2) NULL,
    [Date_BillSent_old]    NVARCHAR (100)  NULL,
    [Date_BillSent]        DATETIME        NULL,
    [SERVICE_TYPE]         NVARCHAR (100)  NULL,
    [DENIALREASONS_TYPE]   NVARCHAR (100)  NULL,
    [Settlement_Pctg]      FLOAT (53)      NULL,
    [Interest_Pctg]        FLOAT (53)      NULL,
    [AttorneyFee]          FLOAT (53)      NULL,
    [FilingFeeAmt]         FLOAT (53)      NULL,
    [SettlementInt]        FLOAT (53)      NULL,
    [CPT_Id]               INT             NULL,
    [BX_BILL_ID]           INT             NULL,
    [Date_Created]         DATETIME        CONSTRAINT [DF_tblTreatment_Date_Created] DEFAULT (getdate()) NULL,
    [Doctor_Id]            INT             NULL,
    [Litigation_Status]    INT             NULL,
    [account_number]       VARCHAR (20)    NULL,
    [BILL_NUMBER]          VARCHAR (100)   NULL,
    [Action_Type]          VARCHAR (100)   NULL,
    [Operating_Doctor]     VARCHAR (100)   NULL,
    [Fee_Schedule]         NUMERIC (18, 2) NULL,
    [DENIALREASONS_TYPE1]  VARCHAR (100)   NULL,
    [DenialReason_ID]      INT             NULL,
    [PeerReviewDoctor_ID]  INT             NULL,
    [TreatingDoctor_ID]    INT             NULL,
    [DomainId]             NVARCHAR (512)  CONSTRAINT [DF__tblTreatm__Domai__0E04126B] DEFAULT ('h1') NOT NULL,
    [Patient_Number_Medic] VARCHAR (100)   CONSTRAINT [DF__tblTreatm__Patie__4AADF94F] DEFAULT (NULL) NULL,
    [DocumentStatus]       VARCHAR (100)   NULL,
    [DenialDate]           DATETIME        NULL,
    [Treatment_Id_old]     INT             NULL,
    [ACT_CASE_ID]          VARCHAR (100)   NULL,
    [IMEDate]              DATETIME        NULL,
    [Notes]                NVARCHAR (200)  NULL,
    [Denial_Posted_Date]   DATETIME        NULL,
    [Refund_Date]          DATETIME        NULL,
    [WriteOff]             NUMERIC (19, 2) NULL,
    [DeductibleAmount]     DECIMAL (19, 2) NULL,
    [pom_created_date]     DATETIME        NULL,
    [pom_id]               VARCHAR (16)    NULL,
    CONSTRAINT [PK_tblTreatment] PRIMARY KEY CLUSTERED ([Treatment_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_tblTreatment_CaseId]
    ON [dbo].[tblTreatment]([Case_Id] ASC)
    INCLUDE([account_number]);


GO
CREATE NONCLUSTERED INDEX [IDX_tbltreatment_Domain_CaseId]
    ON [dbo].[tblTreatment]([DomainId] ASC, [Case_Id] ASC)
    INCLUDE([DateOfService_Start], [DateOfService_End], [Claim_Amount], [Paid_Amount], [Date_BillSent_old], [Date_BillSent], [SERVICE_TYPE], [DENIALREASONS_TYPE], [Settlement_Pctg], [Interest_Pctg], [AttorneyFee], [FilingFeeAmt], [SettlementInt], [CPT_Id], [BX_BILL_ID], [Doctor_Id], [Litigation_Status], [account_number], [BILL_NUMBER], [Operating_Doctor], [Fee_Schedule], [DENIALREASONS_TYPE1], [DenialReason_ID], [PeerReviewDoctor_ID], [TreatingDoctor_ID], [Patient_Number_Medic], [DocumentStatus], [DenialDate], [Treatment_Id], [Date_Created], [Action_Type], [Treatment_Id_old], [ACT_CASE_ID], [IMEDate], [Notes], [Denial_Posted_Date], [Refund_Date], [WriteOff]);


GO
CREATE NONCLUSTERED INDEX [IDX_tbltreatment_BILL_NUMBER]
    ON [dbo].[tblTreatment]([DomainId] ASC, [BILL_NUMBER] ASC, [Case_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tbltreatment_DenialReason_Id]
    ON [dbo].[tblTreatment]([DomainId] ASC, [DenialReason_ID] ASC, [Case_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_TXN_tblTreatment_DenialReason_Id]
    ON [dbo].[tblTreatment]([DomainId] ASC, [DenialReason_ID] ASC, [Case_Id] ASC)
    INCLUDE([Action_Type], [Treatment_Id]);


GO
CREATE NONCLUSTERED INDEX [IDX_DeductibleAMT]
    ON [dbo].[tblTreatment]([Case_Id] ASC)
    INCLUDE([DeductibleAmount]);


GO
CREATE NONCLUSTERED INDEX [IDX_TXN_tblTreatment_Case_Id2]
    ON [dbo].[tblTreatment]([Case_Id] ASC, [DateOfService_Start] ASC)
    INCLUDE([Treatment_Id], [DateOfService_End], [Claim_Amount], [Paid_Amount], [Date_BillSent_old], [Date_BillSent], [SERVICE_TYPE], [DENIALREASONS_TYPE], [Settlement_Pctg], [Interest_Pctg], [AttorneyFee], [FilingFeeAmt], [SettlementInt], [CPT_Id], [BX_BILL_ID], [Date_Created], [Doctor_Id], [Litigation_Status], [account_number], [BILL_NUMBER], [Action_Type], [Operating_Doctor], [Fee_Schedule], [DENIALREASONS_TYPE1], [DenialReason_ID], [PeerReviewDoctor_ID], [TreatingDoctor_ID], [Patient_Number_Medic], [DocumentStatus], [DenialDate], [Treatment_Id_old], [ACT_CASE_ID], [IMEDate], [Notes], [Denial_Posted_Date], [Refund_Date], [WriteOff]);


GO
CREATE NONCLUSTERED INDEX [IX_tblTreatmentCase]
    ON [dbo].[tblTreatment]([Case_Id] ASC, [DateOfService_Start] ASC)
    INCLUDE([SERVICE_TYPE], [BILL_NUMBER], [TreatingDoctor_ID], [account_number]);


GO
CREATE TRIGGER [_tbltreatment_AuditOnUpdate] 
   ON  [dbo].[tbltreatment] 
   AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[_tbltreatment_Audit]
    SELECT
		*,
		'UPDATE',
		GETDATE(),
		system_user
	FROM
		Inserted
END

GO
DISABLE TRIGGER [dbo].[_tbltreatment_AuditOnUpdate]
    ON [dbo].[tblTreatment];


GO
CREATE TRIGGER [_tbltreatment_AuditOnInsert] 
   ON  [dbo].[tbltreatment] 
   AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[_tbltreatment_Audit]
    SELECT
		*,
		'INSERT',
		GETDATE(),
		system_user
	FROM
		Inserted
END

GO
DISABLE TRIGGER [dbo].[_tbltreatment_AuditOnInsert]
    ON [dbo].[tblTreatment];


GO
CREATE TRIGGER [_tbltreatment_AuditOnDelete] 
   ON  [dbo].[tbltreatment] 
   AFTER DELETE
AS 
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[_tbltreatment_Audit]
    SELECT
		*,
		'DELETE',
		GETDATE(),
		system_user
	FROM
		DELETED
END

GO
DISABLE TRIGGER [dbo].[_tbltreatment_AuditOnDelete]
    ON [dbo].[tblTreatment];


GO

CREATE TRIGGER [dbo].[trgDelete] ON [dbo].[tblTreatment] 
FOR UPDATE,DELETE
AS
begin
	update tblcase
		set DateOfService_Start=DOS,
		DateOfService_End=DOE,
		claim_amount=CLAIM,
		paid_amount=paid,
		Date_BillSent=DBS,
		fee_schedule=FS,
		WriteOff = WOff
		from tblcase
		inner join (select tblcase.Case_Id as ID,
					MIN(tblTreatment.DateOfService_Start) as DOS,
					MAX(tblTreatment.DateOfService_end) as DOE,
					ISNULL(SUM(tblTreatment.Claim_Amount),0) as CLAIM,
					ISNULL(SUM(tblTreatment.Paid_Amount),0) as paid,
					MIN(tblTreatment.Date_BillSent) as DBS,
					SUM(tblTreatment.Fee_Schedule) as FS,
					SUM(tblTreatment.WriteOff) as WOff
					from tblcase
					inner join tblTreatment on tblTreatment.Case_Id = tblcase.Case_Id
					where tblTreatment.Case_Id = tblcase.Case_Id --and tblTreatment.Paid_Amount <=tblTreatment.Claim_Amount
					and tblcase.Case_Id IN (select case_id from inserted)
					group by tblcase.case_id) T on ID = tblcase.Case_Id
		where case_id =id 
		And Case_Id IN (select case_id from inserted)
		--and  (isnull(claim_amount,0) <> isnull(CLAIM,0) OR  isnull(Fee_Schedule,0) <> isnull(FS,0))


		----------------
		update tblcase
		set DateOfService_Start=DOS,
		DateOfService_End=DOE,
		claim_amount=CLAIM,
		paid_amount=paid,
		Date_BillSent=DBS,
		fee_schedule=FS,
		WriteOff = WOff
		from tblcase
		left join (select tblcase.Case_Id as ID,
					MIN(tblTreatment.DateOfService_Start) as DOS,
					MAX(tblTreatment.DateOfService_end) as DOE,
					ISNULL(SUM(tblTreatment.Claim_Amount),0) as CLAIM,
					ISNULL(SUM(tblTreatment.Paid_Amount),0) as paid,
					MIN(tblTreatment.Date_BillSent) as DBS,
					SUM(tblTreatment.Fee_Schedule) as FS,
					SUM(tblTreatment.WriteOff) as WOff
					from tblcase
					inner join tblTreatment on tblTreatment.Case_Id = tblcase.Case_Id
					where tblTreatment.Case_Id = tblcase.Case_Id --and tblTreatment.Paid_Amount <=tblTreatment.Claim_Amount
					and tblcase.Case_Id IN (select case_id from DELETED)
					group by tblcase.case_id) T on ID = tblcase.Case_Id
		where --case_id =id 
		--And 
		Case_Id IN (select case_id from DELETED)
--declare
--@doss datetime,
--@dose datetime,
--@claim_amt money,
--@paid_amt money,
--@dbs Datetime,
--@Fee_Schedule money,
--@WriteOff money,
--@Refund_amount money,
--@Refund_Fees money

--select @doss = min(DateOfService_Start) from tbltreatment where case_id in (select case_id from deleted)
--select @dose = max(DateOfService_End) from tbltreatment where case_id in (select case_id from deleted)
--select @claim_amt = sum(claim_amount) from tbltreatment where case_id in (select case_id from deleted)
--select @paid_amt = sum(paid_Amount) from tbltreatment where case_id in (select case_id from deleted)
--select @dbs = max(Date_BillSent) from tbltreatment where case_id in (select case_id from deleted)
--select @Fee_Schedule = sum(Fee_Schedule) from tbltreatment where case_id in (select case_id from deleted)
--select @WriteOff = sum(writeOff) from tbltreatment where case_id in (select case_id from inserted)


--Select @Refund_amount = sum(ISNULL(trmt.Claim_Amount,0)), @Refund_Fees = SUM(ISNULL(trmt.Fee_Schedule,0.0)) from tblTreatment (NOLOCK) trmt 
--	  where Case_Id in (select case_id from deleted) and (trmt.Refund_Date is not null or trmt.Refund_Date!='')

--IF(ISNULL(@Refund_amount,0) > 0)
--BEGIN 
--	Set @claim_amt = isnull(@claim_amt,0) - isnull(@Refund_amount,0)
--	Set @Fee_Schedule = isnull(@Fee_Schedule,0) - isnull(@Refund_Fees,0)
--END
--update tblcase set DateOfService_Start=@doss,
--DateOfService_End=@dose,
--claim_amount=convert(varchar,@claim_amt),
--paid_amount=convert(varchar,@paid_amt),
--WriteOff = convert(float, @WriteOff),
--Date_BillSent=@dbs,fee_schedule=@Fee_Schedule where case_id in (select case_id from deleted)

end

GO


CREATE TRIGGER [dbo].[trgInsert] ON [dbo].[tblTreatment] 
FOR INSERT
AS
begin

	update tblcase
		set DateOfService_Start=DOS,
		DateOfService_End=DOE,
		claim_amount=CLAIM,
		paid_amount=paid,
		Date_BillSent=DBS,
		fee_schedule=FS,
		writeOff = WOff
		from tblcase
		LEFT OUTER JOIN (select tblTreatment.Case_Id as ID,
					MIN(tblTreatment.DateOfService_Start) as DOS,
					MAX(tblTreatment.DateOfService_end) as DOE,
					ISNULL(SUM(tblTreatment.Claim_Amount),0) as CLAIM,
					ISNULL(SUM(tblTreatment.Paid_Amount),0) as paid,
					MIN(tblTreatment.Date_BillSent) as DBS,
					SUM(tblTreatment.Fee_Schedule) as FS,
					SUM(tblTreatment.writeOff) as WOff
					from tblTreatment 
					where 
						tblTreatment.Case_Id IN (select case_id from inserted)
					group by tblTreatment.case_id) T on ID = tblcase.Case_Id
		where case_id =id --and  (isnull(claim_amount,0) <> isnull(CLAIM,0) OR  isnull(Fee_Schedule,0) <> isnull(FS,0))
		And Case_Id IN (select case_id from inserted)




end
