CREATE TABLE [dbo].[Task_Status] (
    [Task_Status_ID] INT            IDENTITY (1, 1) NOT NULL,
    [Description]    NVARCHAR (100) NULL,
    [Comments]       NVARCHAR (100) NULL,
    [Created_Date]   DATETIME       CONSTRAINT [DF_Task_Status_Created_Date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Task_Status] PRIMARY KEY CLUSTERED ([Task_Status_ID] ASC)
);

