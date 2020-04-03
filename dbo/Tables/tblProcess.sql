CREATE TABLE [dbo].[tblProcess] (
    [Process_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Process_Name]      VARCHAR (100)  NOT NULL,
    [Process_Desc]      NVARCHAR (300) NULL,
    [Process_SQL]       NVARCHAR (500) NULL,
    [Process_Debug]     BIT            NULL,
    [Process_Date]      DATETIME       NULL,
    [Process_SQLFields] NVARCHAR (500) NULL,
    [Template]          NVARCHAR (100) NULL,
    [Replacements]      NVARCHAR (100) NULL,
    [Copies]            INT            NULL,
    [Exhibits]          BIT            NULL,
    [DomainId]          NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [pkProcessID] PRIMARY KEY CLUSTERED ([Process_Id] ASC) WITH (FILLFACTOR = 90)
);

