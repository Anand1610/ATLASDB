CREATE TABLE [dbo].[mst_ticket_sub_status] (
    [i_sub_status_id]    INT           IDENTITY (1, 1) NOT NULL,
    [sz_sub_status]      NVARCHAR (40) NULL,
    [c_code]             CHAR (3)      NULL,
    [i_display_sequence] INT           NULL,
    PRIMARY KEY CLUSTERED ([i_sub_status_id] ASC) WITH (FILLFACTOR = 80)
);

