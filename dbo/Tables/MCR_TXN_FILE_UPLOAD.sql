﻿CREATE TABLE [dbo].[MCR_TXN_FILE_UPLOAD] (
    [I_TRANSACTION_ID]    INT             IDENTITY (1, 1) NOT NULL,
    [SZ_CASE_ID]          NVARCHAR (50)   NOT NULL,
    [SZ_USER_NAME]        NVARCHAR (20)   NOT NULL,
    [DT_UPLOAD_TIME]      DATETIME        DEFAULT (getdate()) NOT NULL,
    [SZ_PROCESS_ID]       NVARCHAR (10)   NOT NULL,
    [SZ_FILENAME]         NVARCHAR (255)  NOT NULL,
    [SZ_UPLOAD_LOCATION]  NVARCHAR (500)  NOT NULL,
    [I_UPLOAD_STATUS]     INT             NOT NULL,
    [SZ_PROCESSING_ERROR] NVARCHAR (2000) NULL,
    [DomainId]            NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

