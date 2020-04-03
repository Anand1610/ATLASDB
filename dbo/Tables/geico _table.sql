CREATE TABLE [dbo].[geico _table] (
    [Settlement_amount]   MONEY         NULL,
    [Settlement_int]      MONEY         NULL,
    [settlement_af]       MONEY         NULL,
    [settlement_ff]       MONEY         NULL,
    [settlement_total]    MONEY         NULL,
    [settlement_date]     DATETIME      NULL,
    [case_id]             VARCHAR (50)  NULL,
    [user_id]             VARCHAR (50)  NULL,
    [settledwith]         VARCHAR (50)  NULL,
    [settlement_notes]    VARCHAR (500) NULL,
    [settlement_batch]    VARCHAR (50)  NULL,
    [settlement_subbatch] VARCHAR (50)  NULL
);

