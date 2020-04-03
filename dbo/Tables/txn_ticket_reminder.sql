CREATE TABLE [dbo].[txn_ticket_reminder] (
    [i_id]         INT           IDENTITY (1, 1) NOT NULL,
    [bg_ticket_id] BIGINT        NOT NULL,
    [sz_user_name] NVARCHAR (20) NOT NULL,
    [dt_created]   DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([i_id] ASC) WITH (FILLFACTOR = 80),
    FOREIGN KEY ([bg_ticket_id]) REFERENCES [dbo].[mst_ticket] ([bg_ticket_id]),
    CONSTRAINT [pk_cmp_ticket_user] UNIQUE NONCLUSTERED ([bg_ticket_id] ASC, [sz_user_name] ASC) WITH (FILLFACTOR = 80)
);

