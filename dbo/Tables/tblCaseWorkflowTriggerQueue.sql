CREATE TABLE [dbo].[tblCaseWorkflowTriggerQueue] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [Case_Id]         VARCHAR (100) NULL,
    [DomainId]        VARCHAR (100) NULL,
    [TriggerTypeId]   INT           NOT NULL,
    [EmailTo]         VARCHAR (250) NULL,
    [EmailCC]         VARCHAR (250) NULL,
    [EmailBCC]        VARCHAR (250) NULL,
    [EmailSubject]    VARCHAR (500) NULL,
    [EmailBody]       VARCHAR (MAX) NULL,
    [InProgress]      BIT           NULL,
    [IsProcessed]     BIT           NULL,
    [ProcessedDate]   DATETIME      NULL,
    [CreatedBy]       VARCHAR (100) NULL,
    [CreatedDate]     DATETIME      NULL,
    [IsDeleted]       BIT           DEFAULT ((0)) NULL,
    [MotionMappingId] INT           NULL,
    CONSTRAINT [PK_tblCaseWorkflowTriggerQueue] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblCaseWorkflowTriggerQueue_TriggerTypeId_tblTriggerType] FOREIGN KEY ([TriggerTypeId]) REFERENCES [dbo].[tblTriggerType] ([Id])
);

