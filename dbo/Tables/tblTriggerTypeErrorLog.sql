CREATE TABLE [dbo].[tblTriggerTypeErrorLog] (
    [AutoID]                      INT           IDENTITY (1, 1) NOT NULL,
    [QueueSourceId]               INT           NULL,
    [EmailTo]                     VARCHAR (MAX) NULL,
    [Subject]                     VARCHAR (MAX) NULL,
    [EmailBody]                   VARCHAR (MAX) NULL,
    [SentOn]                      DATETIME      NULL,
    [UnknownTags]                 VARCHAR (MAX) NULL,
    [ReplacementValueMissingTags] VARCHAR (MAX) NULL,
    [IsResolved]                  BIT           NULL,
    [QueueType]                   INT           NULL,
    [CaseId]                      VARCHAR (250) NULL,
    [DomainId]                    VARCHAR (250) NULL,
    [ResolvedBy]                  VARCHAR (MAX) NULL,
    [ResolvedDate]                DATETIME      NULL,
    [EmailErrorMessage]           VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblTriggerTypeErrorLog] PRIMARY KEY CLUSTERED ([AutoID] ASC)
);

