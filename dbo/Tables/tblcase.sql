CREATE TABLE [dbo].[tblcase] (
    [Case_AutoId]                         INT             IDENTITY (12001, 1) NOT NULL,
    [Case_Id]                             VARCHAR (50)    NOT NULL,
    [Case_Code]                           VARCHAR (100)   NULL,
    [Provider_Code]                       VARCHAR (100)   NULL,
    [InsuranceCompany_Code]               VARCHAR (100)   NULL,
    [Provider_Id]                         INT             NULL,
    [InsuranceCompany_Id]                 INT             NULL,
    [InjuredParty_LastName]               VARCHAR (100)   NULL,
    [InjuredParty_FirstName]              VARCHAR (100)   NULL,
    [InjuredParty_Address]                VARCHAR (255)   NULL,
    [InjuredParty_City]                   VARCHAR (50)    NULL,
    [InjuredParty_State]                  VARCHAR (50)    NULL,
    [InjuredParty_Zip]                    VARCHAR (50)    NULL,
    [InjuredParty_Phone]                  VARCHAR (100)   NULL,
    [InjuredParty_Misc]                   VARCHAR (50)    NULL,
    [InsuredParty_LastName]               VARCHAR (100)   NULL,
    [InsuredParty_FirstName]              VARCHAR (100)   NULL,
    [InsuredParty_Address]                VARCHAR (255)   NULL,
    [InsuredParty_City]                   VARCHAR (50)    NULL,
    [InsuredParty_State]                  VARCHAR (50)    NULL,
    [InsuredParty_Zip]                    VARCHAR (50)    NULL,
    [InsuredParty_Misc]                   VARCHAR (50)    NULL,
    [Accident_Date]                       DATETIME        NULL,
    [Accident_Address]                    NVARCHAR (255)  NULL,
    [Accident_City]                       NVARCHAR (40)   NULL,
    [Accident_State]                      NVARCHAR (40)   NULL,
    [Accident_Zip]                        NVARCHAR (40)   NULL,
    [Policy_Number]                       VARCHAR (40)    NULL,
    [Ins_Claim_Number]                    NVARCHAR (50)   NULL,
    [IndexOrAAA_Number]                   VARCHAR (40)    NULL,
    [Status]                              VARCHAR (50)    NULL,
    [Old_Status]                          VARCHAR (50)    NULL,
    [Defendant_Id]                        VARCHAR (50)    NULL,
    [Date_Opened]                         DATETIME        DEFAULT (getdate()) NULL,
    [Date_Opened_Full]                    DATETIME        CONSTRAINT [DF_tblcase_Date_Opened_Full] DEFAULT (getdate()) NULL,
    [Last_Status]                         VARCHAR (50)    NULL,
    [Initial_Status]                      VARCHAR (50)    NULL,
    [Memo]                                VARCHAR (255)   NULL,
    [InjuredParty_Type]                   VARCHAR (50)    NULL,
    [InsuredParty_Type]                   VARCHAR (50)    NULL,
    [Adjuster_Id]                         INT             NULL,
    [DenialReasons_Type]                  VARCHAR (2000)  NULL,
    [Court_Id]                            INT             NULL,
    [Attorney_FileNumber]                 VARCHAR (100)   NULL,
    [Group_Data]                          INT             NULL,
    [Group_Id]                            INT             NULL,
    [Date_Status_Changed]                 DATETIME        CONSTRAINT [DF_tblcase_Date_Status_Changed] DEFAULT (getdate()) NULL,
    [Motion_Date]                         DATETIME        NULL,
    [Attorney_Id]                         VARCHAR (50)    NULL,
    [Date_Answer_Expected]                DATETIME        NULL,
    [Reply_Date]                          DATETIME        NULL,
    [Calendar_Part]                       VARCHAR (50)    NULL,
    [Motion_Type]                         VARCHAR (100)   NULL,
    [Whose_Motion]                        VARCHAR (50)    NULL,
    [Defense_Opp_Due]                     DATETIME        NULL,
    [Date_Ext_Of_Time_2]                  DATETIME        NULL,
    [XMotion_Type]                        VARCHAR (50)    NULL,
    [Case_Billing]                        FLOAT (53)      NULL,
    [DateOfService_Start]                 DATETIME        NULL,
    [DateOfService_End]                   DATETIME        NULL,
    [Claim_Amount]                        FLOAT (53)      NULL,
    [Paid_Amount]                         FLOAT (53)      NULL,
    [Date_BillSent]                       DATETIME        NULL,
    [Caption]                             VARCHAR (1000)  NULL,
    [Group_ClaimAmt]                      FLOAT (53)      NULL,
    [Group_PaidAmt]                       FLOAT (53)      NULL,
    [Group_Balance]                       FLOAT (53)      NULL,
    [Group_InsClaimNo]                    VARCHAR (200)   NULL,
    [Group_All]                           VARCHAR (500)   NULL,
    [Date_Packeted]                       DATETIME        NULL,
    [Group_Accident]                      VARCHAR (200)   NULL,
    [Group_PolicyNum]                     NVARCHAR (200)  NULL,
    [GROUP_CASE_SEQUENCE]                 INT             NULL,
    [Our_SJ_Motion_Activity]              NVARCHAR (100)  NULL,
    [Their_SJ_Motion_Activity]            NVARCHAR (100)  NULL,
    [Our_Discovery_Demands]               NVARCHAR (100)  NULL,
    [Our_Discovery_Responses]             NVARCHAR (100)  NULL,
    [Date_Summons_Printed]                DATETIME        NULL,
    [Plaintiff_Discovery_Due_Date]        DATETIME        NULL,
    [Defendant_Discovery_Due_Date]        DATETIME        NULL,
    [Date_Bill_Submitted]                 DATETIME        NULL,
    [Date_Index_Number_Purchased]         DATETIME        NULL,
    [Date_Afidavit_Filed]                 DATETIME        NULL,
    [Date_Ext_Of_Time]                    DATETIME        NULL,
    [Date_Summons_Sent_Court]             DATETIME        NULL,
    [Date_Ext_Of_Time_3]                  DATETIME        NULL,
    [Served_To]                           VARCHAR (100)   NULL,
    [Served_On_Date]                      DATETIME        NULL,
    [Served_On_Time]                      VARCHAR (50)    NULL,
    [Date_Closed]                         DATETIME        NULL,
    [Notary_id]                           INT             NULL,
    [stips_signed_and_returned]           BIT             NULL,
    [stips_signed_and_returned_2]         BIT             NULL,
    [stips_signed_and_returned_3]         BIT             NULL,
    [Date_Demands_Printed]                DATETIME        NULL,
    [Date_Disc_Conf_Letter_Printed]       DATETIME        NULL,
    [Date_Reply_To_Disc_Conf_Letter_Recd] DATETIME        NULL,
    [psid]                                INT             NULL,
    [Motion_Status]                       VARCHAR (50)    NULL,
    [BX_Originated]                       BIT             CONSTRAINT [DF_tblcase_BX_Originated] DEFAULT ((0)) NULL,
    [BX_TEMP_ID]                          VARCHAR (50)    NULL,
    [Date_AAA_Arb_Filed]                  DATETIME        NULL,
    [Date_AAA_Concilation_Over]           DATETIME        NULL,
    [Arbitrator_ID]                       INT             NULL,
    [AAA_Confirmed_Date]                  DATETIME        NULL,
    [userId]                              NVARCHAR (100)  NULL,
    [Doctor_id]                           INT             NULL,
    [batchcode]                           NVARCHAR (50)   NULL,
    [location_id]                         INT             NULL,
    [GBDocument_RelativePath]             VARCHAR (MAX)   NULL,
    [GBDocument_AbsolutePath]             VARCHAR (MAX)   NULL,
    [INJURED_LAST_BKP]                    VARCHAR (500)   NULL,
    [Bit_FromGB]                          INT             NULL,
    [Injured_Caption]                     VARCHAR (8000)  NULL,
    [Provider_Caption]                    VARCHAR (8000)  NULL,
    [AAA_Decisions]                       VARCHAR (800)   NULL,
    [GB_Dms_Link]                         VARCHAR (800)   NULL,
    [GB_CASE_ID]                          VARCHAR (500)   NULL,
    [GB_COMPANY_ID]                       VARCHAR (500)   NULL,
    [GB_CASE_NO]                          VARCHAR (500)   NULL,
    [DateNotice_TrialFiled]               DATETIME        NULL,
    [DateFile_Trial_DeNovo]               DATETIME        NULL,
    [DateAAA_packagePrinting]             DATETIME        NULL,
    [DateAAA_ResponceRecieved]            DATETIME        NULL,
    [Fee_Schedule]                        FLOAT (53)      NULL,
    [Representetive]                      NVARCHAR (500)  NULL,
    [Representative_Contact_Number]       VARCHAR (500)   NULL,
    [Denial_Date]                         DATETIME        NULL,
    [INSURANCECOMPANY_INITIAL_ADDRESS]    VARCHAR (2000)  NULL,
    [DOSHI_CASE_ID]                       INT             NULL,
    [OPENED_BY]                           VARCHAR (50)    NULL,
    [Assigned_Attorney]                   INT             NULL,
    [Caseid_no]                           INT             NULL,
    [Date_of_AAA_Awards]                  DATETIME        NULL,
    [Date_NAM_ARB_Filed]                  DATETIME        NULL,
    [Date_NAM_Confirmed]                  DATETIME        NULL,
    [Date_NAM_Response_Received]          DATETIME        NULL,
    [Date_of_NAM_Awards]                  DATETIME        NULL,
    [Date_NAM_Package_Printed]            DATETIME        NULL,
    [firm_split_percent]                  NUMERIC (18, 2) NULL,
    [old_Case_id]                         VARCHAR (100)   NULL,
    [DomainId]                            VARCHAR (50)    CONSTRAINT [DF__tblcase__DomainI__29E1370A] DEFAULT ('h1') NULL,
    [FK_Packet_ID]                        INT             NULL,
    [purchaseDate]                        DATETIME        NULL,
    [PortfolioId]                         INT             NULL,
    [AttorneyFirmId]                      INT             NULL,
    [FIRST_PARTY_SUIT_DATE]               DATETIME        NULL,
    [gbb_type]                            VARCHAR (10)    NULL,
    [GB_LawFirm_ID]                       VARCHAR (100)   NULL,
    [IsDuplicateCase]                     INT             NULL,
    [Rebuttal_Status]                     VARCHAR (200)   NULL,
    [original_status]                     VARCHAR (50)    NULL,
    [Date_Rebuttal_Status_Changed]        DATETIME        NULL,
    [StatusDisposition]                   VARCHAR (1000)  NULL,
    [WriteOff]                            FLOAT (53)      NULL,
    [IsDeleted]                           BIT             CONSTRAINT [DF__tblcase__IsDelet__73B1A590] DEFAULT ((0)) NULL,
    [Verification_Request_PostedBy]       VARCHAR (50)    NULL,
    [Verification_Request_PostedDate]     DATETIME        NULL,
    [Denial_Request_PostedBy]             VARCHAR (50)    NULL,
    [Denial_Request_PostedDate]           DATETIME        NULL,
    [MainDenialReasonsId]                 VARCHAR (MAX)   NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_DomainId_CaseId]
    ON [dbo].[tblcase]([DomainId] ASC, [Case_Id] DESC);


