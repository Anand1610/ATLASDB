﻿CREATE TABLE [dbo].[tblAttorney] (
    [Attorney_AutoId]     INT            IDENTITY (1, 1) NOT NULL,
    [Attorney_Id]         VARCHAR (40)   NOT NULL,
    [Attorney_LastName]   VARCHAR (100)  NULL,
    [Attorney_FirstName]  VARCHAR (100)  NULL,
    [Attorney_Address]    VARCHAR (255)  NULL,
    [Attorney_City]       VARCHAR (50)   NULL,
    [Attorney_State]      VARCHAR (50)   NULL,
    [Attorney_Zip]        VARCHAR (50)   NULL,
    [Attorney_Phone]      VARCHAR (20)   NULL,
    [Attorney_Fax]        VARCHAR (20)   NULL,
    [Attorney_Email]      VARCHAR (40)   NULL,
    [Defendant_Id]        NVARCHAR (50)  NOT NULL,
    [DomainId]            NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]     NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]        DATETIME       NULL,
    [modified_by_user]    NVARCHAR (255) NULL,
    [modified_date]       DATETIME       NULL,
    [Attorney_AutoId_OLD] INT            NULL,
    CONSTRAINT [PK_tblAttorney] PRIMARY KEY CLUSTERED ([Attorney_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblAttorney]([DomainId] ASC);

