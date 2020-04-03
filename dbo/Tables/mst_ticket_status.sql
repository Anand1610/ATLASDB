CREATE TABLE [dbo].[mst_ticket_status] (
    [i_status_id]    INT           IDENTITY (1, 1) NOT NULL,
    [sz_status]      NVARCHAR (40) NOT NULL,
    [sz_status_code] CHAR (3)      NOT NULL,
    PRIMARY KEY CLUSTERED ([i_status_id] ASC) WITH (FILLFACTOR = 80),
    UNIQUE NONCLUSTERED ([sz_status] ASC) WITH (FILLFACTOR = 80),
    UNIQUE NONCLUSTERED ([sz_status_code] ASC) WITH (FILLFACTOR = 80)
);

