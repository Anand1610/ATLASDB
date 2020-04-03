CREATE TABLE [dbo].[tblClientAccount_rfa_import_temp] (
    [Account_Id]        INT          NOT NULL,
    [Provider_Id]       INT          NULL,
    [Gross_Amount]      MONEY        NULL,
    [Firm_Fees]         MONEY        NULL,
    [Cost_Balance]      MONEY        NULL,
    [Applied_Cost]      MONEY        NULL,
    [Final_Remit]       MONEY        NULL,
    [Account_Date]      DATETIME     NULL,
    [Invoice_Image]     NTEXT        NULL,
    [Last_Printed]      DATETIME     NULL,
    [Prev_Cost_Balance] MONEY        NULL,
    [Split_Invoice_Id]  INT          NULL,
    [FFB_RFA]           MONEY        NULL,
    [FFB_FHKP]          MONEY        NULL,
    [FFC]               MONEY        NULL,
    [CRED]              MONEY        NULL,
    [FreezeBY]          VARCHAR (50) NULL
);

