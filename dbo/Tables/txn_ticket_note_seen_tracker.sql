CREATE TABLE [dbo].[txn_ticket_note_seen_tracker] (
    [i_id]         INT           IDENTITY (1, 1) NOT NULL,
    [i_note_id]    INT           NOT NULL,
    [bg_ticket_id] BIGINT        NULL,
    [sz_user_name] NVARCHAR (40) NOT NULL,
    [dt_created]   DATETIME      NULL,
    CONSTRAINT [pkc_i_note_id_sz_user_name] PRIMARY KEY CLUSTERED ([i_note_id] ASC, [sz_user_name] ASC) WITH (FILLFACTOR = 80)
);

