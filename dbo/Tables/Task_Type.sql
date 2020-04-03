CREATE TABLE [dbo].[Task_Type] (
    [Task_Type_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [DomainID]         VARCHAR (50)   NOT NULL,
    [Description]      NVARCHAR (100) NOT NULL,
    [Comments]         NVARCHAR (100) NULL,
    [Deadline_Day]     VARCHAR (10)   NULL,
    [created_by_user]  NVARCHAR (255) CONSTRAINT [DF__Task_Type__creat__2784B8A3] DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       CONSTRAINT [DF_task_Type_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    [Task_Type_ID_Old] INT            NULL,
    CONSTRAINT [PK_task_Type] PRIMARY KEY CLUSTERED ([DomainID] ASC, [Description] ASC)
);

