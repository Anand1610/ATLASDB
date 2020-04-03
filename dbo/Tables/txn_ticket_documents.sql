CREATE TABLE [dbo].[txn_ticket_documents] (
    [i_id]             INT            IDENTITY (1, 1) NOT NULL,
    [bg_ticket_id]     BIGINT         NOT NULL,
    [i_thread_id]      INT            NULL,
    [sz_ticket_number] NVARCHAR (40)  NOT NULL,
    [sz_file_name]     NVARCHAR (255) NOT NULL,
    [sz_file_path]     NVARCHAR (MAX) NOT NULL,
    [dt_created]       DATETIME       NULL,
    CONSTRAINT [PK__txn_tick__EA81CFA6735BD47E] PRIMARY KEY CLUSTERED ([i_id] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK__txn_ticke__bg_ti__75441CF0] FOREIGN KEY ([bg_ticket_id]) REFERENCES [dbo].[mst_ticket] ([bg_ticket_id]),
    CONSTRAINT [FK__txn_ticke__i_thr__76384129] FOREIGN KEY ([i_thread_id]) REFERENCES [dbo].[txn_ticket_thread] ([i_thread_id])
);

