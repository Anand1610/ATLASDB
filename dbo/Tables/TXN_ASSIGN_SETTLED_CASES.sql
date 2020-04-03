CREATE TABLE [dbo].[TXN_ASSIGN_SETTLED_CASES] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [CASE_ID]      NVARCHAR (100) NOT NULL,
    [USER_ID]      NVARCHAR (100) NOT NULL,
    [DATE_CHANGED] DATETIME       NOT NULL,
    [isChanged]    INT            NOT NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

