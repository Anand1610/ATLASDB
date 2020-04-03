CREATE TABLE [dbo].[tblUserStatus] (
    [UserStatusID] INT            IDENTITY (1, 1) NOT NULL,
    [userid]       NVARCHAR (100) NULL,
    [username]     NVARCHAR (255) NULL,
    [Status]       NVARCHAR (500) NULL,
    [CriticalDays] NVARCHAR (100) NULL,
    [DomainId]     NVARCHAR (50)  CONSTRAINT [DF_tblUserStatus_DomainId] DEFAULT (N'dk') NULL,
    [StatusType]   VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([UserStatusID] ASC)
);

