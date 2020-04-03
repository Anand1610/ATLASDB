CREATE TABLE [dbo].[tblClientAccount] (
    [Account_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Provider_Id]       VARCHAR (50)   NULL,
    [Gross_Amount]      MONEY          NULL,
    [Firm_Fees]         MONEY          NULL,
    [Cost_Balance]      MONEY          NULL,
    [Applied_Cost]      MONEY          NULL,
    [Final_Remit]       MONEY          NULL,
    [Account_Date]      DATETIME       NULL,
    [Invoice_Image]     NTEXT          NULL,
    [Last_Printed]      DATETIME       NULL,
    [Prev_Cost_Balance] MONEY          NULL,
    [DomainId]          NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [VENDOR_FEE]        MONEY          NULL,
    [Intrest_Due]       MONEY          NULL,
    [Expense_Due]       MONEY          NULL,
    [Account_Id_old]    INT            NULL,
    [Rebuttal_Fee]      MONEY          NULL,
    CONSTRAINT [PK_tblClientAccount] PRIMARY KEY CLUSTERED ([Account_Id] ASC) WITH (FILLFACTOR = 90)
);

