CREATE TABLE [dbo].[tblEvent] (
    [Event_id]      INT            IDENTITY (1, 1) NOT NULL,
    [Case_id]       NVARCHAR (100) NULL,
    [EventTypeId]   INT            NOT NULL,
    [EventStatusId] INT            NOT NULL,
    [Event_Date]    DATETIME       NOT NULL,
    [Event_Time]    DATETIME       NULL,
    [Event_Notes]   VARCHAR (500)  NULL,
    [Assigned_To]   VARCHAR (MAX)  NULL,
    [User_id]       VARCHAR (500)  NULL,
    [DRP_Id]        INT            NULL,
    [arbitrator_id] INT            NULL,
    [Status]        BIT            CONSTRAINT [DF_tblEvent_Status] DEFAULT ((0)) NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [fk_event_arbitrator_id] FOREIGN KEY ([arbitrator_id]) REFERENCES [dbo].[TblArbitrator] ([ARBITRATOR_ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_tblEvent]
    ON [dbo].[tblEvent]([Event_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblEvent_CaseId]
    ON [dbo].[tblEvent]([Case_id] ASC, [Event_Date] ASC)
    INCLUDE([Event_id], [EventTypeId], [EventStatusId], [Event_Time], [Event_Notes]);

