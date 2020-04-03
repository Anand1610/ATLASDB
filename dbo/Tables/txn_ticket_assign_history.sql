CREATE TABLE [dbo].[txn_ticket_assign_history] (
    [i_id]           INT            IDENTITY (1, 1) NOT NULL,
    [bg_ticket_id]   BIGINT         NULL,
    [dt_created]     DATETIME       NULL,
    [sz_created_by]  NVARCHAR (100) NULL,
    [sz_assigned_to] NVARCHAR (200) NULL,
    CONSTRAINT [fk_tah_mt_bgtid] FOREIGN KEY ([bg_ticket_id]) REFERENCES [dbo].[mst_ticket] ([bg_ticket_id])
);

