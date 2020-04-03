CREATE TABLE [dbo].[MergedCasesFiles] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [JobId]              INT           NOT NULL,
    [CaseId]             VARCHAR (MAX) NOT NULL,
    [ProcessedCaseId]    VARCHAR (MAX) NULL,
    [NonProcessedCaseId] VARCHAR (MAX) NULL,
    [NodeName]           VARCHAR (200) NOT NULL,
    [FileName]           VARCHAR (200) NULL,
    [Status]             VARCHAR (50)  NOT NULL,
    [DateCreated]        DATETIME      NOT NULL,
    [CreatedBy]          VARCHAR (100) NOT NULL,
    [DomainId]           VARCHAR (20)  NOT NULL,
    CONSTRAINT [PK_MergedCasesFiles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

