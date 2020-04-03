CREATE TABLE [dbo].[TblPending_Audit] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [PROCESSOR_NAME] VARCHAR (50)   NOT NULL,
    [CASE_COUNT]     INT            NOT NULL,
    [DateCreated]    DATETIME       NOT NULL,
    [DomainId]       NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

