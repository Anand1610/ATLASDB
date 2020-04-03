CREATE TABLE [dbo].[Case_Delete_Log] (
    [LogId]        INT            IDENTITY (1, 1) NOT NULL,
    [Log_Desc]     VARCHAR (4000) NULL,
    [Case_Id]      NVARCHAR (50)  NULL,
    [User_Id]      NVARCHAR (50)  NULL,
    [Deleted_Date] DATETIME       NULL,
    [DomainId]     VARCHAR (50)   NULL,
    CONSTRAINT [PK_Case_Delete_Log] PRIMARY KEY CLUSTERED ([LogId] ASC)
);

