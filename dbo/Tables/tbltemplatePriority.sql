CREATE TABLE [dbo].[tbltemplatePriority] (
    [Priority_Id] INT IDENTITY (1, 1) NOT NULL,
    [Process_Id]  INT NULL,
    [Document_Id] INT NULL,
    [Priority]    INT NULL,
    CONSTRAINT [FK__tbltempla__iProc__7E37BEF6] FOREIGN KEY ([Process_Id]) REFERENCES [dbo].[tblProcess] ([Process_Id])
);

