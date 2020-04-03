CREATE TABLE [dbo].[AFData] (
    [case_id]                NVARCHAR (200) NULL,
    [InjuredParty_FirstName] NVARCHAR (100) NULL,
    [InjuredParty_LastName]  NVARCHAR (100) NULL,
    [DOS_start]              DATETIME       NULL,
    [claim]                  MONEY          NULL,
    [fee_schedule]           MONEY          NULL,
    [paid]                   MONEY          NULL,
    [claim_bal]              MONEY          NULL,
    [fee_bal]                MONEY          NULL,
    [bill_no]                NVARCHAR (100) NULL,
    [claim_no]               NVARCHAR (50)  NULL,
    [ins_name]               NVARCHAR (100) NULL
);

