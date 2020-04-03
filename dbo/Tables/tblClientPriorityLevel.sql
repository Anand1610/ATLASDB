CREATE TABLE [dbo].[tblClientPriorityLevel] (
    [PK_ClientPriority_Level_ID] INT           IDENTITY (0, 1) NOT NULL,
    [CLIENTPRIORITY_LEVEL_NAME]  VARCHAR (255) NOT NULL,
    [IsActive]                   INT           NULL,
    [DomainID]                   VARCHAR (20)  NULL,
    CONSTRAINT [PK__tblClien__71A1E414304FD425] PRIMARY KEY CLUSTERED ([PK_ClientPriority_Level_ID] ASC)
);

