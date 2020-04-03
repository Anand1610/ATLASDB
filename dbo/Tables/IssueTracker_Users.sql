CREATE TABLE [dbo].[IssueTracker_Users] (
    [UserId]                      INT            IDENTITY (1, 1) NOT NULL,
    [UserName]                    NVARCHAR (255) NOT NULL,
    [UserPassword]                NVARCHAR (20)  NULL,
    [RoleId]                      INT            NOT NULL,
    [Email]                       NVARCHAR (255) CONSTRAINT [DF_IssueTracker_Users_Email] DEFAULT (N'a@b.com') NULL,
    [DisplayName]                 NVARCHAR (50)  NOT NULL,
    [UserTypeLogin]               NVARCHAR (100) NULL,
    [UserType]                    NVARCHAR (10)  CONSTRAINT [DF_IssueTracker_Users_UserType] DEFAULT ('S') NULL,
    [IsActive]                    BIT            CONSTRAINT [DF_IssueTracker_Users_IsActive] DEFAULT ((1)) NOT NULL,
    [bit_for_reports_case_search] BIT            NULL,
    [bit_for_Provider_Cases]      BIT            NULL,
    [last_name]                   NVARCHAR (200) NULL,
    [first_name]                  NVARCHAR (200) NULL,
    [UserRole]                    NVARCHAR (200) NULL,
    [DomainId]                    NVARCHAR (50)  CONSTRAINT [DF_IssueTracker_Users_DomainId] DEFAULT (N'dk') NULL,
    [ProviderId]                  INT            NULL,
    [IsSecretary]                 BIT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_IssueTracker_Users] PRIMARY KEY CLUSTERED ([UserId] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[IssueTracker_Users]([DomainId] ASC);