GO
CREATE NONCLUSTERED INDEX [Xi_Provid_lName_fname_AcDate_cid_insid_did]
    ON [dbo].[tblcase]([Provider_Id] ASC, [InjuredParty_LastName] ASC, [InjuredParty_FirstName] ASC, [Accident_Date] ASC, [Case_Id] ASC, [InsuranceCompany_Id] ASC, [DomainId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_tblcase_Initialstatus]
    ON [dbo].[tblcase]([DomainId] ASC, [Initial_Status] ASC)
    INCLUDE([Case_AutoId], [Case_Id], [Case_Code], [Provider_Id], [FK_Packet_ID], [PortfolioId], [AttorneyFirmId], [Rebuttal_Status], [StatusDisposition], [DateOfService_Start], [DateOfService_End], [Claim_Amount], [Paid_Amount], [userId], [Fee_Schedule], [Policy_Number], [Ins_Claim_Number], [IndexOrAAA_Number], [Status], [Date_Opened], [DenialReasons_Type], [InsuranceCompany_Id], [InjuredParty_LastName], [InjuredParty_FirstName], [InsuredParty_LastName], [InsuredParty_FirstName], [Accident_Date], [Date_Status_Changed]);


GO
CREATE NONCLUSTERED INDEX [tblcase_InitialStatus]
    ON [dbo].[tblcase]([DomainId] ASC, [Initial_Status] ASC)
    INCLUDE([Case_AutoId], [Case_Id], [Case_Code], [Provider_Id], [Accident_Date], [Claim_Amount], [InsuranceCompany_Id], [InjuredParty_LastName], [InjuredParty_FirstName], [InsuredParty_LastName], [InsuredParty_FirstName], [Paid_Amount], [Policy_Number], [Ins_Claim_Number], [Status], [DenialReasons_Type], [Date_Status_Changed]);


GO
CREATE NONCLUSTERED INDEX [IDX_DateBillSent]
    ON [dbo].[tblcase]([Case_Id] ASC)
    INCLUDE([Date_BillSent], [PortfolioId]);


GO
CREATE NONCLUSTERED INDEX [IDX_GrpCase]
    ON [dbo].[tblcase]([Group_Data] ASC)
    INCLUDE([Group_Id]);


GO
CREATE NONCLUSTERED INDEX [IDX_LAWFirm]
    ON [dbo].[tblcase]([GB_LawFirm_ID] ASC)
    INCLUDE([Case_Id], [GB_CASE_ID], [GB_COMPANY_ID], [GB_CASE_NO], [DomainId]);


GO
CREATE NONCLUSTERED INDEX [IDX_PacketSearch]
    ON [dbo].[tblcase]([DomainId] ASC, [FK_Packet_ID] ASC)
    INCLUDE([Case_Id], [InjuredParty_LastName], [InjuredParty_FirstName], [IsDeleted]);


GO
CREATE NONCLUSTERED INDEX [IDX_CaseQSearch]
    ON [dbo].[tblcase]([DomainId] ASC, [IndexOrAAA_Number] ASC)
    INCLUDE([Case_Id], [InjuredParty_LastName], [InjuredParty_FirstName], [IsDeleted]);


GO
CREATE NONCLUSTERED INDEX [IDX_CasePacketId]
    ON [dbo].[tblcase]([FK_Packet_ID] ASC);


GO
CREATE TRIGGER [dbo].[Trg_tblcase_OnInsert] 
   ON  dbo.tblcase 
   AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;
	
	INSERT INTO [dbo].[tbl_Case_Status_Hierarchy](Domainid, status,Case_id,Case_Auto_Id,Audit_Command,Audit_TimeStamp)
	SELECT
		DomainId,
		Status,
		Case_Id,
		Case_AutoId,
		'INSERT',
		GETDATE()
	FROM
		Inserted

END

GO
CREATE TRIGGER [dbo].[Trg_tblcase_OnUpdate] 
   ON  dbo.tblcase 
AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON;

	
--	;With cte  as(
--	select  trt.domainid, trt.CAse_id,MIn(trt.dateofservice_start) as dateofservice_start, MIn(trt.DateOfService_End) as DateOfService_End,
--	sum(isnull(trt.Claim_Amount,0.00)) as Claim_Amount, sum(isnull(trt.paid_amount,0.00)) as paid_amount,
--	sum(isnull(trt.WriteOff,0.00)) as WriteOff, sum(isnull(trt.Fee_Schedule,0.00)) as Fee_Schedule,
--Max(trt.Date_BillSent) as Date_BillSent
--from  tblTreatment trt  inner JOIN Inserted as magictable  on trt.Case_Id = magictable.case_id and trt.domainid=magictable.domainid
--group by trt.domainid, trt.case_id
--)

--update top(1) cas
--set 
--cas.dateofservice_start= trt.dateofservice_start,
--cas.DateOfService_End =  trt.DateOfService_End,
--cas.Claim_Amount =trt.Claim_Amount,
--cas.paid_amount =trt.paid_amount,
--cas.WriteOff = trt.WriteOff,
--cas.Fee_Schedule=trt.Fee_Schedule,
--cas.Date_BillSent = trt.Date_BillSent
--from tblcase cas inner join CTE as trt on cas.Case_Id = trt.Case_Id and cas.domainid=trt.domainid

    IF UPDATE(Status)
    BEGIN
		--exec F_Update_Status 		
		DECLARE @newStatus				NVARCHAR(100)
		DECLARE @oldStatus				NVARCHAR(100)
		DECLARE @status_hierarchy_new	int
		DECLARE @status_hierarchy_old	int
		DECLARE @status_bill			money
		DECLARE @status_bill_type		nvarchar(20)
		DECLARE @status_bill_notes		varchar(200)
		DECLARE @PROVIDER_ID			nvarchar(50)
		DECLARE @desc					varchar(200)		
		DECLARE @case_id				VARCHAR(50)
		DECLARE @DomainId				VARCHAR(50)

		SELECT 
			@case_id=case_id
			,@DomainId = DomainId 
			,@newStatus = Status 
		 from inserted		 
	
		SELECT @oldStatus = Status FROM Deleted
		
		IF @newStatus != @oldStatus
		BEGIN			
			SELECT	@status_bill = auto_bill_amount
					, @status_bill_type = auto_bill_type
					, @status_bill_notes=auto_bill_notes
			FROM Tblstatus (NOLOCK)
			WHERE status_type = @newStatus AND DomainId = @DomainId 				
				
				PRINT @status_bill_type
			--IF @newStatus = 'NOTICE OF TRIAL PRINTED'
			IF(ISNULL(@status_bill,0) > 0 AND ISNULL(@status_bill_type,'') <> '')
			BEGIN
				PRINT @status_bill_type
				SELECT @PROVIDER_ID = provider_id from tblcase (NOLOCK) where case_id=@case_id
				
				IF NOT EXISTS(SELECT Case_Id FROM TBLTRANSACTIONS (NOLOCK) WHERE CASE_ID=@case_id and TRANSACTIONS_DESCRIPTION=@status_bill_notes AND DomainId = @DomainId)
				BEGIN
					PRINT @status_bill_type
					INSERT INTO TBLTRANSACTIONS(DomainId,CASE_ID,TRANSACTIONS_TYPE,TRANSACTIONS_DATE,TRANSACTIONS_AMOUNT,TRANSACTIONS_DESCRIPTION,PROVIDER_ID,TRANSACTIONS_FEE,USER_ID)
					VALUES (@DomainId,@case_id,@status_bill_type,GETDATE(),@status_bill,@status_bill_notes,@PROVIDER_ID,@status_bill,'system')

					set @desc = 'Payment/Transaction posted :'+ CONVERT(VARCHAR(20),@status_bill) +' '+'('+ @status_bill_type +') Desc-> ' + @status_bill_notes + '. New Status-> '+ @newStatus + ' .' 
					exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id='system',@ApplyToGroup = 0
				END
			END

		    INSERT INTO [dbo].[tbl_Case_Status_Hierarchy](DomainId, status,Case_id,Case_Auto_Id,Audit_Command,Audit_TimeStamp)
		    SELECT
				DomainId,
				Status,
				Case_Id,
				Case_AutoId,
				'UPDATE',
				GETDATE()
			FROM
				Inserted

				 if exists(select inserted.Status from inserted where status='AAA - FILED - GB' and DomainId='AF')
				 BEGIN
				 if exists(select Case_Id from tblcase (NOLOCK) where Date_AAA_Arb_Filed is NULL and case_id = @case_id and DomainId='AF')
				 BEGIN
				 UPDATE top(1) tblcase
				 SET Date_AAA_Arb_Filed= getdate() 
				 where Date_AAA_Arb_Filed is NULL and case_id = @case_id and DomainId='AF'
				 END
				 END

				
			UPDATE 
				tblCase 
			SET 
				Old_Status = deleted.Status,
				date_status_changed = getdate() 
			FROM 
				tblCase inner join  deleted on tblcase.Case_Id=deleted.Case_Id 
			WHERE
				tblCase.Case_Id = deleted.Case_Id				

			SELECT  
				@status_hierarchy_new=tblstatus.Status_Hierarchy
			FROM         
				tblStatus 
				INNER JOIN inserted ON tblStatus.Status_Type = inserted.Status
	  
			SELECT  
				@status_hierarchy_old=tblstatus.Status_Hierarchy
			FROM         
				tblStatus 
			INNER JOIN
				 deleted ON tblStatus.Status_Type = deleted.Status
	                      		  
			--IF  @status_hierarchy_new =1000 and @status_hierarchy_old<1000
			IF @newStatus  like '%CLOSED%' --and @status_hierarchy_old<1000
			BEGIN
			  update tblcase
			  set Date_Closed =GETDATE()
			  where Case_Id=@case_id
			END
		END

		----      update  Rebuttal_Status date changed
		IF UPDATE(Rebuttal_Status)
		BEGIN
			UPDATE 
					tblCase 
				SET 
					Date_Rebuttal_Status_Changed = getdate() 
				FROM 
					tblCase inner join  deleted on tblcase.Case_Id=deleted.Case_Id 
				WHERE
					tblCase.Case_Id = deleted.Case_Id
		END		
	END	


	   
		


END
