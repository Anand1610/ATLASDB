CREATE TABLE [dbo].[Required_Documents] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [DomainID]         VARCHAR (50)   DEFAULT ('h1') NOT NULL,
    [Case_ID]          VARCHAR (50)   NOT NULL,
    [DocumentType]     VARCHAR (1000) NOT NULL,
    [ReminderDate]     DATETIME       NULL,
    [created_by_user]  VARCHAR (250)  NOT NULL,
    [created_date]     DATETIME       DEFAULT (getdate()) NULL,
    [modified_by_user] VARCHAR (250)  NULL,
    [modified_date]    DATETIME       NULL,
    [Message]          VARCHAR (4000) NULL,
    [isCompleted]      BIT            DEFAULT ((0)) NULL,
    [Complted_Date]    DATETIME       NULL
);

