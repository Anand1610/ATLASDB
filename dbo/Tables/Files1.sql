﻿CREATE TABLE [dbo].[Files1] (
    [FileID]                     NVARCHAR (50)  NULL,
    [ProviderID]                 NVARCHAR (50)  NULL,
    [ProviderAccntNum]           NVARCHAR (50)  NULL,
    [InsuranceCompanyName]       NVARCHAR (100) NULL,
    [InsuranceContactName-Title] NVARCHAR (50)  NULL,
    [InsContactPhoneNumber]      NVARCHAR (30)  NULL,
    [Address]                    NVARCHAR (255) NULL,
    [City]                       NVARCHAR (50)  NULL,
    [State/PostalCode]           NVARCHAR (20)  NULL,
    [InjuredLastName]            NVARCHAR (50)  NULL,
    [InjuredFirstName]           NVARCHAR (50)  NULL,
    [InjuredAddress]             NVARCHAR (255) NULL,
    [PolicyHolderLastName]       NVARCHAR (50)  NULL,
    [PolicyHolderFirstName]      NVARCHAR (50)  NULL,
    [PolicyHolderAddress]        NVARCHAR (255) NULL,
    [DateFileOpened]             DATETIME       NULL,
    [DateFileClosed]             DATETIME       NULL,
    [ReasonFileClosed]           NVARCHAR (50)  NULL,
    [InputedbyID]                NVARCHAR (50)  NULL,
    [ClaimNumber]                NVARCHAR (50)  NULL,
    [PolicyNumber]               NVARCHAR (50)  NULL,
    [DateofLoss]                 DATETIME       NULL,
    [FirstUnpaidDateofService]   DATETIME       NULL,
    [LastUnpaidDateofService]    DATETIME       NULL,
    [IndexNo]                    NVARCHAR (50)  NULL,
    [DateOfService]              DATETIME       NULL,
    [DateInsuranceContacted]     DATETIME       NULL,
    [DateBillMailed]             DATETIME       NULL,
    [TimelyDenial]               NVARCHAR (50)  NULL,
    [DenialReceived]             BIT            NULL,
    [DenialDate]                 DATETIME       NULL,
    [Denial Reason]              NTEXT          NULL,
    [Payment Reason]             NVARCHAR (50)  NULL,
    [AccidentDescription]        NTEXT          NULL,
    [ArbAmount]                  MONEY          NULL,
    [DateAR1Sent]                DATETIME       NULL,
    [SetContactLastName]         NVARCHAR (50)  NULL,
    [SetContactFirstName]        NVARCHAR (50)  NULL,
    [Dear]                       NVARCHAR (50)  NULL,
    [PhoneNumber]                NVARCHAR (30)  NULL,
    [Extension]                  NVARCHAR (20)  NULL,
    [FaxNumber]                  NVARCHAR (30)  NULL,
    [SettledbyID]                NVARCHAR (50)  NULL,
    [SettlementDate]             DATETIME       NULL,
    [Principal]                  MONEY          NULL,
    [DatePrincipalRcvd]          DATETIME       NULL,
    [Interest]                   MONEY          NULL,
    [DateInterestRcvd]           DATETIME       NULL,
    [LegalFee]                   MONEY          NULL,
    [DateLegalFeeRcvd]           DATETIME       NULL,
    [FilingFee]                  MONEY          NULL,
    [DateFilingFeeRcvd]          DATETIME       NULL,
    [AAANumber]                  NVARCHAR (50)  NULL,
    [ArbAtty]                    NVARCHAR (50)  NULL,
    [ArbitratorID]               NVARCHAR (50)  NULL,
    [ArbDate1]                   DATETIME       NULL,
    [ArbDate1Adjourned]          BIT            NULL,
    [ArbDate2]                   DATETIME       NULL,
    [ArbDate2Adjourned]          BIT            NULL,
    [ArbDate3]                   DATETIME       NULL,
    [ArbDate3Adjourned]          BIT            NULL,
    [ArbDate4]                   DATETIME       NULL,
    [PostArbStatus]              NVARCHAR (50)  NULL,
    [AwardDate]                  DATETIME       NULL,
    [ReasonArbLost]              NVARCHAR (50)  NULL,
    [MoneyDue]                   BIT            NULL,
    [ReasonMoneyDue]             NVARCHAR (50)  NULL,
    [ConsentAward]               BIT            NULL,
    [GeneralNotes]               NTEXT          NULL,
    [PostAR1Notes]               NTEXT          NULL,
    [SettlementNotes]            NTEXT          NULL,
    [OfficeSettNotes]            NTEXT          NULL,
    [FollowupNotes]              NTEXT          NULL,
    [ReasonFileWithdrawn]        NVARCHAR (50)  NULL,
    [ReferredBy]                 NVARCHAR (50)  NULL,
    [FileType]                   NVARCHAR (50)  NULL,
    [DateReplied]                DATETIME       NULL,
    [DateAnswerRcvd]             DATETIME       NULL,
    [DocDemands]                 BIT            NULL,
    [NoticeAdmit]                BIT            NULL,
    [Interrogatories]            BIT            NULL,
    [DateOfDepot1]               DATETIME       NULL,
    [DateOfDepot2]               DATETIME       NULL,
    [DateOfDepot3]               DATETIME       NULL,
    [DateOfDepot4]               DATETIME       NULL,
    [BillParticulars]            BIT            NULL,
    [JudgeID]                    INT            NULL,
    [JudgmentDate]               DATETIME       NULL,
    [TheirFileNo]                NVARCHAR (50)  NULL,
    [MedReportDemand]            BIT            NULL,
    [SubDocDemands]              BIT            NULL,
    [SubMedReportDemand]         BIT            NULL,
    [SubNoticeAdmit]             BIT            NULL,
    [SubInterrogatories]         BIT            NULL,
    [SubBillParticulars]         BIT            NULL,
    [AdvAttyID]                  INT            NULL,
    [AttyID]                     INT            NULL,
    [TitleID]                    INT            NULL,
    [ServerID]                   INT            NULL,
    [DateServed]                 DATETIME       NULL,
    [TimeServed]                 DATETIME       NULL,
    [ReceiverID]                 INT            NULL,
    [NotaryPublicID]             INT            NULL,
    [DomainId]                   NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

