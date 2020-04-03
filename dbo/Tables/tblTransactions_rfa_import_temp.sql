CREATE TABLE [dbo].[tblTransactions_rfa_import_temp] (
    [Transactions_Id]          INT             NOT NULL,
    [Case_Id]                  NVARCHAR (50)   NOT NULL,
    [Transactions_Type]        NVARCHAR (20)   NOT NULL,
    [Transactions_Date]        SMALLDATETIME   NOT NULL,
    [Transactions_Amount]      MONEY           NOT NULL,
    [Transactions_Description] NVARCHAR (255)  NULL,
    [Provider_Id]              INT             NULL,
    [User_Id]                  VARCHAR (50)    NOT NULL,
    [Transactions_Fee]         MONEY           NOT NULL,
    [Transactions_status]      VARCHAR (50)    NULL,
    [Invoice_Id]               INT             NULL,
    [Rfund_Deposite_Amount]    MONEY           NULL,
    [FF_Paid_By]               VARCHAR (50)    NULL,
    [Invoice_Id2]              INT             NULL,
    [Rfund_Settled_Amount]     MONEY           NULL,
    [Rfund_Batch]              INT             NULL,
    [Check_Date]               DATETIME        NULL,
    [Check_Number]             NVARCHAR (4000) NULL,
    [ChequeNo]                 NVARCHAR (200)  NULL,
    [CheckDate]                DATETIME        NULL,
    [BatchNo]                  NVARCHAR (200)  NULL
);

