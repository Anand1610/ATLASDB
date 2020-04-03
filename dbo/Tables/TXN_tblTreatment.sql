CREATE TABLE [dbo].[TXN_tblTreatment] (
    [I_txn_Treatment_Id] INT            IDENTITY (1, 1) NOT NULL,
    [Treatment_Id]       INT            NOT NULL,
    [DenialReasons_Id]   INT            NOT NULL,
    [Action_Type]        NVARCHAR (100) NULL,
    [DomainId]           NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [DenialReasons_Date] DATETIME       NULL,
    [IMEDate]            DATETIME       NULL,
    [NOTES]              VARCHAR (2000) NULL,
    [Denial_Posted_Date] DATETIME       CONSTRAINT [DF_TXN_tblTreatment_Denial_Posted_Date] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TXN_tblTreatment] PRIMARY KEY CLUSTERED ([I_txn_Treatment_Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_TXN_Treatment]
    ON [dbo].[TXN_tblTreatment]([Treatment_Id] ASC)
    INCLUDE([DenialReasons_Id], [Action_Type], [DomainId], [DenialReasons_Date], [IMEDate], [NOTES], [Denial_Posted_Date]);

