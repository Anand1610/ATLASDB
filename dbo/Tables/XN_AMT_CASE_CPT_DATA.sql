CREATE TABLE [dbo].[XN_AMT_CASE_CPT_DATA] (
    [ACCOUNT NUMBER_x] FLOAT (53)     NULL,
    [LAST NAME]        NVARCHAR (255) NULL,
    [FIRST NAME]       NVARCHAR (255) NULL,
    [DOS_x]            DATETIME       NULL,
    [INSURANCE_x]      NVARCHAR (255) NULL,
    [COMMENT]          NVARCHAR (255) NULL,
    [CPT CODE]         FLOAT (53)     NULL,
    [Amount]           FLOAT (53)     NULL,
    [LIT or not]       NVARCHAR (255) NULL,
    [F10]              NVARCHAR (255) NULL,
    [F11]              NVARCHAR (255) NULL,
    [F12]              NVARCHAR (255) NULL,
    [F13]              NVARCHAR (255) NULL,
    [F14]              NVARCHAR (255) NULL,
    [AutoID]           INT            IDENTITY (1, 1) NOT NULL,
    [Status_Done]      VARCHAR (100)  NULL
);

