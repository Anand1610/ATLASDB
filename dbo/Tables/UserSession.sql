CREATE TABLE [dbo].[UserSession] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [SessionID]  VARCHAR (500) NULL,
    [domainID]   VARCHAR (50)  NULL,
    [CreateDate] DATETIME      DEFAULT (getdate()) NULL,
    [UserId]     INT           NULL
);

