﻿CREATE TABLE [dbo].[TXN_EXHIBIT] (
    [EXHIBIT_SEQ]  INT            NULL,
    [EXHIBIT_NAME] NVARCHAR (100) NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

