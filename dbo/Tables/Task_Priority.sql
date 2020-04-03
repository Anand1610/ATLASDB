CREATE TABLE [dbo].[Task_Priority] (
    [Priority_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [Description]  NVARCHAR (100) NULL,
    [Comments]     NVARCHAR (100) NULL,
    [Created_Date] DATETIME       CONSTRAINT [DF_Task_Priority_Created_Date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Task_Priority] PRIMARY KEY CLUSTERED ([Priority_ID] ASC)
);

