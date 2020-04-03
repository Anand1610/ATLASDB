CREATE TABLE [dbo].[tblTriggerType] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (100) NULL,
    [DomainId]         VARCHAR (100) NULL,
    [AssociatedEntity] VARCHAR (500) NULL,
    CONSTRAINT [PK_tblTriggerType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

