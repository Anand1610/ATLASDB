CREATE TABLE [dbo].[tblEventType] (
    [EventTypeId]      INT            IDENTITY (1, 1) NOT NULL,
    [EventTypeName]    VARCHAR (100)  NOT NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       CONSTRAINT [DF_tblEventType_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    [EventTypeId_Old]  INT            NULL
);


GO
CREATE CLUSTERED INDEX [CIDX_tblEventType]
    ON [dbo].[tblEventType]([EventTypeId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblEventType_EventTypeName]
    ON [dbo].[tblEventType]([EventTypeName] ASC, [DomainId] ASC)
    INCLUDE([EventTypeId], [EventTypeId_Old]);

