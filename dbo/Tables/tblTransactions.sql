CREATE TABLE [dbo].[tblTransactions] (
    [Transactions_Id]          INT             IDENTITY (1, 1) NOT NULL,
    [Case_Id]                  NVARCHAR (50)   NOT NULL,
    [Transactions_Type]        NVARCHAR (20)   NOT NULL,
    [Transactions_Date]        SMALLDATETIME   NOT NULL,
    [Transactions_Amount]      MONEY           NOT NULL,
    [Transactions_Description] NVARCHAR (255)  NULL,
    [Provider_Id]              NVARCHAR (50)   NOT NULL,
    [User_Id]                  VARCHAR (50)    NOT NULL,
    [Transactions_Fee]         MONEY           CONSTRAINT [DF_tblTransactions_Transactions_Fee] DEFAULT ((0.00)) NOT NULL,
    [Transactions_status]      VARCHAR (50)    NULL,
    [Invoice_Id]               INT             CONSTRAINT [DF_tblTransactions_Invoice_Id] DEFAULT ((0)) NULL,
    [Rfund_Deposite_Amount]    NUMERIC (18, 2) NULL,
    [Rfund_Deposite_Number]    VARCHAR (50)    NULL,
    [Rfund_Batch]              INT             NULL,
    [Rfund_Settled_Amount]     NUMERIC (18, 2) NULL,
    [FF_Paid_By]               VARCHAR (50)    NULL,
    [Posted_Date]              DATETIME        CONSTRAINT [DF_tblTransactions_Posted_Date] DEFAULT (getdate()) NULL,
    [DomainId]                 NVARCHAR (512)  CONSTRAINT [DF__tblTransa__Domai__0B27A5C0] DEFAULT ('h1') NOT NULL,
    [ChequeNo]                 NVARCHAR (50)   NULL,
    [CheckDate]                DATETIME        NULL,
    [BatchNo]                  VARCHAR (100)   NULL,
    [TreatmentIds]             VARCHAR (500)   NULL,
    [Transactions_Id_OLD]      INT             NULL,
    CONSTRAINT [PK_tblTransactions] PRIMARY KEY CLUSTERED ([DomainId] ASC, [Case_Id] ASC, [Transactions_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTransactions_caseid]
    ON [dbo].[tblTransactions]([DomainId] ASC, [Case_Id] ASC, [Transactions_Type] ASC)
    INCLUDE([Transactions_Amount]);


GO
CREATE NONCLUSTERED INDEX [idx_tblTransactions_tranDate]
    ON [dbo].[tblTransactions]([Transactions_Date] ASC)
    INCLUDE([Transactions_Id], [Case_Id], [Transactions_Type], [Transactions_Amount], [Transactions_Description], [User_Id], [ChequeNo], [CheckDate], [BatchNo]);


GO
CREATE NONCLUSTERED INDEX [IDX_TransDetails]
    ON [dbo].[tblTransactions]([Case_Id] ASC, [Transactions_Type] ASC, [Transactions_status] ASC);

