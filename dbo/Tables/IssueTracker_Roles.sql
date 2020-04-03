CREATE TABLE [dbo].[IssueTracker_Roles] (
    [RoleId]    INT            IDENTITY (1, 1) NOT NULL,
    [RoleName]  NVARCHAR (50)  NULL,
    [RoleLevel] INT            NULL,
    [RoleType]  NVARCHAR (50)  CONSTRAINT [DF_IssueTracker_Roles_RoleType] DEFAULT ('S') NULL,
    [DomainId]  NVARCHAR (512) NULL,
    CONSTRAINT [PK_IssueTracker_Roles] PRIMARY KEY CLUSTERED ([RoleId] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[IssueTracker_Roles]([DomainId] ASC);

