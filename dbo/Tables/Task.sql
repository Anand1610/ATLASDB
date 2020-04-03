CREATE TABLE [dbo].[Task] (
    [Task_ID]           INT            IDENTITY (1, 1) NOT NULL,
    [DomainID]          VARCHAR (50)   NULL,
    [Case_ID]           VARCHAR (50)   NULL,
    [Task_Type_ID]      INT            NULL,
    [Priority_ID]       INT            NULL,
    [Task_Status_ID]    INT            NULL,
    [Assign_User_ID]    INT            NULL,
    [TaskDate]          DATETIME       NULL,
    [Reminder]          BIT            NULL,
    [ReminderDateTime]  DATETIME       NULL,
    [Comments]          NVARCHAR (MAX) NULL,
    [CreatedDate]       DATETIME       NULL,
    [RevisedDate]       DATETIME       NULL,
    [Created_User_ID]   INT            NULL,
    [Revised_User_ID]   INT            NULL,
    [Completed_Date]    DATETIME       NULL,
    [Completed_By_User] INT            NULL,
    [DueDate]           DATETIME       NULL,
    CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED ([Task_ID] ASC)
);

