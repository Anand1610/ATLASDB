CREATE TABLE [dbo].[txn_ticket_thread] (
    [i_thread_id]           INT            IDENTITY (1, 1) NOT NULL,
    [bg_ticket_id]          BIGINT         NOT NULL,
    [sz_ticket_number]      NVARCHAR (40)  NOT NULL,
    [i_status_id]           INT            NULL,
    [sz_description]        NVARCHAR (MAX) NOT NULL,
    [dt_raised_on]          DATETIME       DEFAULT (getdate()) NOT NULL,
    [sz_replied_by]         NVARCHAR (255) NULL,
    [bt_auto_closed]        BIT            NULL,
    [dt_auto_closed_date]   DATETIME       DEFAULT (getdate()) NULL,
    [dt_estimated_delivery] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([i_thread_id] ASC) WITH (FILLFACTOR = 80),
    FOREIGN KEY ([bg_ticket_id]) REFERENCES [dbo].[mst_ticket] ([bg_ticket_id]),
    FOREIGN KEY ([i_status_id]) REFERENCES [dbo].[mst_ticket_status] ([i_status_id])
);

