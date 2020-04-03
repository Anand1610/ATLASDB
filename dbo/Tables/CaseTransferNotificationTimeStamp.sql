CREATE TABLE [dbo].[CaseTransferNotificationTimeStamp] (
    [Id]                   INT           IDENTITY (1, 1) NOT NULL,
    [DataElement]          VARCHAR (255) NOT NULL,
    [LastProcessTimeStamp] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

