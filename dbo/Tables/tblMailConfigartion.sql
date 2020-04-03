CREATE TABLE [dbo].[tblMailConfigartion] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [SearchKeyword] VARCHAR (128) NULL,
    [DomainId]      VARCHAR (64)  NULL,
    [EmailID]       VARCHAR (64)  NULL,
    [EmailKey]      VARCHAR (256) NULL,
    [EmailServer]   VARCHAR (32)  NULL,
    [PortNo]        VARCHAR (8)   NULL,
    [ServerType]    VARCHAR (8)   NULL,
    [FolderName]    VARCHAR (16)  NULL,
    [EmailFrom]     VARCHAR (64)  NULL,
    [EmailTO]       VARCHAR (MAX) NULL,
    [EmailCC]       VARCHAR (MAX) NULL,
    [SmtpServer]    VARCHAR (32)  NULL,
    [SmtpPort]      VARCHAR (8)   NULL,
    [EmailPassword] VARCHAR (256) NULL,
    [EnableSSL]     BIT           NULL,
    [EmailFromDays] INT           NULL,
    [EmailToDays]   INT           NULL,
    [LastReadDate]  DATETIME      NULL
);

