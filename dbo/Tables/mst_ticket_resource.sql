CREATE TABLE [dbo].[mst_ticket_resource] (
    [sz_user_name]     NVARCHAR (50) NULL,
    [sz_friendly_name] NVARCHAR (50) NULL,
    [dt_created_on]    DATETIME      NULL,
    [dt_updated_on]    DATETIME      NULL,
    [bt_active]        BIT           NULL,
    [i_resource_id]    INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_mst_ticket_resource] PRIMARY KEY CLUSTERED ([i_resource_id] ASC) WITH (FILLFACTOR = 80)
);

