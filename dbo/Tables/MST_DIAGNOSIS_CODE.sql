﻿CREATE TABLE [dbo].[MST_DIAGNOSIS_CODE] (
    [SZ_DIAGNOSIS_CODE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [SZ_DIAGNOSIS_CODE]    NVARCHAR (100) NOT NULL,
    [SZ_DESCRIPTION]       NVARCHAR (500) NULL,
    [SZ_DIAGNOSIS_TYPE_ID] NVARCHAR (20)  NULL,
    [DomainId]             NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_MST_DIAGNOSIS_CODE] PRIMARY KEY CLUSTERED ([SZ_DIAGNOSIS_CODE_ID] ASC)
);

