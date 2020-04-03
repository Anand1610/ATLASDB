CREATE TABLE [dbo].[mst_ticket_priority] (
    [i_priority_id]    INT           IDENTITY (1, 1) NOT NULL,
    [sz_priority]      NVARCHAR (50) NOT NULL,
    [sz_priority_code] NVARCHAR (10) NOT NULL,
    [i_ddl_sequence]   TINYINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([i_priority_id] ASC) WITH (FILLFACTOR = 80),
    UNIQUE NONCLUSTERED ([sz_priority] ASC) WITH (FILLFACTOR = 80),
    UNIQUE NONCLUSTERED ([sz_priority_code] ASC) WITH (FILLFACTOR = 80)
);

