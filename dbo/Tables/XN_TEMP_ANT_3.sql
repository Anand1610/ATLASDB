CREATE TABLE [dbo].[XN_TEMP_ANT_3] (
    [ACCOUNT NUMBER]      FLOAT (53)     NULL,
    [LAST NAME]           NVARCHAR (255) NULL,
    [FIRST NAME]          NVARCHAR (255) NULL,
    [BILLED AMOUNT]       FLOAT (53)     NULL,
    [DOS]                 DATETIME       NULL,
    [INSURANCE]           NVARCHAR (255) NULL,
    [COMMENT]             NVARCHAR (255) NULL,
    [DOS AFTER 10 MONTHS] NVARCHAR (255) NULL,
    [DOS AFTER 12 MONTHS] NVARCHAR (255) NULL,
    [LIT or not]          NVARCHAR (255) NULL,
    [Provider]            VARCHAR (100)  NULL,
    [PurchaseDate]        VARCHAR (100)  NULL,
    [ClaimNo]             VARCHAR (100)  NULL,
    [DOL]                 VARCHAR (100)  NULL,
    [STATUS_DONE]         VARCHAR (100)  NULL,
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [TREATMENT_ID]        INT            NULL
);

