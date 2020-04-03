CREATE TABLE [dbo].[txn_ticket_has_unseen_notes] (
    [i_id]                INT           IDENTITY (1, 1) NOT NULL,
    [bg_ticket_id]        BIGINT        NOT NULL,
    [sz_user_name]        NVARCHAR (40) NOT NULL,
    [bt_has_unseen_notes] BIT           NULL
);

