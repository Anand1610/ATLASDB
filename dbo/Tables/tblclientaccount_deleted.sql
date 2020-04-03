CREATE TABLE [dbo].[tblclientaccount_deleted] (
    [Account_Id]        INT            NULL,
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
    [Rebuttal_Fee]      MONEY          NULL
);

