CREATE TABLE [dbo].[tblTriggerCC] (
    [AutoID]        INT           IDENTITY (1, 1) NOT NULL,
    [TriggerTypeId] INT           NULL,
    [UserID]        INT           NULL,
    [DomainId]      VARCHAR (150) NULL,
    CONSTRAINT [PK_tblTriggerCC] PRIMARY KEY CLUSTERED ([AutoID] ASC)
);

