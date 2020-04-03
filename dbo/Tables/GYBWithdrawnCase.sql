CREATE TABLE [dbo].[GYBWithdrawnCase] (
    [ID]                       BIGINT        IDENTITY (1, 1) NOT NULL,
    [GYBCaseWithdrawlID]       BIGINT        NULL,
    [BillNumber]               NVARCHAR (20) NULL,
    [CompanyID]                NVARCHAR (20) NULL,
    [LawFirmID]                NVARCHAR (20) NULL,
    [DateWithdrawnInGYB]       DATETIME      NULL,
    [DateCreated]              DATETIME      DEFAULT (getdate()) NULL,
    [IsProcessedInLawSpades]   BIT           NULL,
    [DateProcessedInLawSpades] DATETIME      NULL,
    [IsSyncedToGYB]            BIT           NULL,
    [DateSyncedToGYB]          DATETIME      NULL,
    [SourceApplication]        VARCHAR (100) NULL,
    [LawSpadesCaseID]          VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

