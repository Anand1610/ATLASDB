CREATE TABLE [dbo].[txn_ticket_sub_status_history] (
    [i_sub_status_history_id] INT      IDENTITY (1, 1) NOT NULL,
    [i_sub_status_id]         INT      NULL,
    [bg_ticket_id]            BIGINT   NULL,
    [dt_created]              DATETIME NULL,
    [dt_updated]              DATETIME NULL,
    PRIMARY KEY CLUSTERED ([i_sub_status_history_id] ASC) WITH (FILLFACTOR = 80)
);

