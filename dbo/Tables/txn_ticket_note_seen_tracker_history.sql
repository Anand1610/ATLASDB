CREATE TABLE [dbo].[txn_ticket_note_seen_tracker_history] (
    [i_id]         INT           IDENTITY (1, 1) NOT NULL,
    [i_note_id]    INT           NOT NULL,
    [bg_ticket_id] BIGINT        NOT NULL,
    [sz_user_name] NVARCHAR (40) NOT NULL,
    [dt_created]   DATETIME      NOT NULL,
    CONSTRAINT [pkc1_i_note_id_sz_user_name] PRIMARY KEY CLUSTERED ([i_note_id] ASC, [sz_user_name] ASC) WITH (FILLFACTOR = 80)
);

