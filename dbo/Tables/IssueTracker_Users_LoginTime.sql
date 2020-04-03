CREATE TABLE [dbo].[IssueTracker_Users_LoginTime] (
    [AutoId]      INT            IDENTITY (1, 1) NOT NULL,
    [UserId]      NVARCHAR (50)  NULL,
    [Login_Time]  DATETIME       NULL,
    [Logout_time] DATETIME       NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

