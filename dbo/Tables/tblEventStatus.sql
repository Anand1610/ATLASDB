CREATE TABLE [dbo].[tblEventStatus] (
    [EventStatusId]    INT            IDENTITY (1, 1) NOT NULL,
    [EventStatusName]  VARCHAR (200)  NOT NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       CONSTRAINT [DF_tblEventStatus_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    [EventStatus_old]  INT            NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_tblEventStatus]
    ON [dbo].[tblEventStatus]([EventStatusId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblEventStatus_EventStatusName]
    ON [dbo].[tblEventStatus]([EventStatusName] ASC, [DomainId] ASC)
    INCLUDE([EventStatusId], [EventStatus_old]);

