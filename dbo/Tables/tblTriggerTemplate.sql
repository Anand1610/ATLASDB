CREATE TABLE [dbo].[tblTriggerTemplate] (
    [AutoId]        INT          IDENTITY (1, 1) NOT NULL,
    [TriggerTypeId] INT          NULL,
    [TemplateId]    INT          NULL,
    [DomainId]      VARCHAR (50) NULL,
    CONSTRAINT [PK_tblTriggerTemplate] PRIMARY KEY CLUSTERED ([AutoId] ASC)
);

