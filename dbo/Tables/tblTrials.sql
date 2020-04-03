CREATE TABLE [dbo].[tblTrials] (
    [Trial_ID]              INT            IDENTITY (1, 1) NOT NULL,
    [CASE_ID]               NVARCHAR (50)  NOT NULL,
    [Trial_Date]            DATETIME       NULL,
    [Trial_Status]          VARCHAR (50)   NULL,
    [Trial_Result]          VARCHAR (50)   NULL,
    [Trial_Type]            VARCHAR (50)   NULL,
    [Jury_Selection_Date]   DATETIME       NULL,
    [Judge_Name]            VARCHAR (50)   NULL,
    [Notes]                 VARCHAR (200)  NULL,
    [Court_Cal_Number]      VARCHAR (50)   NULL,
    [Not_Filed_Date]        DATETIME       NULL,
    [Receipt_date]          DATETIME       NULL,
    [service_complete_date] DATETIME       NULL,
    [DomainId]              NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblTrials] PRIMARY KEY CLUSTERED ([Trial_ID] ASC) WITH (FILLFACTOR = 90)
);

