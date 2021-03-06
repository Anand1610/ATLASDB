﻿CREATE TABLE [dbo].[TXN_CASE_ASSOCIATED_DIAGNOSIS_CODE] (
    [SZ_CASE_ASSOCIATE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [SZ_DIAGNOSIS_SET_ID]  NVARCHAR (20)  NULL,
    [SZ_CASE_ID]           NVARCHAR (20)  NOT NULL,
    [SZ_DIAGNOSIS_CODE_ID] NVARCHAR (20)  NOT NULL,
    [DomainId]             NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [IX_TXN_CASE_ASSOCIATED_DIAGNOSIS_CODE] UNIQUE NONCLUSTERED ([SZ_CASE_ID] ASC, [SZ_DIAGNOSIS_CODE_ID] ASC)
);

