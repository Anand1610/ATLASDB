﻿CREATE TABLE [dbo].[tblREJECTION_REQUEST] (
    [AUTO_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [CASE_ID]  NVARCHAR (50)  NOT NULL,
    [LIST_ID]  INT            NOT NULL,
    [DomainId] NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

