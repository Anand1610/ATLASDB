CREATE TABLE [dbo].[tbl_display_column] (
    [pk_display_column_id] INT            IDENTITY (1, 1) NOT NULL,
    [display_name]         NVARCHAR (100) NOT NULL,
    [table_column]         NVARCHAR (100) NOT NULL,
    [is_default]           BIT            NULL,
    [column_order]         INT            NULL,
    CONSTRAINT [PK_tbl_display_column] PRIMARY KEY CLUSTERED ([pk_display_column_id] ASC)
);

