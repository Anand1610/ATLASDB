CREATE TABLE [dbo].[CaseAttorneyMapping] (
    [id]         INT          IDENTITY (1, 1) NOT NULL,
    [CaseId]     VARCHAR (50) NOT NULL,
    [AttorneyId] INT          NOT NULL,
    [DomainId]   VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_CaseAttorneyMapping_IssueTracker_Users_UserId] FOREIGN KEY ([AttorneyId]) REFERENCES [dbo].[IssueTracker_Users] ([UserId])
);

